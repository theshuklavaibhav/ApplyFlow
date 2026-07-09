import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Color System ────────────────────────────────────────────────
class AppColors {
  // Base
  static const bg = Color(0xFF0F0A1E);          // deep amoled purple-black
  static const surface = Color(0xFF1A1330);     // card surface
  static const surfaceHigh = Color(0xFF241B3D); // elevated surface

  // Accent palette — Gen Z gradient set
  static const purple = Color(0xFF7C3AED);
  static const purpleLight = Color(0xFFA855F7);
  static const pink = Color(0xFFEC4899);
  static const cyan = Color(0xFF06B6D4);
  static const green = Color(0xFF22C55E);
  static const orange = Color(0xFFF97316);
  static const blue = Color(0xFF3B82F6);

  // Text
  static const textPrimary = Color(0xFFF8F4FF);
  static const textSecondary = Color(0xFF9D8EC7);
  static const textMuted = Color(0xFF5C4F7A);

  // Border
  static const border = Color(0xFF2D2250);
  static const borderGlow = Color(0xFF7C3AED);

  // Status colors
  static const wishlistColor = Color(0xFF5C4F7A);
  static const appliedColor = Color(0xFF3B82F6);
  static const interviewColor = Color(0xFFF97316);
  static const offerColor = Color(0xFF22C55E);
  static const rejectedColor = Color(0xFFEF4444);

  static Color statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'APPLIED': return appliedColor;
      case 'INTERVIEW': return interviewColor;
      case 'OFFER': return offerColor;
      case 'REJECTED': return rejectedColor;
      default: return wishlistColor;
    }
  }

  // Gradients
  static const purpleGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const cyanGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const greenGradient = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const orangeGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient statusGradient(String status) {
    switch (status.toUpperCase()) {
      case 'APPLIED': return cyanGradient;
      case 'INTERVIEW': return orangeGradient;
      case 'OFFER': return greenGradient;
      case 'REJECTED': return const LinearGradient(
        colors: [Color(0xFFEF4444), Color(0xFFEC4899)],
      );
      default: return const LinearGradient(
        colors: [Color(0xFF5C4F7A), Color(0xFF7C3AED)],
      );
    }
  }
}

// ─── API Config ──────────────────────────────────────────────────
class ApiConfig {
  static const baseUrl = 'https://applyflow-production-2694.up.railway.app/api/v1';
}

// ─── Theme ───────────────────────────────────────────────────────
class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.purple,
        secondary: AppColors.pink,
        surface: AppColors.surface,
        background: AppColors.bg,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.purple,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.purple, width: 1.5),
        ),
      ),
    );
  }
}

// ─── Text Styles ─────────────────────────────────────────────────
class AppText {
  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
    fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle get displayMedium => GoogleFonts.plusJakartaSans(
    fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static TextStyle get titleLarge => GoogleFonts.plusJakartaSans(
    fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
    fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
    fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
  );

  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textMuted,
  );

  static TextStyle get labelMedium => GoogleFonts.plusJakartaSans(
    fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary,
    letterSpacing: 0.3,
  );
}
