import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/loading_overlay.dart';

class StudentProfileScreen extends ConsumerStatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  ConsumerState<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState extends ConsumerState<StudentProfileScreen> {
  bool _editing = false;
  final _nameCtrl = TextEditingController();
  final _controlCtrl = TextEditingController();
  final _bloodCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  bool _saving = false;

  void _loadUser(UserModel user) {
    _nameCtrl.text = user.name;
    _controlCtrl.text = user.controlNumber;
    _bloodCtrl.text = user.bloodType ?? '';
    _contactCtrl.text = user.emergencyContact ?? '';
  }

  Future<void> _save(UserModel current) async {
    setState(() => _saving = true);
    try {
      final updated = current.copyWith(
        name: _nameCtrl.text.trim(),
        controlNumber: _controlCtrl.text.trim(),
        bloodType: _bloodCtrl.text.trim().isEmpty ? null : _bloodCtrl.text.trim(),
        emergencyContact: _contactCtrl.text.trim().isEmpty
            ? null
            : _contactCtrl.text.trim(),
      );
      await ref.read(authNotifierProvider.notifier).updateProfile(updated);
      if (!mounted) return;
      setState(() {
        _editing = false;
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).profileUpdated),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    } catch (e) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.emergencyRed),
      );
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _controlCtrl.dispose();
    _bloodCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (user) {
        if (user != null && !_editing) _loadUser(user);
        return LoadingOverlay(
          isLoading: _saving,
          message: l.loading,
          child: Scaffold(
            appBar: AppBar(
              title: Text(l.profileTitle),
              actions: [
                const LanguageToggle(),
                const SizedBox(width: 8),
                if (!_editing)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: l.editProfile,
                    onPressed: () => setState(() => _editing = true),
                  )
                else
                  TextButton(
                    onPressed: () => setState(() => _editing = false),
                    child: Text(l.cancel,
                        style: const TextStyle(color: Colors.white)),
                  ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // ── Avatar ──────────────────────────────────────────
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 52,
                          backgroundColor: AppTheme.surface,
                          backgroundImage: user?.photoURL != null
                              ? NetworkImage(user!.photoURL!)
                              : null,
                          child: user?.photoURL == null
                              ? Text(
                                  user?.name.isNotEmpty == true
                                      ? user!.name[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.navyDark,
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppTheme.navyDark,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt_rounded,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (user != null)
                    Text(
                      user.email,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppTheme.navyDark),
                    ),
                  const SizedBox(height: 28),
                  // ── Fields ───────────────────────────────────────────
                  _ProfileField(
                    icon: Icons.person_outline_rounded,
                    label: l.name,
                    controller: _nameCtrl,
                    editing: _editing,
                  ),
                  const SizedBox(height: 14),
                  _ProfileField(
                    icon: Icons.badge_outlined,
                    label: l.controlNumber,
                    controller: _controlCtrl,
                    editing: _editing,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 14),
                  _ProfileField(
                    icon: Icons.bloodtype_outlined,
                    label: l.bloodType,
                    controller: _bloodCtrl,
                    editing: _editing,
                    hint: 'Ej: O+',
                  ),
                  const SizedBox(height: 14),
                  _ProfileField(
                    icon: Icons.phone_outlined,
                    label: l.emergencyContact,
                    controller: _contactCtrl,
                    editing: _editing,
                    keyboardType: TextInputType.phone,
                    hint: 'Nombre — Teléfono',
                  ),
                  if (_editing) ...[
                    const SizedBox(height: 28),
                    ElevatedButton.icon(
                      onPressed: user != null ? () => _save(user) : null,
                      icon: const Icon(Icons.save_outlined),
                      label: Text(l.saveProfile),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final bool editing;
  final TextInputType keyboardType;
  final String? hint;

  const _ProfileField({
    required this.icon,
    required this.label,
    required this.controller,
    required this.editing,
    this.keyboardType = TextInputType.text,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    if (!editing) {
      return Container(
        padding: const EdgeInsets.all(14),
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
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(
                  controller.text.isEmpty ? '—' : controller.text,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
