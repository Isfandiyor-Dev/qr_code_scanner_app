import 'package:flutter/material.dart';

/// Convenience accessors for viewport dimensions and responsive breakpoints.
extension AppSizeExtension on BuildContext {
  /// Current viewport width.
  double get width => MediaQuery.of(this).size.width;

  /// Current viewport height.
  double get height => MediaQuery.of(this).size.height;

  /// Returns [ratio] of the current viewport width.
  double getWidth(double ratio) => width * ratio;

  /// Returns [ratio] of the current viewport height.
  double getHeight(double ratio) => height * ratio;

  /// Whether the current viewport is narrow enough for compact layouts.
  bool get isSmallWidth => width <= 400;

  /// Whether the current viewport is wide enough for large-screen layouts.
  bool get isLargeScreen => width >= 1000;
}
