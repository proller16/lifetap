import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/student/student_home_screen.dart';
import '../screens/student/emergency_report_screen.dart';
import '../screens/student/emergency_chat_screen.dart';
import '../screens/student/student_profile_screen.dart';
import '../screens/brigadista/brigadista_dashboard_screen.dart';
import '../screens/brigadista/alert_detail_screen.dart';
import '../screens/brigadista/brigadista_profile_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/user_management_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(firebaseAuthProvider);
  // FIX #1: También observamos el UserModel para conocer el rol
  final userAsync = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isOnLogin = state.matchedLocation == '/';

      // Si no hay sesión y no está en login → ir al login
      if (!isLoggedIn && !isOnLogin) return '/';

      // FIX #1: Si hay sesión activa y está en login → redirigir por rol automáticamente
      // Esto evita que el usuario tenga que hacer login dos veces al abrir la app
      if (isLoggedIn && isOnLogin) {
        final user = userAsync.valueOrNull;
        if (user == null) return null; // todavía cargando perfil, esperar
        switch (user.role) {
          case UserRole.student:
            return '/student';
          case UserRole.brigadista:
            return '/brigadista';
          case UserRole.admin:
            return '/admin';
        }
      }

      return null;
    },
    routes: [
      // ── Auth ──────────────────────────────────────────────────────────
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // ── Student ───────────────────────────────────────────────────────
      GoRoute(
        path: '/student',
        name: 'student-home',
        builder: (context, state) => const StudentHomeScreen(),
      ),
      GoRoute(
        path: '/student/report',
        name: 'student-report',
        builder: (context, state) => const EmergencyReportScreen(),
      ),
      GoRoute(
        path: '/student/chat/:alertId',
        name: 'student-chat',
        builder: (context, state) => EmergencyChatScreen(
          alertId: state.pathParameters['alertId']!,
        ),
      ),
      GoRoute(
        path: '/student/profile',
        name: 'student-profile',
        builder: (context, state) => const StudentProfileScreen(),
      ),

      // ── Brigadista ────────────────────────────────────────────────────
      GoRoute(
        path: '/brigadista',
        name: 'brigadista-home',
        builder: (context, state) => const BrigadistaDashboardScreen(),
      ),
      GoRoute(
        path: '/brigadista/alert/:alertId',
        name: 'brigadista-alert-detail',
        builder: (context, state) => AlertDetailScreen(
          alertId: state.pathParameters['alertId']!,
        ),
      ),
      GoRoute(
        path: '/brigadista/chat/:alertId',
        name: 'brigadista-chat',
        builder: (context, state) => EmergencyChatScreen(
          alertId: state.pathParameters['alertId']!,
        ),
      ),
      GoRoute(
        path: '/brigadista/profile',
        name: 'brigadista-profile',
        builder: (context, state) => const BrigadistaProfileScreen(),
      ),

      // ── Admin ─────────────────────────────────────────────────────────
      GoRoute(
        path: '/admin',
        name: 'admin-home',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/users',
        name: 'admin-users',
        builder: (context, state) => const UserManagementScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Página no encontrada: ${state.error}'),
      ),
    ),
  );
});
