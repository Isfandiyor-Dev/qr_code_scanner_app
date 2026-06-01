import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_text_theme_extension.dart';

/// Primary button used to submit QR generation forms.
class GenerateButton extends StatelessWidget {
  /// Callback invoked when the button is pressed.
  final void Function() onPressed;

  /// Creates a form submission button.
  const GenerateButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: context.colorScheme.primary,
        fixedSize: const Size(200, 50),
      ),
      onPressed: onPressed,
      child: Text(
        "Generate QR Code",
        style: context.textTheme.labelLarge
            ?.copyWith(color: context.colorScheme.secondary),
      ),
    );
  }
}
