import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/language_toggle.dart';

class BrigadistaProfileScreen extends ConsumerWidget {
  const BrigadistaProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (user) => Scaffold(
        appBar: AppBar(
          title: Text(l.brigadistaProfile),
          actions: [
            const LanguageToggle(),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              onPressed: () async {
                await ref.read(authNotifierProvider.notifier).signOut();
                if (context.mounted) context.go('/');
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // ── Avatar ──────────────────────────────────────────────
              Center(
                child: CircleAvatar(
                  radius: 52,
                  backgroundColor: AppTheme.navyDark,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? Text(
                          user?.name.isNotEmpty == true
                              ? user!.name[0].toUpperCase()
                              : 'B',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user?.name ?? '—',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.navyDark.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shield_rounded,
                        size: 14, color: AppTheme.navyDark),
                    const SizedBox(width: 6),
                    const Text(
                      'Brigadista',
                      style: TextStyle(
                        color: AppTheme.navyDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // ── Info cards ───────────────────────────────────────────
              _InfoCard(
                icon: Icons.email_outlined,
                label: 'Correo',
                value: user?.email ?? '—',
              ),
              const SizedBox(height: 10),
              _InfoCard(
                icon: Icons.badge_outlined,
                label: l.controlNumber,
                value: user?.controlNumber.isEmpty == true
                    ? '—'
                    : user!.controlNumber,
              ),
              const SizedBox(height: 24),
              // ── Availability ────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: user?.isAvailable == true
                      ? AppTheme.successGreen.withOpacity(0.08)
                      : AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: user?.isAvailable == true
                        ? AppTheme.successGreen.withOpacity(0.3)
                        : AppTheme.divider,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sensors_rounded,
                      color: user?.isAvailable == true
                          ? AppTheme.successGreen
                          : AppTheme.textSecondary,
                      size: 28,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l.availability,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium),
                          Text(
                            user?.isAvailable == true
                                ? l.onDuty
                                : l.offDuty,
                            style: TextStyle(
                              color: user?.isAvailable == true
                                  ? AppTheme.successGreen
                                  : AppTheme.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: user?.isAvailable ?? false,
                      onChanged: (v) {
                        if (user != null) {
                          ref
                              .read(authNotifierProvider.notifier)
                              .setAvailability(user.uid, v);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.navyDark, size: 22),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: AppTheme.textSecondary)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
