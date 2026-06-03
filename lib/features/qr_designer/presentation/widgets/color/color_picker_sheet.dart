import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_app/core/extensions/context/app_text_theme_extension.dart';

/// A premium modal color picker built on `flex_color_picker`.
///
/// Provides the full professional color system: preset/material swatches, a wheel
/// for fully custom colors, a HEX code field, an opacity slider and the user's
/// recent colors. Returns the chosen [Color], or `null` if dismissed.
class ColorPickerSheet {
  const ColorPickerSheet._();

  /// Opens the modal color picker and returns the selected color.
  static Future<Color?> show(
    BuildContext context, {
    required Color initialColor,
    required List<Color> recentColors,
    String title = 'Pick a color',
    bool enableOpacity = true,
  }) {
    return showModalBottomSheet<Color>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => _ColorPickerSheetBody(
        initialColor: initialColor,
        recentColors: recentColors,
        title: title,
        enableOpacity: enableOpacity,
      ),
    );
  }
}

class _ColorPickerSheetBody extends StatefulWidget {
  final Color initialColor;
  final List<Color> recentColors;
  final String title;
  final bool enableOpacity;

  const _ColorPickerSheetBody({
    required this.initialColor,
    required this.recentColors,
    required this.title,
    required this.enableOpacity,
  });

  @override
  State<_ColorPickerSheetBody> createState() => _ColorPickerSheetBodyState();
}

class _ColorPickerSheetBodyState extends State<_ColorPickerSheetBody> {
  late Color _current = widget.initialColor;
  late List<Color> _recent = List<Color>.from(widget.recentColors);

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ColorPicker(
              color: _current,
              onColorChanged: (color) => setState(() => _current = color),
              borderRadius: 10,
              spacing: 6,
              runSpacing: 6,
              enableShadesSelection: true,
              enableOpacity: widget.enableOpacity,
              showColorName: true,
              showColorCode: true,
              colorCodeHasColor: true,
              padding: EdgeInsets.zero,
              heading: Text('Select color', style: context.textTheme.bodyMedium),
              subheading: Text('Select shade', style: context.textTheme.bodySmall),
              wheelSubheading: Text(
                'Selected color and shades',
                style: context.textTheme.bodySmall,
              ),
              opacitySubheading: Text('Opacity', style: context.textTheme.bodySmall),
              recentColorsSubheading: Text('Recent', style: context.textTheme.bodySmall),
              showRecentColors: true,
              recentColors: _recent,
              maxRecentColors: 18,
              onRecentColorsChanged: (colors) => setState(() => _recent = colors),
              pickersEnabled: const {
                ColorPickerType.both: false,
                ColorPickerType.primary: true,
                ColorPickerType.accent: true,
                ColorPickerType.bw: false,
                ColorPickerType.custom: false,
                ColorPickerType.wheel: true,
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      foregroundColor: colorScheme.onSurface,
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(_current),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.secondary,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Select',
                      style: context.textTheme.labelLarge?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
