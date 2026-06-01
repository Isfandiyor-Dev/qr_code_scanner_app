import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_text_theme_extension.dart';

import '../color/color_picker_sheet.dart';

/// A compact "label + swatch" row that opens the full [ColorPickerSheet].
///
/// Keeps each color control to a single tidy line; the rich picker (presets,
/// wheel, HEX, opacity, recents) lives in the sheet it opens.
class ColorPickerField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final int color;
  final List<int> recentColors;
  final ValueChanged<int> onChanged;
  final bool enableOpacity;

  const ColorPickerField({
    super.key,
    required this.label,
    required this.color,
    required this.recentColors,
    required this.onChanged,
    this.icon,
    this.enableOpacity = true,
  });

  Future<void> _open(BuildContext context) async {
    final picked = await ColorPickerSheet.show(
      context,
      initialColor: Color(color),
      recentColors: recentColors.map((value) => Color(value)).toList(),
      title: label,
      enableOpacity: enableOpacity,
    );
    if (picked != null) onChanged(picked.toARGB32());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return InkWell(
      onTap: () => _open(context),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon,
                  size: 17,
                  color: colorScheme.onSurface.withValues(alpha: 0.7)),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(label, style: context.textTheme.bodyMedium),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Color(color),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}
