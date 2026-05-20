import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/loading_overlay.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;
  String? _error;

  late AnimationController _anim;
  late Animation<double> _logoFade;
  late Animation<Offset> _formSlide;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800),
    )..forward();
    _logoFade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _formSlide = Tween<Offset>(
      begin: const Offset(0, 0.3), end: Offset.zero,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _anim.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _error = null);
    try {
      final user = await ref.read(authNotifierProvider.notifier).signIn(
        _emailCtrl.text.trim(),
        _passCtrl.text,
      );
      if (!mounted) return;
      _navigateByRole(user.role);
    } catch (e) {
      final msg = e.toString();
      String errorText;
      if (msg.contains('emailDomain')) {
        errorText = AppLocalizations.of(context).emailDomainError;
      } else if (msg.contains('wrong-password') || msg.contains('invalid-credential')) {
        errorText = 'Contraseña incorrecta. Verifica e intenta de nuevo.';
      } else if (msg.contains('user-not-found')) {
        errorText = 'No existe una cuenta con este correo.';
      } else if (msg.contains('userNotFound') || msg.contains('Firestore')) {
        errorText = 'Perfil no encontrado en Firestore. Verifica la colección "users".';
      } else if (msg.contains('network')) {
        errorText = 'Sin conexión a internet. Revisa tu red.';
      } else if (msg.contains('too-many-requests')) {
        errorText = 'Demasiados intentos. Espera unos minutos.';
      } else {
        errorText = 'Error: $msg';
      }
      setState(() => _error = errorText);
    }
  }

  void _navigateByRole(UserRole role) {
    switch (role) {
      case UserRole.student:
        context.go('/student');
      case UserRole.brigadista:
        context.go('/brigadista');
      case UserRole.admin:
        context.go('/admin');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isLoading =
        ref.watch(authNotifierProvider).isLoading;

    return LoadingOverlay(
      isLoading: isLoading,
      message: l.loggingIn,
      child: Scaffold(
        body: Stack(
          children: [
            // ── Background gradient ──────────────────────────────────────
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppTheme.navyDark, AppTheme.navyLight, Colors.white],
                  stops: [0.0, 0.45, 1.0],
                ),
              ),
            ),
            // ── Language toggle ──────────────────────────────────────────
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: const LanguageToggle(),
                ),
              ),
            ),
            // ── Content ──────────────────────────────────────────────────
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    // ── Logo ────────────────────────────────────────────
                    FadeTransition(
                      opacity: _logoFade,
                      child: Column(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.local_hospital_rounded,
                              size: 48,
                              color: AppTheme.emergencyRed,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'LIFETAP',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 6,
                                  fontSize: 36,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l.tagline,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white70,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 13,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l.institution,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // ── Form card ─────────────────────────────────────────
                    SlideTransition(
                      position: _formSlide,
                      child: FadeTransition(
                        opacity: _logoFade,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.loginTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l.loginSubtitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium,
                                ),
                                const SizedBox(height: 24),
                                // Email field
                                TextFormField(
                                  controller: _emailCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                    labelText: l.emailLabel,
                                    hintText: l.emailHint,
                                    prefixIcon: const Icon(
                                        Icons.email_outlined),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'Campo requerido';
                                    }
                                    if (!v.endsWith('@tectijuana.edu.mx')) {
                                      return l.emailDomainError;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                // Password field
                                TextFormField(
                                  controller: _passCtrl,
                                  obscureText: _obscurePass,
                                  decoration: InputDecoration(
                                    labelText: l.passwordLabel,
                                    prefixIcon:
                                        const Icon(Icons.lock_outlined),
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscurePass
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined),
                                      onPressed: () => setState(
                                          () => _obscurePass = !_obscurePass),
                                    ),
                                  ),
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Campo requerido'
                                      : null,
                                  onFieldSubmitted: (_) => _signIn(),
                                ),
                                if (_error != null) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: AppTheme.emergencyRed
                                          .withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.error_outline,
                                            size: 18,
                                            color: AppTheme.emergencyRed),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _error!,
                                            style: const TextStyle(
                                              color: AppTheme.emergencyRed,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: isLoading ? null : _signIn,
                                  child: Text(l.loginButton),
                                ),
                                const SizedBox(height: 12),
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      if (_emailCtrl.text.isNotEmpty) {
                                        ref
                                            .read(authServiceProvider)
                                            .sendPasswordReset(
                                                _emailCtrl.text);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              'Correo de recuperación enviado'),
                                        ));
                                      }
                                    },
                                    child: Text(
                                      l.forgotPassword,
                                      style: const TextStyle(
                                        color: AppTheme.navyDark,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
