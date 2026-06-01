import 'package:flutter/material.dart';

/// Convenience accessors for theme values used throughout the UI.
extension AppThemeExtension on BuildContext {
  /// The active [TextTheme].
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// The active [ColorScheme].
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
