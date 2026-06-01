import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_text_theme_extension.dart';

/// A single rounded card in the "Settings" section: a leading amber icon, a
/// title + subtitle, and a trailing switch.
///
/// The whole card is tappable: tapping anywhere (not just the switch) toggles
/// the value and shows a ripple. The trailing [Switch] stays interactive too;
/// because it wins its own gesture, tapping it toggles exactly once.
class SettingToggleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingToggleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Material(
      color: colorScheme.tertiaryFixedDim,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: InkWell(
        onTap: () => onChanged(!value),
        splashColor: colorScheme.primary.withValues(alpha: 0.12),
        highlightColor: Colors.white.withValues(alpha: 0.03),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(icon, color: colorScheme.primary, size: 26),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      subtitle,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: const Color(0xFFF5E6C8),
                activeTrackColor: colorScheme.primary,
                inactiveThumbColor: const Color(0xFFBDBDBD),
                inactiveTrackColor: const Color(0xFF555759),
                trackOutlineColor:
                    const WidgetStatePropertyAll(Colors.transparent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
