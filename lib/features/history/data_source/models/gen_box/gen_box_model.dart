import 'package:flutter/material.dart';

/// Metadata for a QR generation option displayed on the Generate screen.
class GenBox {
  /// Display name of the QR generation option.
  final String name;

  /// Asset path for the option icon.
  final String iconPath;

  /// Form widget that collects data for this QR type.
  final Widget generateContainer;

  /// Creates generation metadata for a QR type.
  GenBox({
    required this.name,
    required this.iconPath,
    required this.generateContainer,
  });
}

/// Generation metadata for QR types that only need one input field.
class SingleFieldBox extends GenBox {
  /// Label displayed above the text field.
  final String fieldLabel;

  /// Hint displayed inside the text field.
  final String hintText;

  /// Creates metadata for a single-field QR type.
  SingleFieldBox({
    required super.name,
    required this.fieldLabel,
    required this.hintText,
    required super.generateContainer,
    required super.iconPath,
  });
}
