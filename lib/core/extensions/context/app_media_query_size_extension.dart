import 'package:flutter/material.dart';

extension AppSizeExtension on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  // Proportional values
  double getWidth(double ratio) => width * ratio;
  double getHeight(double ratio) => height * ratio;
  

  bool get isSmallWidth => width <= 400;
  bool get isLargeScreen => width >= 1000;
}