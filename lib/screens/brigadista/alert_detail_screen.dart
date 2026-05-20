import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../l10n/app_localizations.dart';
import '../../models/alert_model.dart';
import '../../providers/alert_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/status_badge.dart';

class AlertDetailScreen extends ConsumerWidget {
  final String alertId;
  const AlertDetailScreen({super.key, required this.alertId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final alertAsync = ref.watch(alertDetailProvider(alertId));
    final notifier = ref.read(alertNotifierProvider.notifier);
    final user = ref.read(currentUserProvider).valueOrNull;

    return alertAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (alert) {
        if (alert == null) return Scaffold(body: Center(child: Text(l.error)));
        final isAssigned = alert.assignedBrigadistaId == user?.uid;

        return Scaffold(
          appBar: AppBar(
            title: Text(l.alertDetail),
            actions: const [LanguageToggle(), SizedBox(width: 8)],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Map or placeholder ────────────────────────────────────
                _MapSection(alert: alert),
                // ── Student info ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.studentInfo,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      _StudentCard(alert: alert),
                      const SizedBox(height: 20),
                      Text(l.updateStatus,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      if (isAssigned)
                        _StatusButtons(
                          currentStatus: alert.status,
                          onStatus: (s) => notifier.updateStatus(alertId, s),
                        )
                      else
                        StatusBadge(status: alert.status),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => context.push('/brigadista/chat/$alertId'),
                        icon: const Icon(Icons.chat_bubble_outline_rounded),
                        label: Text(l.openChat),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.navyDark,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                      if (alert.mediaURL != null) ...[
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            alert.mediaURL!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Map section: real map on mobile, placeholder on web ───────────────────
class _MapSection extends StatelessWidget {
  final AlertModel alert;
  const _MapSection({required this.alert});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Google Maps not supported on web without JS SDK setup
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.navyDark, AppTheme.navyLight],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_rounded,
                color: Colors.white, size: 40),
            const SizedBox(height: 8),
            Text(
              '${alert.location.latitude.toStringAsFixed(5)}, '
              '${alert.location.longitude.toStringAsFixed(5)}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Text(
                'Mapa disponible en la app móvil',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 240,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            alert.location.latitude,
            alert.location.longitude,
          ),
          zoom: 17,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('student'),
            position: LatLng(
              alert.location.latitude,
              alert.location.longitude,
            ),
            infoWindow: InfoWindow(title: alert.studentName),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),
          ),
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final AlertModel alert;
  const _StudentCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppTheme.divider,
            backgroundImage: alert.studentPhotoURL != null
                ? NetworkImage(alert.studentPhotoURL!)
                : null,
            child: alert.studentPhotoURL == null
                ? Text(
                    alert.studentName.isNotEmpty
                        ? alert.studentName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.navyDark),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert.studentName,
                    style: Theme.of(context).textTheme.titleMedium),
                if (alert.studentBloodType != null)
                  Row(
                    children: [
                      const Icon(Icons.bloodtype_rounded,
                          size: 14, color: AppTheme.emergencyRed),
                      const SizedBox(width: 4),
                      Text(alert.studentBloodType!,
                          style: const TextStyle(
                              color: AppTheme.emergencyRed,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                    ],
                  ),
              ],
            ),
          ),
          _TypeBadge(type: alert.type),
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final AlertType type;
  const _TypeBadge({required this.type});

  String get _label {
    switch (type) {
      case AlertType.slip:     return 'Caída';
      case AlertType.health:   return 'Salud';
      case AlertType.accident: return 'Accidente';
      case AlertType.other:    return 'Otro';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.emergencyRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(_label,
          style: const TextStyle(
              color: AppTheme.emergencyRed,
              fontWeight: FontWeight.w700,
              fontSize: 12)),
    );
  }
}

class _StatusButtons extends StatelessWidget {
  final AlertStatus currentStatus;
  final ValueChanged<AlertStatus> onStatus;
  const _StatusButtons({required this.currentStatus, required this.onStatus});

  @override
  Widget build(BuildContext context) {
    final statuses = [
      (AlertStatus.enRoute, Icons.directions_run_rounded, 'En camino', AppTheme.statusEnRoute),
      (AlertStatus.attending, Icons.medical_services_rounded, 'Atendiendo', AppTheme.statusAttending),
      (AlertStatus.resolved, Icons.check_circle_rounded, 'Resuelto', AppTheme.statusResolved),
    ];

    return Row(
      children: statuses.map((s) {
        final (status, icon, label, color) = s;
        final isCurrent = currentStatus == status;
        final isPast = currentStatus.index > status.index;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: GestureDetector(
              onTap: isCurrent || isPast ? null : () => onStatus(status),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? color
                      : isPast ? color.withOpacity(0.2) : AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCurrent || isPast ? color : AppTheme.divider,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(icon, size: 20,
                        color: isCurrent
                            ? Colors.white
                            : isPast ? color : AppTheme.textSecondary),
                    const SizedBox(height: 4),
                    Text(label,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isCurrent
                                ? Colors.white
                                : isPast ? color : AppTheme.textSecondary),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
