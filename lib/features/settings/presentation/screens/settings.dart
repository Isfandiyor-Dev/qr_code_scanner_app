import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_text_theme_extension.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: context.textTheme.headlineSmall?.copyWith(
            height: 2,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            Text(
              "Settings",
              style: context.textTheme.labelMedium?.copyWith(
                height: 1.5,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
