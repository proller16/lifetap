import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';
import '../../models/alert_model.dart';
import '../../providers/alert_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/status_badge.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  AlertType? _typeFilter;
  AlertStatus? _statusFilter;
  DateTime? _fromDate;
  DateTime? _toDate;

  void _clearFilters() {
    setState(() {
      _typeFilter = null;
      _statusFilter = null;
      _fromDate = null;
      _toDate = null;
      ref.read(alertFilterProvider.notifier).state = const AlertFilter();
    });
  }

  void _applyFilters() {
    ref.read(alertFilterProvider.notifier).state = AlertFilter(
      type: _typeFilter,
      status: _statusFilter,
      from: _fromDate,
      to: _toDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final filter = ref.watch(alertFilterProvider);
    final alertsAsync = ref.watch(allAlertsProvider(filter));
    final statsAsync = ref.watch(adminStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.incidentsDashboard),
        actions: [
          const LanguageToggle(),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.people_outline_rounded),
            tooltip: l.userManagement,
            onPressed: () => context.push('/admin/users'),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) context.go('/');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Stats row ──────────────────────────────────────────────
          statsAsync.when(
            loading: () => const SizedBox(height: 80,
                child: Center(child: CircularProgressIndicator())),
            error: (_, __) => const SizedBox.shrink(),
            data: (stats) => Container(
              color: AppTheme.navyDark,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  _StatChip(
                    label: l.totalIncidents,
                    value: '${stats['total'] ?? 0}',
                    icon: Icons.list_alt_rounded,
                    color: Colors.white,
                  ),
                  _StatChip(
                    label: l.activeNow,
                    value: '${stats['active'] ?? 0}',
                    icon: Icons.warning_rounded,
                    color: AppTheme.alertYellow,
                  ),
                  _StatChip(
                    label: l.resolvedToday,
                    value: '${stats['resolvedToday'] ?? 0}',
                    icon: Icons.check_circle_rounded,
                    color: const Color(0xFF69F0AE),
                  ),
                ],
              ),
            ),
          ),
          // ── Filters ────────────────────────────────────────────────
          _FiltersBar(
            typeFilter: _typeFilter,
            statusFilter: _statusFilter,
            onTypeChanged: (t) {
              setState(() => _typeFilter = t);
              _applyFilters();
            },
            onStatusChanged: (s) {
              setState(() => _statusFilter = s);
              _applyFilters();
            },
            onClear: _clearFilters,
          ),
          // ── Alerts table ───────────────────────────────────────────
          Expanded(
            child: alertsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text('Error: $e')),
              data: (alerts) {
                if (alerts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.inbox_rounded,
                            size: 56, color: AppTheme.divider),
                        const SizedBox(height: 12),
                        Text(l.noActiveAlerts,
                            style:
                                Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: alerts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) =>
                      _AdminAlertRow(alert: alerts[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 10,
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _FiltersBar extends StatelessWidget {
  final AlertType? typeFilter;
  final AlertStatus? statusFilter;
  final ValueChanged<AlertType?> onTypeChanged;
  final ValueChanged<AlertStatus?> onStatusChanged;
  final VoidCallback onClear;

  const _FiltersBar({
    required this.typeFilter,
    required this.statusFilter,
    required this.onTypeChanged,
    required this.onStatusChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Type filter
            DropdownButton<AlertType?>(
              value: typeFilter,
              hint: const Text('Tipo', style: TextStyle(fontSize: 13)),
              underline: const SizedBox(),
              items: [
                const DropdownMenuItem(value: null, child: Text('Todos')),
                ...AlertType.values.map((t) => DropdownMenuItem(
                      value: t,
                      child: Text(_typeLabel(t),
                          style: const TextStyle(fontSize: 13)),
                    )),
              ],
              onChanged: onTypeChanged,
            ),
            const SizedBox(width: 12),
            // Status filter
            DropdownButton<AlertStatus?>(
              value: statusFilter,
              hint: const Text('Estado', style: TextStyle(fontSize: 13)),
              underline: const SizedBox(),
              items: [
                const DropdownMenuItem(value: null, child: Text('Todos')),
                ...AlertStatus.values.map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(_statusLabel(s),
                          style: const TextStyle(fontSize: 13)),
                    )),
              ],
              onChanged: onStatusChanged,
            ),
            const SizedBox(width: 12),
            TextButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.clear_rounded, size: 16),
              label: const Text('Limpiar', style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

  String _typeLabel(AlertType t) {
    switch (t) {
      case AlertType.slip:     return 'Caída';
      case AlertType.health:   return 'Salud';
      case AlertType.accident: return 'Accidente';
      case AlertType.other:    return 'Otro';
    }
  }

  String _statusLabel(AlertStatus s) {
    switch (s) {
      case AlertStatus.pending:   return 'Pendiente';
      case AlertStatus.active:    return 'Activo';
      case AlertStatus.enRoute:   return 'En camino';
      case AlertStatus.attending: return 'Atendiendo';
      case AlertStatus.resolved:  return 'Resuelto';
    }
  }
}

class _AdminAlertRow extends StatelessWidget {
  final AlertModel alert;
  const _AdminAlertRow({required this.alert});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yy HH:mm');
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceDark),
      ),
      child: Row(
        children: [
          // Type icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.emergencyRed.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_typeIcon(alert.type),
                color: AppTheme.emergencyRed, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert.studentName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(
                  fmt.format(alert.timestamp),
                  style: const TextStyle(
                      fontSize: 11, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          StatusBadge(status: alert.status),
        ],
      ),
    );
  }

  IconData _typeIcon(AlertType t) {
    switch (t) {
      case AlertType.slip:     return Icons.airline_seat_flat_rounded;
      case AlertType.health:   return Icons.favorite_rounded;
      case AlertType.accident: return Icons.car_crash_rounded;
      case AlertType.other:    return Icons.help_outline_rounded;
    }
  }
}
