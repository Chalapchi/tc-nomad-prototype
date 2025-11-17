import 'package:flutter/material.dart';

/// TC Nomad App Color Palette
/// Apple-inspired with liquid glass aesthetic
class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF007AFF); // iOS Blue
  static const Color primaryDark = Color(0xFF0051D5);
  static const Color primaryLight = Color(0xFF00C7BE);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x40FFFFFF),
      Color(0x10FFFFFF),
    ],
  );

  // Neutral Colors
  static const Color background = Color(0xFFF2F2F7);
  static const Color backgroundDark = Color(0xFF1C1C1E);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF2C2C2E);

  // Text Colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF3C3C43);
  static const Color textTertiary = Color(0xFF8E8E93);
  static const Color textDisabled = Color(0xFFC7C7CC);

  // Semantic Colors
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9500);
  static const Color error = Color(0xFFFF3B30);
  static const Color info = Color(0xFF5AC8FA);

  // Border & Divider
  static const Color border = Color(0xFFE5E5EA);
  static const Color divider = Color(0xFFC6C6C8);

  // Glassmorphism
  static const Color glassBackground = Color(0x80FFFFFF);
  static const Color glassBorder = Color(0x40FFFFFF);

  // Category Colors (for packing items)
  static const Color categoryClothing = Color(0xFF007AFF);
  static const Color categoryToiletries = Color(0xFFAF52DE);
  static const Color categoryElectronics = Color(0xFFFF9500);
  static const Color categoryDocuments = Color(0xFFFF3B30);
  static const Color categoryMiscellaneous = Color(0xFF34C759);

  // Volume Indicators
  static const Color volumeLow = Color(0xFF34C759);
  static const Color volumeMedium = Color(0xFFFF9500);
  static const Color volumeHigh = Color(0xFFFF3B30);

  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get glassShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];
}
