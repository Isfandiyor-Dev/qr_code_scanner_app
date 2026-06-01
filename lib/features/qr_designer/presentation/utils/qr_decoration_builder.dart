import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../data_source/models/qr_design_config.dart';
import '../../data_source/models/qr_design_enums.dart';

/// Maps a [QrDesignConfig] to a `pretty_qr_code` [PrettyQrDecoration].
///
/// This is the single source of truth for translating the saved design into the
/// QR rendering, used by the live preview (and therefore by the WYSIWYG export,
/// which captures that same preview). The center logo is intentionally *not*
/// embedded here; it is overlaid as a styled badge so it can have a background,
/// border, shadow and shape that `PrettyQrDecorationImage` cannot express.
class QrDecorationBuilder {
  const QrDecorationBuilder._();

  /// Error-correction level. Kept at `H` so an overlaid logo never stops the QR
  /// from scanning.
  static const int errorCorrectLevel = QrErrorCorrectLevel.H;

  /// Builds the QR decoration used by previews and exported images.
  static PrettyQrDecoration build(QrDesignConfig config) {
    return PrettyQrDecoration(
      background: Color(config.backgroundColor),
      quietZone: PrettyQrQuietZone.modules(config.margin),
      shape: _shape(config),
    );
  }

  static PrettyQrShape _shape(QrDesignConfig config) {
    final color = Color(config.foregroundColor);
    switch (config.moduleShape) {
      case QrModuleShape.smooth:
        return PrettyQrSmoothSymbol(
          color: color,
          roundFactor: config.moduleRoundness.clamp(0.0, 1.0),
        );
      case QrModuleShape.rounded:
        return PrettyQrSquaresSymbol(
          color: color,
          rounding: config.moduleRoundness.clamp(0.0, 1.0),
          unifiedFinderPattern: config.unifiedEyes,
        );
      case QrModuleShape.dots:
        return PrettyQrDotsSymbol(
          color: color,
          unifiedFinderPattern: config.unifiedEyes,
          unifiedAlignmentPatterns: config.unifiedEyes,
        );
    }
  }
}
