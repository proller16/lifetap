import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../models/alert_model.dart';
import '../../providers/alert_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/location_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/alert_card.dart';
import '../../widgets/language_toggle.dart';

class BrigadistaDashboardScreen extends ConsumerStatefulWidget {
  const BrigadistaDashboardScreen({super.key});

  @override
  ConsumerState<BrigadistaDashboardScreen> createState() =>
      _BrigadistaDashboardScreenState();
}

class _BrigadistaDashboardScreenState
    extends ConsumerState<BrigadistaDashboardScreen> {
  final LocationService _locationService = LocationService();
  double? _myLat, _myLng;

  @override
  void initState() {
    super.initState();
    _locationService.getCurrentPosition().then((pos) {
      if (pos != null && mounted) {
        setState(() {
          _myLat = pos.latitude;
          _myLng = pos.longitude;
        });
      }
    });
  }

  double? _distance(AlertModel alert) {
    if (_myLat == null || _myLng == null) return null;
    return _locationService.distanceBetween(
      _myLat!,
      _myLng!,
      alert.location.latitude,
      alert.location.longitude,
    );
  }

  Future<void> _accept(AlertModel alert) async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;
    await ref
        .read(alertNotifierProvider.notifier)
        .acceptAlert(alert.alertId, user);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).accepted),
        backgroundColor: AppTheme.successGreen,
      ),
    );
    context.push('/brigadista/alert/${alert.alertId}');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final alertsAsync = ref.watch(activeAlertsProvider);
    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.activeAlerts),
        actions: [
          const LanguageToggle(),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: () => context.push('/brigadista/profile'),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Brigadista header ──────────────────────────────────────────
          Container(
            width: double.infinity,
            decoration: AppTheme.navyGradient,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white24,
                  child: const Icon(Icons.shield_rounded,
                      color: Colors.white, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Brigadista',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        user?.isAvailable == true
                            ? '🟢 ${l.onDuty}'
                            : '🔴 ${l.offDuty}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Availability toggle
                Switch(
                  value: user?.isAvailable ?? false,
                  onChanged: (v) {
                    if (user != null) {
                      ref
                          .read(authNotifierProvider.notifier)
                          .setAvailability(user.uid, v);
                    }
                  },
                  thumbColor: WidgetStateProperty.all(Colors.white),
                  trackColor: WidgetStateProperty.resolveWith(
                    (s) => s.contains(WidgetState.selected)
                        ? AppTheme.successGreen
                        : Colors.white30,
                  ),
                ),
              ],
            ),
          ),
          // ── Alerts list ───────────────────────────────────────────────
          Expanded(
            child: alertsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off_rounded,
                        size: 48, color: AppTheme.divider),
                    const SizedBox(height: 12),
                    Text('Error: $e'),
                  ],
                ),
              ),
              data: (alerts) {
                if (alerts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_outline_rounded,
                            size: 64, color: AppTheme.successGreen),
                        const SizedBox(height: 16),
                        Text(
                          l.noActiveAlerts,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Todo está en calma por ahora.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                // Sort by distance if available
                final sorted = [...alerts];
                if (_myLat != null) {
                  sorted.sort((a, b) {
                    final da = _distance(a) ?? double.infinity;
                    final db = _distance(b) ?? double.infinity;
                    return da.compareTo(db);
                  });
                }

                return RefreshIndicator(
                  onRefresh: () async =>
                      ref.invalidate(activeAlertsProvider),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: sorted.length,
                    itemBuilder: (context, i) {
                      final alert = sorted[i];
                      return AlertCard(
                        alert: alert,
                        distanceMeters: _distance(alert),
                        onAccept: alert.status == AlertStatus.pending &&
                                user?.isAvailable == true
                            ? () => _accept(alert)
                            : null,
                        onTap: () =>
                            context.push('/brigadista/alert/${alert.alertId}'),
                        showAccept:
                            alert.assignedBrigadistaId == null ||
                                alert.assignedBrigadistaId == user?.uid,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
