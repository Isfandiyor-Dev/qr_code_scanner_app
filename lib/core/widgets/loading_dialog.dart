import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_app/core/extensions/context/app_text_theme_extension.dart';

/// Shows a non-dismissible, centered loading spinner.
///
/// Dismiss it by popping the dialog route (e.g. `Navigator.of(context).pop()`).
void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    builder: (_) => Center(
      child: CupertinoActivityIndicator(
        color: context.colorScheme.primary,
        radius: 15,
      ),
    ),
  );
}
