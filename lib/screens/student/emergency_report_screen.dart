import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../l10n/app_localizations.dart';
import '../../models/alert_model.dart';
import '../../providers/alert_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/loading_overlay.dart';

class EmergencyReportScreen extends ConsumerStatefulWidget {
  const EmergencyReportScreen({super.key});

  @override
  ConsumerState<EmergencyReportScreen> createState() =>
      _EmergencyReportScreenState();
}

class _EmergencyReportScreenState
    extends ConsumerState<EmergencyReportScreen> {
  AlertType _selectedType = AlertType.other;
  final _notesCtrl = TextEditingController();
  File? _mediaFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickMedia(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1200,
    );
    if (picked != null) setState(() => _mediaFile = File(picked.path));
  }

  Future<void> _submit() async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;

    try {
      final alert = await ref
          .read(alertNotifierProvider.notifier)
          .sendPanicAlert(
            student: user,
            type: _selectedType,
            notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).reportSent),
          backgroundColor: AppTheme.successGreen,
        ),
      );
      context.pushReplacement('/student/chat/${alert.alertId}');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppTheme.emergencyRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final alertAsync = ref.watch(alertNotifierProvider);

    return LoadingOverlay(
      isLoading: alertAsync.isLoading,
      message: l.submitting,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.reportEmergency),
          actions: const [LanguageToggle(), SizedBox(width: 8)],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Emergency type ────────────────────────────────────────
              Text(l.emergencyType,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              _TypeSelector(
                selected: _selectedType,
                onChanged: (t) => setState(() => _selectedType = t),
              ),
              const SizedBox(height: 24),
              // ── Location (auto) ───────────────────────────────────────
              _InfoRow(
                icon: Icons.location_on_rounded,
                color: AppTheme.navyDark,
                label: l.location,
                value: l.locationAuto,
              ),
              const SizedBox(height: 24),
              // ── Notes ─────────────────────────────────────────────────
              Text('Notas adicionales (opcional)',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Describe brevemente la emergencia...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
              const SizedBox(height: 24),
              // ── Media ─────────────────────────────────────────────────
              Text(l.attachMedia,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              if (_mediaFile != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _mediaFile!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => setState(() => _mediaFile = null),
                  icon: const Icon(Icons.delete_outline,
                      color: AppTheme.emergencyRed),
                  label: const Text('Eliminar foto',
                      style: TextStyle(color: AppTheme.emergencyRed)),
                ),
              ] else ...[
                Row(
                  children: [
                    _MediaButton(
                      icon: Icons.camera_alt_outlined,
                      label: 'Cámara',
                      onTap: () => _pickMedia(ImageSource.camera),
                    ),
                    const SizedBox(width: 12),
                    _MediaButton(
                      icon: Icons.photo_library_outlined,
                      label: 'Galería',
                      onTap: () => _pickMedia(ImageSource.gallery),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 32),
              // ── Submit ────────────────────────────────────────────────
              ElevatedButton.icon(
                onPressed: alertAsync.isLoading ? null : _submit,
                icon: const Icon(Icons.send_rounded),
                label: Text(l.submit),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.emergencyRed,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
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

class _TypeSelector extends StatelessWidget {
  final AlertType selected;
  final ValueChanged<AlertType> onChanged;

  const _TypeSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final types = [
      (AlertType.slip, Icons.airline_seat_flat_rounded, 'Caída',
          AppTheme.warningOrange),
      (AlertType.health, Icons.favorite_rounded, 'Salud',
          AppTheme.emergencyRed),
      (AlertType.accident, Icons.car_crash_rounded, 'Accidente',
          const Color(0xFF6A1B9A)),
      (AlertType.other, Icons.help_outline_rounded, 'Otro',
          AppTheme.textSecondary),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.8,
      children: types.map((t) {
        final (type, icon, label, color) = t;
        final isSelected = selected == type;
        return GestureDetector(
          onTap: () => onChanged(type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.12) : AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? color : AppTheme.divider,
                width: isSelected ? 2 : 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(icon,
                    color: isSelected ? color : AppTheme.textSecondary,
                    size: 22),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? color : AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w600)),
              Text(value,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppTheme.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MediaButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MediaButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.divider),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppTheme.navyDark, size: 28),
              const SizedBox(height: 6),
              Text(label,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
