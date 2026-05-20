import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Brand Colors ──────────────────────────────────────────────────────────
  static const Color emergencyRed   = Color(0xFFD32F2F);
  static const Color emergencyRedDark = Color(0xFFB71C1C);
  static const Color navyDark       = Color(0xFF1A237E);
  static const Color navyLight      = Color(0xFF283593);
  static const Color alertYellow    = Color(0xFFFDD835);
  static const Color successGreen   = Color(0xFF2E7D32);
  static const Color warningOrange  = Color(0xFFE65100);
  static const Color background     = Color(0xFFFFFFFF);
  static const Color surface        = Color(0xFFF5F5F5);
  static const Color surfaceDark    = Color(0xFFEEEEEE);
  static const Color textPrimary    = Color(0xFF212121);
  static const Color textSecondary  = Color(0xFF757575);
  static const Color divider        = Color(0xFFBDBDBD);
  static const Color onEmergency    = Color(0xFFFFFFFF);

  // ── Status Colors ─────────────────────────────────────────────────────────
  static const Color statusPending  = Color(0xFFFDD835);
  static const Color statusActive   = Color(0xFFD32F2F);
  static const Color statusEnRoute  = Color(0xFF1565C0);
  static const Color statusAttending= Color(0xFFE65100);
  static const Color statusResolved = Color(0xFF2E7D32);

  // ── Light Theme ───────────────────────────────────────────────────────────
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: navyDark,
        onPrimary: Colors.white,
        primaryContainer: navyLight,
        onPrimaryContainer: Colors.white,
        secondary: emergencyRed,
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFFFCDD2),
        onSecondaryContainer: emergencyRedDark,
        tertiary: alertYellow,
        onTertiary: textPrimary,
        error: emergencyRed,
        onError: Colors.white,
        surface: background,
        onSurface: textPrimary,
        surfaceContainerHighest: surface,
        outline: divider,
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 57, fontWeight: FontWeight.w700, color: textPrimary,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 32, fontWeight: FontWeight.w700, color: textPrimary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 24, fontWeight: FontWeight.w700, color: textPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w400, color: textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w400, color: textSecondary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: navyDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18, fontWeight: FontWeight.w700,
          color: Colors.white, letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: navyDark,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          textStyle: GoogleFonts.inter(
            fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: navyDark,
          minimumSize: const Size(double.infinity, 56),
          side: const BorderSide(color: navyDark, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16, fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: navyDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: emergencyRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        labelStyle: GoogleFonts.inter(color: textSecondary),
        hintStyle: GoogleFonts.inter(color: divider),
      ),
      cardTheme: CardThemeData(
        color: background,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: navyDark,
        labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentTextStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      dividerTheme: const DividerThemeData(color: surfaceDark, space: 1),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? Colors.white : Colors.white),
        trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? navyDark : divider),
      ),
    );
  }

  // ── Helper Decorations ────────────────────────────────────────────────────
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 12, offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get emergencyGradient => const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [emergencyRed, emergencyRedDark],
    ),
  );

  static BoxDecoration get navyGradient => const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [navyLight, navyDark],
    ),
  );

  static Color statusColor(String status) {
    switch (status) {
      case 'pending':   return statusPending;
      case 'active':    return statusActive;
      case 'en_route':  return statusEnRoute;
      case 'attending': return statusAttending;
      case 'resolved':  return statusResolved;
      default:          return textSecondary;
    }
  }
}
