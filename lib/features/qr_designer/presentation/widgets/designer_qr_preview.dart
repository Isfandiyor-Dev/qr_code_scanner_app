import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../data_source/models/qr_design_config.dart';
import '../utils/qr_decoration_builder.dart';
import 'logo_badge.dart';

/// Renders a QR code from a [QrDesignConfig].
///
/// It is deliberately bloc-agnostic: callers pass a [config] (the result screen
/// passes its loaded design; the editor wraps it in a `BlocBuilder`). Because
/// export captures this exact widget via a `RepaintBoundary`, what the user sees
/// is what they get.
class DesignerQrPreview extends StatelessWidget {
  /// The QR payload to encode.
  final String data;

  /// The design to render.
  final QrDesignConfig config;

  /// When true a soft drop shadow floats the card (disabled for raster export so
  /// the PNG has clean edges).
  final bool showShadow;

  const DesignerQrPreview({
    super.key,
    required this.data,
    required this.config,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Color(config.backgroundColor);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      padding: EdgeInsets.all(config.containerPadding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(config.containerBorderRadius),
        border: config.containerBorderWidth > 0
            ? Border.all(
                color: Color(config.containerBorderColor),
                width: config.containerBorderWidth,
              )
            : null,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.28),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: SizedBox(
        width: config.qrSize,
        height: config.qrSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            PrettyQrView.data(
              data: data,
              errorCorrectLevel: QrDecorationBuilder.errorCorrectLevel,
              decoration: QrDecorationBuilder.build(config),
            ),
            LogoBadge(logo: config.logo),
          ],
        ),
      ),
    );
  }
}
