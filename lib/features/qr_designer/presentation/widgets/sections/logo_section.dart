import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_text_theme_extension.dart';
import 'package:svg_flutter/svg.dart';

import '../../../data_source/models/logo_config.dart';
import '../../../data_source/models/qr_design_enums.dart';
import '../../cubit/qr_customization_cubit.dart';
import '../../cubit/qr_customization_state.dart';
import '../controls/color_picker_field.dart';
import '../controls/designer_section_card.dart';
import '../controls/designer_slider.dart';
import '../controls/designer_switch_tile.dart';
import '../controls/logo_icon_grid.dart';
import '../controls/segmented_selector.dart';

/// "Logo" tab: choose the center asset (none / Material icon / image / SVG) and
/// style its badge (size, shape, colors, border, opacity, shadow, blur).
class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QrCustomizationCubit, QrCustomizationState>(
      buildWhen: (previous, current) =>
          previous.config.logo != current.config.logo,
      builder: (context, state) {
        final cubit = context.read<QrCustomizationCubit>();
        final logo = state.config.logo;

        return Column(
          children: [
            DesignerSectionCard(
              title: 'Logo source',
              icon: Icons.add_photo_alternate_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SegmentedSelector<LogoType>(
                    selected: logo.type == LogoType.assetIcon
                        ? LogoType.materialIcon
                        : logo.type,
                    onChanged: (type) => _onLogoTypeSelected(cubit, logo, type),
                    options: const [
                      SegmentedOption(
                          value: LogoType.none,
                          label: 'None',
                          icon: Icons.block_rounded),
                      SegmentedOption(
                          value: LogoType.materialIcon,
                          label: 'Icon',
                          icon: Icons.emoji_emotions_rounded),
                      SegmentedOption(
                          value: LogoType.image,
                          label: 'Image',
                          icon: Icons.image_rounded),
                      SegmentedOption(
                          value: LogoType.svg,
                          label: 'SVG',
                          icon: Icons.polyline_rounded),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSourcePicker(context, cubit, logo),
                ],
              ),
            ),
            if (logo.hasLogo) ...[
              const SizedBox(height: 14),
              _LogoStyleCard(logo: logo, cubit: cubit),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: cubit.removeLogo,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.colorScheme.error,
                        minimumSize: const Size.fromHeight(50),
                        side: BorderSide(
                          color:
                              context.colorScheme.error.withValues(alpha: 0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.delete_outline_rounded, size: 20),
                      label: const Text('Remove logo'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: cubit.resetLogoSettings,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.colorScheme.onSurface,
                        minimumSize: const Size.fromHeight(50),
                        side: BorderSide(
                          color: context.colorScheme.outlineVariant
                              .withValues(alpha: 0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.restart_alt_rounded, size: 20),
                      label: const Text('Reset logo'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  /// Maps the "Icon" segment to the right concrete type. The single "Icon"
  /// segment covers both Material icons and bundled social SVGs, so switching to
  /// it keeps whichever the user already picked.
  void _onLogoTypeSelected(
    QrCustomizationCubit cubit,
    LogoConfig logo,
    LogoType selected,
  ) {
    if (selected == LogoType.materialIcon) {
      if (logo.type == LogoType.materialIcon ||
          logo.type == LogoType.assetIcon) {
        return;
      }
      cubit.setLogoType(
        logo.assetIconPath != null ? LogoType.assetIcon : LogoType.materialIcon,
      );
    } else {
      cubit.setLogoType(selected);
    }
  }

  Widget _buildSourcePicker(
    BuildContext context,
    QrCustomizationCubit cubit,
    LogoConfig logo,
  ) {
    switch (logo.type) {
      case LogoType.none:
        return Text(
          'No logo - pick an icon, social logo, image or SVG to brand your QR.',
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        );
      case LogoType.materialIcon:
      case LogoType.assetIcon:
        return LogoIconGrid(
          selectedCodePoint: logo.type == LogoType.materialIcon
              ? logo.materialIconCodePoint
              : null,
          selectedAssetPath:
              logo.type == LogoType.assetIcon ? logo.assetIconPath : null,
          onSelectMaterial: cubit.setMaterialIcon,
          onSelectSocial: cubit.setSocialIcon,
        );
      case LogoType.image:
        return _UploadRow(
          label: 'Upload image from gallery',
          icon: Icons.upload_rounded,
          onTap: cubit.pickLogoImage,
          preview: logo.imagePath != null
              ? _filePreview(context, File(logo.imagePath!), isSvg: false)
              : null,
        );
      case LogoType.svg:
        return _UploadRow(
          label: 'Upload SVG file',
          icon: Icons.upload_file_rounded,
          onTap: cubit.pickLogoSvg,
          preview: logo.svgPath != null
              ? _filePreview(context, File(logo.svgPath!), isSvg: true)
              : null,
        );
    }
  }

  Widget _filePreview(BuildContext context, File file, {required bool isSvg}) {
    final exists = file.existsSync();
    return Container(
      width: 56,
      height: 56,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: !exists
          ? const Icon(Icons.broken_image_rounded, color: Colors.grey)
          : isSvg
              ? SvgPicture.file(file, fit: BoxFit.contain)
              : Image.file(file, fit: BoxFit.contain),
    );
  }
}

/// Upload button with an optional thumbnail preview of the picked file.
class _UploadRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Future<void> Function() onTap;
  final Widget? preview;

  const _UploadRow({
    required this.label,
    required this.icon,
    required this.onTap,
    this.preview,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (preview != null) ...[
          preview!,
          const SizedBox(width: 12),
        ],
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: onTap,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor:
                  context.colorScheme.primaryContainer.withValues(alpha: 0.8),
              foregroundColor: context.colorScheme.onSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: Icon(icon, size: 20),
            label: Text(preview != null ? 'Replace' : label),
          ),
        ),
      ],
    );
  }
}

/// All badge-styling controls, shown once a logo is configured.
class _LogoStyleCard extends StatelessWidget {
  final LogoConfig logo;
  final QrCustomizationCubit cubit;

  const _LogoStyleCard({required this.logo, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return DesignerSectionCard(
      title: 'Logo style',
      icon: Icons.tune_rounded,
      child: Column(
        children: [
          DesignerSlider(
            label: 'Size',
            icon: Icons.photo_size_select_small_rounded,
            value: logo.size,
            min: 20,
            max: 60,
            divisions: 40,
            format: (v) => '${v.round()} px',
            onChanged: cubit.setLogoSize,
          ),
          const SizedBox(height: 14),
          SegmentedSelector<LogoShape>(
            selected: logo.shape,
            onChanged: cubit.setLogoShape,
            options: const [
              SegmentedOption(
                  value: LogoShape.circle,
                  label: 'Circle',
                  icon: Icons.circle_outlined),
              SegmentedOption(
                  value: LogoShape.roundedRect,
                  label: 'Rounded',
                  icon: Icons.rounded_corner_rounded),
              SegmentedOption(
                  value: LogoShape.square,
                  label: 'Square',
                  icon: Icons.square_outlined),
            ],
          ),
          if (logo.shape == LogoShape.roundedRect) ...[
            const SizedBox(height: 16),
            DesignerSlider(
              label: 'Corner radius',
              icon: Icons.rounded_corner_rounded,
              value: logo.borderRadius,
              min: 0,
              max: 40,
              divisions: 40,
              format: (v) => '${v.round()} px',
              onChanged: cubit.setLogoBorderRadius,
            ),
          ],
          const SizedBox(height: 12),
          DesignerSlider(
            label: 'Padding',
            icon: Icons.padding_rounded,
            value: logo.padding,
            min: 0,
            max: 24,
            divisions: 24,
            format: (v) => '${v.round()} px',
            onChanged: cubit.setLogoPadding,
          ),
          const SizedBox(height: 12),
          DesignerSlider(
            label: 'Opacity',
            icon: Icons.opacity_rounded,
            value: logo.opacity,
            min: 0.2,
            max: 1,
            divisions: 16,
            format: (v) => '${(v * 100).round()}%',
            onChanged: cubit.setLogoOpacity,
          ),
          const SizedBox(height: 12),
          DesignerSlider(
            label: 'Border width',
            icon: Icons.border_outer_rounded,
            value: logo.borderWidth,
            min: 0,
            max: 10,
            divisions: 20,
            format: (v) => v.toStringAsFixed(1),
            onChanged: cubit.setLogoBorderWidth,
          ),
          const SizedBox(height: 4),
          if (logo.type == LogoType.materialIcon)
            ColorPickerField(
              label: 'Icon color',
              icon: Icons.format_color_fill_rounded,
              color: logo.color,
              recentColors: cubit.config.recentColors,
              onChanged: cubit.setLogoColor,
            ),
          if (!logo.transparentBackground)
            ColorPickerField(
              label: 'Background color',
              icon: Icons.format_color_reset_rounded,
              color: logo.backgroundColor,
              recentColors: cubit.config.recentColors,
              onChanged: cubit.setLogoBackgroundColor,
            ),
          ColorPickerField(
            label: 'Border color',
            icon: Icons.border_color_rounded,
            color: logo.borderColor,
            recentColors: cubit.config.recentColors,
            onChanged: cubit.setLogoBorderColor,
          ),
          DesignerSwitchTile(
            label: 'Transparent background',
            icon: Icons.gradient_rounded,
            value: logo.transparentBackground,
            onChanged: cubit.setLogoTransparentBackground,
          ),
          DesignerSwitchTile(
            label: 'Shadow',
            icon: Icons.dark_mode_rounded,
            value: logo.shadow,
            onChanged: cubit.setLogoShadow,
          ),
          if (logo.shadow) ...[
            const SizedBox(height: 6),
            DesignerSlider(
              label: 'Elevation',
              icon: Icons.layers_rounded,
              value: logo.elevation,
              min: 0,
              max: 16,
              divisions: 16,
              format: (v) => v.toStringAsFixed(0),
              onChanged: cubit.setLogoElevation,
            ),
          ],
          const SizedBox(height: 12),
          DesignerSlider(
            label: 'Blur',
            icon: Icons.blur_circular_rounded,
            value: logo.blur,
            min: 0,
            max: 12,
            divisions: 24,
            format: (v) => v.toStringAsFixed(1),
            onChanged: cubit.setLogoBlur,
          ),
        ],
      ),
    );
  }
}
