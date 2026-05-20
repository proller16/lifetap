import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/alert_model.dart';
import '../theme/app_theme.dart';
import 'status_badge.dart';

class AlertCard extends StatelessWidget {
  final AlertModel alert;
  final double? distanceMeters;
  final VoidCallback? onAccept;
  final VoidCallback? onTap;
  final bool showAccept;

  const AlertCard({
    super.key,
    required this.alert,
    this.distanceMeters,
    this.onAccept,
    this.onTap,
    this.showAccept = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    timeago.setLocaleMessages('es', timeago.EsMessages());
    final elapsed = timeago.format(alert.timestamp,
        locale: Localizations.localeOf(context).languageCode);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(
              color: AppTheme.statusColor(alert.status.name),
              width: 4,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header row ───────────────────────────────────────────────
              Row(
                children: [
                  // Student avatar
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppTheme.surface,
                    backgroundImage: alert.studentPhotoURL != null
                        ? NetworkImage(alert.studentPhotoURL!)
                        : null,
                    child: alert.studentPhotoURL == null
                        ? Text(
                            alert.studentName.isNotEmpty
                                ? alert.studentName[0].toUpperCase()
                                : '?',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(color: AppTheme.navyDark),
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert.studentName,
                          style: theme.textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        StatusBadge(status: alert.status),
                      ],
                    ),
                  ),
                  // Emergency type chip
                  _TypeChip(type: alert.type),
                ],
              ),
              const SizedBox(height: 10),
              // ── Info row ─────────────────────────────────────────────────
              Row(
                children: [
                  const Icon(Icons.access_time_rounded,
                      size: 14, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text(elapsed,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontSize: 12)),
                  if (distanceMeters != null) ...[
                    const SizedBox(width: 14),
                    const Icon(Icons.near_me_rounded,
                        size: 14, color: AppTheme.navyDark),
                    const SizedBox(width: 4),
                    Text(
                      _formatDist(distanceMeters!),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: AppTheme.navyDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (alert.studentBloodType != null) ...[
                    const SizedBox(width: 14),
                    const Icon(Icons.bloodtype_rounded,
                        size: 14, color: AppTheme.emergencyRed),
                    const SizedBox(width: 4),
                    Text(
                      alert.studentBloodType!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: AppTheme.emergencyRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
              // ── Accept button ─────────────────────────────────────────────
              if (showAccept && alert.status == AlertStatus.pending) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: onAccept,
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text('Aceptar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.navyDark,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDist(double meters) {
    if (meters < 1000) return '${meters.round()} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }
}

class _TypeChip extends StatelessWidget {
  final AlertType type;
  const _TypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 13, color: _color),
          const SizedBox(width: 4),
          Text(
            _label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _color,
            ),
          ),
        ],
      ),
    );
  }

  Color get _color {
    switch (type) {
      case AlertType.slip:     return AppTheme.warningOrange;
      case AlertType.health:   return AppTheme.emergencyRed;
      case AlertType.accident: return const Color(0xFF6A1B9A);
      case AlertType.other:    return AppTheme.textSecondary;
    }
  }

  IconData get _icon {
    switch (type) {
      case AlertType.slip:     return Icons.airline_seat_flat_rounded;
      case AlertType.health:   return Icons.favorite_rounded;
      case AlertType.accident: return Icons.car_crash_rounded;
      case AlertType.other:    return Icons.help_outline_rounded;
    }
  }

  String get _label {
    switch (type) {
      case AlertType.slip:     return 'Caída';
      case AlertType.health:   return 'Salud';
      case AlertType.accident: return 'Accidente';
      case AlertType.other:    return 'Otro';
    }
  }
}
