import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Agriculture-inspired Material 3 theme for Krishi Kavach
/// Fresh greens + warm accent colors, optimized for farmer-friendly readability
class AppTheme {
  // === PRIMARY COLORS (Agriculture Green) ===
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF60AD5E);
  static const Color primaryDark = Color(0xFF005005);
  
  // === ACCENT COLORS (Harvest Warm) ===
  static const Color accentOrange = Color(0xFFFF8F00);
  static const Color accentLight = Color(0xFFFFBF47);
  static const Color accentDark = Color(0xFFC56000);
  
  // === BACKGROUND & SURFACE ===
  static const Color background = Color(0xFFFAFDF7);  // Soft cream-white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F5EC);
  
  // === TEXT COLORS ===
  static const Color textPrimary = Color(0xFF1B1B1B);
  static const Color textSecondary = Color(0xFF4A4A4A);
  static const Color textMuted = Color(0xFF757575);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  // === SEMANTIC COLORS ===
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFFA000);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1976D2);
  
  // === GRADIENTS ===
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, primaryLight],
  );
  
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
  );
  
  // === SHADOWS ===
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: primaryGreen.withOpacity(0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
  
  // === BORDER RADIUS ===
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusRound = 100.0;
  
  // === SPACING ===
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // === LIGHT THEME ===
  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.light,
      primary: primaryGreen,
      onPrimary: textOnPrimary,
      secondary: accentOrange,
      onSecondary: textOnPrimary,
      tertiary: primaryLight,
      background: background,
      onBackground: textPrimary,
      surface: surface,
      onSurface: textPrimary,
      surfaceVariant: surfaceVariant,
      error: error,
      onError: textOnPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      
      // Typography
      textTheme: _buildTextTheme(),
      
      // App Bar
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: textOnPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          minimumSize: const Size(double.infinity, 56),
          side: const BorderSide(color: primaryGreen, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        labelStyle: GoogleFonts.notoSans(
          fontSize: 16,
          color: textSecondary,
        ),
        hintStyle: GoogleFonts.notoSans(
          fontSize: 16,
          color: textMuted,
        ),
      ),
      
      // Card
      cardTheme: CardTheme(
        elevation: 0,
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
      ),
      
      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryGreen;
          }
          return Colors.transparent;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      
      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primaryGreen,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryGreen,
        linearTrackColor: surfaceVariant,
      ),
      
      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: GoogleFonts.notoSans(
          color: textOnPrimary,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Builds the text theme with Poppins for display and Noto Sans for body
  static TextTheme _buildTextTheme() {
    return TextTheme(
      // Display
      displayLarge: GoogleFonts.poppins(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      
      // Headline
      headlineLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      
      // Title
      titleLarge: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      
      // Body
      bodyLarge: GoogleFonts.notoSans(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      ),
      bodyMedium: GoogleFonts.notoSans(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textSecondary,
      ),
      bodySmall: GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textMuted,
      ),
      
      // Label
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textMuted,
      ),
    );
  }
}
