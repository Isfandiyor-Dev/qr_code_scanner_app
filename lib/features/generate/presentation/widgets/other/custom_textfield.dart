import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_text_theme_extension.dart';

/// Signature used by generated form fields to validate text input.
typedef FieldValidator = String? Function(String? value);

/// Shared styled text field used across QR generation forms.
class CustomTextField extends StatelessWidget {
  /// Label displayed above the field.
  final String fieldLabel;

  /// Controller that owns the field value.
  final TextEditingController controller;

  /// Placeholder text displayed when the field is empty.
  final String hintText;

  /// Maximum number of visible text lines.
  final int maxLines;

  /// Optional validation callback.
  final FieldValidator? validator;

  /// Optional keyboard type for platform input optimization.
  final TextInputType? keyboardType;

  /// Creates a styled form text field.
  const CustomTextField({
    super.key,
    required this.fieldLabel,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldLabel,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            fillColor: context.colorScheme.primaryContainer,
            filled: true,
            hintText: hintText,
            hintStyle: context.textTheme.bodyLarge?.copyWith(
              color:
                  context.colorScheme.onPrimaryContainer.withValues(alpha: 0.5),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffD9D9D9),
                width: 0.8,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 0.8,
              ),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.amber,
                width: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
