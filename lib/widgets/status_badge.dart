import 'package:flutter/material.dart';
import '../models/alert_model.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final AlertStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _color,
            ),
          ),
          const SizedBox(width: 5),
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

  Color get _color => AppTheme.statusColor(status.name);

  String get _label {
    switch (status) {
      case AlertStatus.pending:   return 'Pendiente';
      case AlertStatus.active:    return 'Activo';
      case AlertStatus.enRoute:   return 'En camino';
      case AlertStatus.attending: return 'Atendiendo';
      case AlertStatus.resolved:  return 'Resuelto';
    }
  }
}
