import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/locale_provider.dart';
import '../theme/app_theme.dart';

class LanguageToggle extends ConsumerWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isEs = locale.languageCode == 'es';

    return GestureDetector(
      onTap: () => ref.read(localeProvider.notifier).toggle(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LangLabel(label: 'ES', active: isEs),
            Container(
              width: 1,
              height: 14,
              color: Colors.white.withOpacity(0.4),
              margin: const EdgeInsets.symmetric(horizontal: 6),
            ),
            _LangLabel(label: 'EN', active: !isEs),
          ],
        ),
      ),
    );
  }
}

class _LangLabel extends StatelessWidget {
  final String label;
  final bool active;
  const _LangLabel({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: TextStyle(
        fontSize: 12,
        fontWeight: active ? FontWeight.w700 : FontWeight.w400,
        color: active ? Colors.white : Colors.white60,
        letterSpacing: 0.5,
      ),
      child: Text(label),
    );
  }
}

// ── Floating language toggle for screens without AppBar ───────────────────
class FloatingLanguageToggle extends ConsumerWidget {
  const FloatingLanguageToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isEs = locale.languageCode == 'es';

    return GestureDetector(
      onTap: () => ref.read(localeProvider.notifier).toggle(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.navyDark,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language_rounded,
                size: 14, color: Colors.white70),
            const SizedBox(width: 6),
            Text(
              isEs ? 'ES' : 'EN',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
