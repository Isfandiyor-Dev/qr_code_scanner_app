import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_text_theme_extension.dart';

import '../../cubit/qr_customization_cubit.dart';
import '../../cubit/qr_customization_state.dart';
import '../color/color_picker_sheet.dart';
import '../controls/color_presets.dart';
import '../controls/designer_section_card.dart';
import '../controls/segmented_selector.dart';

enum _ColorTarget { foreground, background }

/// "Colors" tab: the professional color system. Pick a target (foreground /
/// background) then apply built-in presets, a fully custom color (palette
/// button via [ColorPickerSheet]), or recent / favorite colors. Long-press any
/// swatch to (un)favorite it.
class ColorSection extends StatefulWidget {
  const ColorSection({super.key});

  @override
  State<ColorSection> createState() => _ColorSectionState();
}

class _ColorSectionState extends State<ColorSection> {
  _ColorTarget _target = _ColorTarget.foreground;

  void _apply(QrCustomizationCubit cubit, int value) {
    if (_target == _ColorTarget.foreground) {
      cubit.setForegroundColor(value);
    } else {
      cubit.setBackgroundColor(value);
    }
  }

  Future<void> _openCustomPicker(
    QrCustomizationCubit cubit,
    int initial,
    List<int> recentColors,
  ) async {
    final picked = await ColorPickerSheet.show(
      context,
      initialColor: Color(initial),
      recentColors: recentColors.map((value) => Color(value)).toList(),
      title: _target == _ColorTarget.foreground
          ? 'Foreground color'
          : 'Background color',
      enableOpacity: false,
    );
    if (picked != null) _apply(cubit, picked.toARGB32());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QrCustomizationCubit, QrCustomizationState>(
      buildWhen: (previous, current) => previous.config != current.config,
      builder: (context, state) {
        final cubit = context.read<QrCustomizationCubit>();
        final config = state.config;
        final activeColor = _target == _ColorTarget.foreground
            ? config.foregroundColor
            : config.backgroundColor;

        return Column(
          children: [
            DesignerSectionCard(
              title: 'Apply to',
              icon: Icons.colorize_rounded,
              child: SegmentedSelector<_ColorTarget>(
                selected: _target,
                onChanged: (value) => setState(() => _target = value),
                options: const [
                  SegmentedOption(
                    value: _ColorTarget.foreground,
                    label: 'Foreground',
                    icon: Icons.gradient_rounded,
                  ),
                  SegmentedOption(
                    value: _ColorTarget.background,
                    label: 'Background',
                    icon: Icons.format_color_reset_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            DesignerSectionCard(
              title: 'Presets',
              icon: Icons.palette_rounded,
              child: _SwatchWrap(
                values: kColorPresets.map((preset) => preset.value).toList(),
                activeColor: activeColor,
                favorites: config.favoriteColors,
                onTap: (value) => _apply(cubit, value),
                onLongPress: cubit.toggleFavoriteColor,
                leading: _CustomColorButton(
                  onTap: () => _openCustomPicker(
                    cubit,
                    activeColor,
                    config.recentColors,
                  ),
                ),
              ),
            ),
            if (config.favoriteColors.isNotEmpty) ...[
              const SizedBox(height: 14),
              DesignerSectionCard(
                title: 'Favorites',
                icon: Icons.star_rounded,
                child: _SwatchWrap(
                  values: config.favoriteColors,
                  activeColor: activeColor,
                  favorites: config.favoriteColors,
                  onTap: (value) => _apply(cubit, value),
                  onLongPress: cubit.toggleFavoriteColor,
                ),
              ),
            ],
            if (config.recentColors.isNotEmpty) ...[
              const SizedBox(height: 14),
              DesignerSectionCard(
                title: 'Recent',
                icon: Icons.history_rounded,
                child: _SwatchWrap(
                  values: config.recentColors,
                  activeColor: activeColor,
                  favorites: config.favoriteColors,
                  onTap: (value) => _apply(cubit, value),
                  onLongPress: cubit.toggleFavoriteColor,
                ),
              ),
            ],
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tip: long-press a color to add or remove a favorite.',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: cubit.resetColors,
              style: OutlinedButton.styleFrom(
                foregroundColor: context.colorScheme.onSurface,
                minimumSize: const Size.fromHeight(50),
                side: BorderSide(
                  color:
                      context.colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.restart_alt_rounded, size: 20),
              label: const Text('Reset colors'),
            ),
          ],
        );
      },
    );
  }
}

class _SwatchWrap extends StatelessWidget {
  final List<int> values;
  final int activeColor;
  final List<int> favorites;
  final ValueChanged<int> onTap;
  final ValueChanged<int> onLongPress;
  final Widget? leading;

  const _SwatchWrap({
    required this.values,
    required this.activeColor,
    required this.favorites,
    required this.onTap,
    required this.onLongPress,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        if (leading != null) leading!,
        for (final value in values)
          _ColorDot(
            value: value,
            selected: value == activeColor,
            favorite: favorites.contains(value),
            onTap: () => onTap(value),
            onLongPress: () => onLongPress(value),
          ),
      ],
    );
  }
}

/// Circular button that opens the full custom color picker.
class _CustomColorButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CustomColorButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.primaryContainer.withValues(alpha: 0.7),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.6),
            width: 1.4,
          ),
        ),
        child:
            Icon(Icons.palette_outlined, color: colorScheme.primary, size: 22),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final int value;
  final bool selected;
  final bool favorite;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ColorDot({
    required this.value,
    required this.selected,
    required this.favorite,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final color = Color(value);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Reserve the larger footprint so neighbours don't shift on select.
          const SizedBox(width: 52, height: 52),
          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            width: selected ? 50 : 42,
            height: selected ? 50 : 42,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant.withValues(alpha: 0.5),
                width: selected ? 3 : 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.45),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          ),
          if (favorite)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.star_rounded,
                    size: 13, color: colorScheme.primary),
              ),
            ),
        ],
      ),
    );
  }
}
