import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_source/models/qr_design_enums.dart';
import '../../cubit/qr_customization_cubit.dart';
import '../../cubit/qr_customization_state.dart';
import '../controls/color_picker_field.dart';
import '../controls/designer_section_card.dart';
import '../controls/designer_slider.dart';
import '../controls/designer_switch_tile.dart';
import '../controls/segmented_selector.dart';

/// "QR" tab: size, module shape & roundness, eye style, margin, foreground /
/// background colors, and the wrapping card (padding, radius, border).
class QrAppearanceSection extends StatelessWidget {
  const QrAppearanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QrCustomizationCubit, QrCustomizationState>(
      buildWhen: (previous, current) => previous.config != current.config,
      builder: (context, state) {
        final cubit = context.read<QrCustomizationCubit>();
        final config = state.config;
        final supportsRoundness = config.moduleShape != QrModuleShape.dots;
        final supportsEyes = config.moduleShape != QrModuleShape.smooth;

        return Column(
          children: [
            DesignerSectionCard(
              title: 'Shape & size',
              icon: Icons.qr_code_2_rounded,
              child: Column(
                children: [
                  DesignerSlider(
                    label: 'QR size',
                    icon: Icons.photo_size_select_large_rounded,
                    value: config.qrSize,
                    min: 160,
                    max: 320,
                    divisions: 32,
                    format: (v) => '${v.round()} px',
                    onChanged: cubit.setQrSize,
                  ),
                  const SizedBox(height: 14),
                  SegmentedSelector<QrModuleShape>(
                    selected: config.moduleShape,
                    onChanged: cubit.setModuleShape,
                    options: const [
                      SegmentedOption(
                        value: QrModuleShape.smooth,
                        label: 'Smooth',
                        icon: Icons.blur_on_rounded,
                      ),
                      SegmentedOption(
                        value: QrModuleShape.rounded,
                        label: 'Rounded',
                        icon: Icons.rounded_corner_rounded,
                      ),
                      SegmentedOption(
                        value: QrModuleShape.dots,
                        label: 'Dots',
                        icon: Icons.grain_rounded,
                      ),
                    ],
                  ),
                  if (supportsRoundness) ...[
                    const SizedBox(height: 16),
                    DesignerSlider(
                      label: 'Corner roundness',
                      icon: Icons.rounded_corner_rounded,
                      value: config.moduleRoundness,
                      min: 0,
                      max: 1,
                      divisions: 20,
                      format: (v) => '${(v * 100).round()}%',
                      onChanged: cubit.setModuleRoundness,
                    ),
                  ],
                  if (supportsEyes) ...[
                    const SizedBox(height: 6),
                    DesignerSwitchTile(
                      label: 'Unified eyes',
                      subtitle: 'Rounded finder patterns',
                      icon: Icons.center_focus_strong_rounded,
                      value: config.unifiedEyes,
                      onChanged: cubit.setUnifiedEyes,
                    ),
                  ],
                  const SizedBox(height: 10),
                  DesignerSlider(
                    label: 'Margin',
                    icon: Icons.crop_free_rounded,
                    value: config.margin,
                    min: 0,
                    max: 8,
                    divisions: 16,
                    format: (v) => v.toStringAsFixed(1),
                    onChanged: cubit.setMargin,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            DesignerSectionCard(
              title: 'Card',
              icon: Icons.crop_din_rounded,
              child: Column(
                children: [
                  DesignerSlider(
                    label: 'Padding',
                    icon: Icons.padding_rounded,
                    value: config.containerPadding,
                    min: 0,
                    max: 40,
                    divisions: 40,
                    format: (v) => '${v.round()} px',
                    onChanged: cubit.setContainerPadding,
                  ),
                  const SizedBox(height: 12),
                  DesignerSlider(
                    label: 'Corner radius',
                    icon: Icons.rounded_corner_rounded,
                    value: config.containerBorderRadius,
                    min: 0,
                    max: 48,
                    divisions: 48,
                    format: (v) => '${v.round()} px',
                    onChanged: cubit.setContainerBorderRadius,
                  ),
                  const SizedBox(height: 12),
                  DesignerSlider(
                    label: 'Border width',
                    icon: Icons.border_outer_rounded,
                    value: config.containerBorderWidth,
                    min: 0,
                    max: 12,
                    divisions: 24,
                    format: (v) => v.toStringAsFixed(1),
                    onChanged: cubit.setContainerBorderWidth,
                  ),
                  ColorPickerField(
                    label: 'Border color',
                    icon: Icons.border_color_rounded,
                    color: config.containerBorderColor,
                    recentColors: config.recentColors,
                    onChanged: cubit.setContainerBorderColor,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
