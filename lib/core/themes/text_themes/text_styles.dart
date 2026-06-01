import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/gen/fonts.gen.dart';

/// Centralized text theme factory for the application.
class AppTextStyles {
  /// Builds the app text theme using [color] for all text styles.
  static TextTheme getTextTheme(Color color) => TextTheme(
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: color,
          fontFamily: FontFamily.itim,
        ),
        displayMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: color,
          fontFamily: FontFamily.itim,
        ),
        displaySmall: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: color,
          fontFamily: FontFamily.itim,
        ),
        headlineLarge: TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.bold,
          color: color,
          fontFamily: FontFamily.itim,
        ),
        headlineMedium: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: color,
          fontFamily: FontFamily.itim,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          color: color,
          fontFamily: FontFamily.itim,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: color,
          fontFamily: FontFamily.itim,
        ),
        titleMedium: TextStyle(
          fontSize: 20,
          color: color,
          fontFamily: FontFamily.itim,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          color: color,
          fontFamily: FontFamily.itim,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: color,
          fontFamily: FontFamily.itim,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: color,
          fontFamily: FontFamily.itim,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: color,
          fontFamily: FontFamily.itim,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          color: color,
          fontFamily: FontFamily.itim,
        ),
        labelMedium: TextStyle(
          fontSize: 14,
          color: color,
          fontFamily: FontFamily.itim,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          color: color,
          fontFamily: FontFamily.itim,
        ),
      );
}
