import 'package:flutter/material.dart';

/// MotoParts Manager typography.
/// Uses Roboto (Flutter default) with the project's type hierarchy.
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Roboto';

  static const TextTheme textTheme = TextTheme(
    // Heading — 24sp Bold
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    // Subheading — 20sp Semi-Bold
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    // Body — 16sp Regular
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    // Caption / UI Label — 12sp Regular
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
  );
}
