import 'package:flutter/material.dart';

/// A named built-in color offered as a one-tap preset in the color system.
class NamedColor {
  final String name;
  final Color color;

  const NamedColor(this.name, this.color);

  /// ARGB integer value used by persisted design configurations.
  int get value => color.toARGB32();
}

/// The professional built-in color presets required by the designer.
const List<NamedColor> kColorPresets = <NamedColor>[
  NamedColor('Black', Color(0xFF000000)),
  NamedColor('White', Color(0xFFFFFFFF)),
  NamedColor('Blue', Color(0xFF2196F3)),
  NamedColor('Red', Color(0xFFF44336)),
  NamedColor('Green', Color(0xFF4CAF50)),
  NamedColor('Purple', Color(0xFF9C27B0)),
  NamedColor('Orange', Color(0xFFFF9800)),
  NamedColor('Teal', Color(0xFF009688)),
  NamedColor('Indigo', Color(0xFF3F51B5)),
  NamedColor('Pink', Color(0xFFE91E63)),
];
