import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_text_theme_extension.dart';

class GenerateButton extends StatelessWidget {
  final void Function() onPressed;
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
