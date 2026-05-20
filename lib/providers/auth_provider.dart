import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/fcm_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// ── Firebase Auth state ───────────────────────────────────────────────────
final firebaseAuthProvider = StreamProvider<User?>((ref) {
  return ref.read(authServiceProvider).authStateChanges;
});

// ── Current UserModel (live from Firestore) ───────────────────────────────
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final authAsync = ref.watch(firebaseAuthProvider);
  return authAsync.when(
    data: (user) {
      if (user == null) return const Stream.empty();
      return ref.read(authServiceProvider).userStream(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

// ── Auth Actions ──────────────────────────────────────────────────────────
class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService _service;

  AuthNotifier(this._service) : super(const AsyncValue.data(null));

  Future<UserModel> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _service.signIn(email: email, password: password);
      state = AsyncValue.data(user);
      // Subscribe brigadistas to emergency topic
      // Wrapped in try-catch: subscribeToTopic() not supported on web
      if (user.role == UserRole.brigadista) {
        try {
          await FcmService.subscribeToTopic('emergency_alerts');
        } catch (_) {
          // Safe to ignore on web / unsupported platforms
        }
      }
      return user;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    final user = state.valueOrNull;
    if (user?.role == UserRole.brigadista) {
      try {
        await FcmService.unsubscribeFromTopic('emergency_alerts');
      } catch (_) {
        // Safe to ignore on web
      }
    }
    await _service.signOut();
    state = const AsyncValue.data(null);
  }

  Future<void> updateProfile(UserModel user) async {
    await _service.updateUserProfile(user);
  }

  Future<void> setAvailability(String uid, bool available) async {
    await _service.setAvailability(uid, available);
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>(
  (ref) => AuthNotifier(ref.read(authServiceProvider)),
);
