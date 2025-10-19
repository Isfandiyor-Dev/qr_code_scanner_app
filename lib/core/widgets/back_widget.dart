import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_text_theme_extension.dart';

class BackWidget extends StatelessWidget {
  final GestureTapCallback? onTap;
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
