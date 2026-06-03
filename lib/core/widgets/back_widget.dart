import 'package:flutter/material.dart';
import 'package:qr_code_app/core/extensions/context/app_text_theme_extension.dart';

/// Reusable rounded back button used by pages with custom app bars.
class BackWidget extends StatelessWidget {
  /// Optional callback. Defaults to [Navigator.pop] when omitted.
  final GestureTapCallback? onTap;

  /// Creates a back button with an optional custom tap handler.
  const BackWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.pop(context),
      child: Center(
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: context.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.primaryContainer,
                blurRadius: 2,
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
