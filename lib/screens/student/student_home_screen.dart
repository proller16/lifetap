import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../models/alert_model.dart';
import '../../models/user_model.dart';
import '../../providers/alert_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/sensor_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/panic_button.dart';

class StudentHomeScreen extends ConsumerStatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  ConsumerState<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends ConsumerState<StudentHomeScreen> {
  final SensorService _sensor = SensorService();
  Timer? _fallTimer;
  int _fallCountdown = 10;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _sensor.startListening();
      _sensor.fallDetected.listen((_) => _onFallDetected());
    }
  }

  @override
  void dispose() {
    _sensor.dispose();
    _fallTimer?.cancel();
    super.dispose();
  }

  void _onFallDetected() {
    if (!mounted) return;
    _fallTimer?.cancel();
    _fallCountdown = 10;
    _showFallDialog();
  }

  void _showFallDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _FallDialog(
        onCancel: () {
          _fallTimer?.cancel();
          Navigator.of(ctx).pop();
        },
        onConfirm: () {
          _fallTimer?.cancel();
          Navigator.of(ctx).pop();
          // FIX #2: Fall detection sí puede preguntar (es automático),
          // pero el botón pánico manual NO pide confirmación.
          _sendPanic(type: AlertType.slip);
        },
      ),
    );
  }

  // FIX #2: Se eliminó _showConfirmDialog() y la llamada a await confirmado.
  // El botón pánico ahora envía la alerta directamente sin diálogo intermedio.
  Future<void> _sendPanic({AlertType type = AlertType.other}) async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;

    try {
      final alert = await ref
          .read(alertNotifierProvider.notifier)
          .sendPanicAlert(student: user, type: type);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).panicSent),
          backgroundColor: AppTheme.successGreen,
          duration: const Duration(seconds: 4),
        ),
      );
      context.push('/student/chat/${alert.alertId}');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).panicError),
          backgroundColor: AppTheme.emergencyRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final userAsync = ref.watch(currentUserProvider);
    final alertAsync = ref.watch(alertNotifierProvider);

    return userAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
      data: (user) => LoadingOverlay(
        isLoading: alertAsync.isLoading,
        message: l.panicSending,
        child: Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            title: const Text('LIFETAP'),
            actions: [
              const LanguageToggle(),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.logout_rounded),
                tooltip: l.logout,
                onPressed: () => _confirmLogout(context),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // ── Header greeting ──────────────────────────────────────
                Container(
                  width: double.infinity,
                  decoration: AppTheme.navyGradient,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      if (user != null)
                        Text(
                          '¡Hola, ${user.name.split(' ').first}!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        l.institution,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // ── Panic button ──────────────────────────────────────────
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        PanicButton(
                          isLoading: alertAsync.isLoading,
                          onPressed: () => _sendPanic(),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l.panicButton,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color: AppTheme.emergencyRed,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l.tagline,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                // ── Quick actions ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: Row(
                    children: [
                      _QuickAction(
                        icon: Icons.report_problem_outlined,
                        label: l.reportEmergency,
                        color: AppTheme.warningOrange,
                        onTap: () => context.push('/student/report'),
                      ),
                      const SizedBox(width: 12),
                      _QuickAction(
                        icon: Icons.chat_bubble_outline_rounded,
                        label: l.emergencyChat,
                        color: AppTheme.navyDark,
                        onTap: () {
                          final alertId = ref
                              .read(alertNotifierProvider)
                              .valueOrNull
                              ?.alertId;
                          if (alertId != null) {
                            context.push('/student/chat/$alertId');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'No tienes una alerta activa')),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 12),
                      _QuickAction(
                        icon: Icons.person_outline_rounded,
                        label: l.myProfile,
                        color: AppTheme.successGreen,
                        onTap: () => context.push('/student/profile'),
                      ),
                    ],
                  ),
                ),
                // ── Fall detection badge ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.alertYellow.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppTheme.alertYellow.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.sensors_rounded,
                            color: AppTheme.warningOrange, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Detección de caídas activa',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.warningOrange,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l.logout),
        content: Text(l.logoutConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l.cancel)),
          ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l.confirm)),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(authNotifierProvider.notifier).signOut();
      if (mounted) context.go('/');
    }
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FallDialog extends StatefulWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  const _FallDialog({required this.onCancel, required this.onConfirm});

  @override
  State<_FallDialog> createState() => _FallDialogState();
}

class _FallDialogState extends State<_FallDialog> {
  int _seconds = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds <= 1) {
        t.cancel();
        widget.onConfirm();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(children: [
        const Icon(Icons.airline_seat_flat_rounded,
            color: AppTheme.warningOrange),
        const SizedBox(width: 10),
        Expanded(child: Text(l.fallDetected, style: const TextStyle(fontSize: 16))),
      ]),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l.fallBody),
          const SizedBox(height: 16),
          Text(
            l.fallCountdown(_seconds),
            style: const TextStyle(
              color: AppTheme.emergencyRed,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _seconds / 10,
            backgroundColor: AppTheme.surface,
            color: AppTheme.emergencyRed,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: widget.onCancel,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.successGreen,
            minimumSize: const Size(0, 44),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(l.panicCancel),
        ),
        OutlinedButton(
          onPressed: widget.onConfirm,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.emergencyRed,
            side: const BorderSide(color: AppTheme.emergencyRed),
            minimumSize: const Size(0, 44),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Enviar alerta'),
        ),
      ],
    );
  }
}
