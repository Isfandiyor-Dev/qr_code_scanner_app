import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_text_theme_extension.dart';

/// A labeled slider tile with a live value chip used across the designer.
class DesignerSlider extends StatelessWidget {
  final String label;
  final IconData? icon;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;

  /// Formats [value] for the trailing chip (defaults to a rounded integer).
  final String Function(double value)? format;

  const DesignerSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.icon,
    this.divisions,
    this.format,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final display = format?.call(value) ?? value.round().toString();
    final clamped = value.clamp(min, max);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                display,
                style: context.textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            activeTrackColor: colorScheme.primary,
            inactiveTrackColor:
                colorScheme.outlineVariant.withValues(alpha: 0.35),
            thumbColor: colorScheme.primary,
            overlayColor: colorScheme.primary.withValues(alpha: 0.12),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
            showValueIndicator: ShowValueIndicator.never,
          ),
          child: Slider(
            value: clamped,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
