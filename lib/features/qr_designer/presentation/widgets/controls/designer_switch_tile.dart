import 'package:flutter/material.dart';
import 'package:qr_code_app/core/extensions/context/app_text_theme_extension.dart';

/// A compact labeled switch row used for boolean design options (unified eyes,
/// logo shadow, transparent background, and similar options).
class DesignerSwitchTile extends StatelessWidget {
  final String label;
  final String? subtitle;
  final IconData? icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const DesignerSwitchTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 17, color: colorScheme.onSurface.withValues(alpha: 0.7)),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.textTheme.bodyMedium),
                if (subtitle != null)
                  Text(
                    subtitle!,
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
            activeThumbColor: colorScheme.secondary,
            activeTrackColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
