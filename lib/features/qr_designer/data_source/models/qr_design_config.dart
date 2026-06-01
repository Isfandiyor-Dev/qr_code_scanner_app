import 'logo_config.dart';
import 'qr_design_enums.dart';

/// The complete, persistable description of a designed QR code.
///
/// This single object is what gets saved locally and restored on launch. Colors
/// are 32-bit ARGB integers; the nested [logo] holds all center-logo styling.
class QrDesignConfig {
  /// Rendered size of the QR symbol (logical pixels) inside its card.
  final double qrSize;

  /// ARGB color of the QR modules (foreground).
  final int foregroundColor;

  /// ARGB color painted behind the QR modules.
  final int backgroundColor;

  /// Quiet-zone width expressed in modules ([PrettyQrQuietZone.modules]).
  final double margin;

  /// Shape used for the QR data modules.
  final QrModuleShape moduleShape;

  /// Corner rounding (0.0-1.0) for [QrModuleShape.smooth]/[QrModuleShape.rounded].
  final double moduleRoundness;

  /// When true the finder ("eye") patterns are drawn in a unified rounded style.
  final bool unifiedEyes;

  /// Inner padding of the white card wrapping the QR.
  final double containerPadding;

  /// Corner radius of the card wrapping the QR.
  final double containerBorderRadius;

  /// ARGB color of the card border.
  final int containerBorderColor;

  /// Thickness of the card border (0 = no border).
  final double containerBorderWidth;

  /// Center logo styling.
  final LogoConfig logo;

  /// Most-recently used colors (newest first), surfaced in the color picker.
  final List<int> recentColors;

  /// User-starred colors, surfaced in the color picker.
  final List<int> favoriteColors;

  const QrDesignConfig({
    required this.qrSize,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.margin,
    required this.moduleShape,
    required this.moduleRoundness,
    required this.unifiedEyes,
    required this.containerPadding,
    required this.containerBorderRadius,
    required this.containerBorderColor,
    required this.containerBorderWidth,
    required this.logo,
    required this.recentColors,
    required this.favoriteColors,
  });

  /// Production defaults: a black-on-white QR with smoothly rounded modules and
  /// unified eyes, inside a rounded white card. No logo until the user adds one.
  factory QrDesignConfig.defaults() {
    return QrDesignConfig(
      qrSize: 240,
      foregroundColor: 0xFF000000,
      backgroundColor: 0xFFFFFFFF,
      margin: 2,
      moduleShape: QrModuleShape.smooth,
      moduleRoundness: 0.8,
      unifiedEyes: true,
      containerPadding: 16,
      containerBorderRadius: 24,
      containerBorderColor: 0xFF009688,
      containerBorderWidth: 0,
      logo: LogoConfig.defaults(),
      recentColors: const [],
      favoriteColors: const [],
    );
  }

  /// Returns a copy of this QR design configuration with selected values changed.
  QrDesignConfig copyWith({
    double? qrSize,
    int? foregroundColor,
    int? backgroundColor,
    double? margin,
    QrModuleShape? moduleShape,
    double? moduleRoundness,
    bool? unifiedEyes,
    double? containerPadding,
    double? containerBorderRadius,
    int? containerBorderColor,
    double? containerBorderWidth,
    LogoConfig? logo,
    List<int>? recentColors,
    List<int>? favoriteColors,
  }) {
    return QrDesignConfig(
      qrSize: qrSize ?? this.qrSize,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      margin: margin ?? this.margin,
      moduleShape: moduleShape ?? this.moduleShape,
      moduleRoundness: moduleRoundness ?? this.moduleRoundness,
      unifiedEyes: unifiedEyes ?? this.unifiedEyes,
      containerPadding: containerPadding ?? this.containerPadding,
      containerBorderRadius:
          containerBorderRadius ?? this.containerBorderRadius,
      containerBorderColor: containerBorderColor ?? this.containerBorderColor,
      containerBorderWidth: containerBorderWidth ?? this.containerBorderWidth,
      logo: logo ?? this.logo,
      recentColors: recentColors ?? this.recentColors,
      favoriteColors: favoriteColors ?? this.favoriteColors,
    );
  }

  /// Resets only the QR-appearance fields, preserving the logo and color library.
  QrDesignConfig resetQrAppearance() {
    final defaults = QrDesignConfig.defaults();
    return copyWith(
      qrSize: defaults.qrSize,
      foregroundColor: defaults.foregroundColor,
      backgroundColor: defaults.backgroundColor,
      margin: defaults.margin,
      moduleShape: defaults.moduleShape,
      moduleRoundness: defaults.moduleRoundness,
      unifiedEyes: defaults.unifiedEyes,
      containerPadding: defaults.containerPadding,
      containerBorderRadius: defaults.containerBorderRadius,
      containerBorderColor: defaults.containerBorderColor,
      containerBorderWidth: defaults.containerBorderWidth,
    );
  }

  /// Serializes this QR design configuration to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'qrSize': qrSize,
      'foregroundColor': foregroundColor,
      'backgroundColor': backgroundColor,
      'margin': margin,
      'moduleShape': moduleShape.name,
      'moduleRoundness': moduleRoundness,
      'unifiedEyes': unifiedEyes,
      'containerPadding': containerPadding,
      'containerBorderRadius': containerBorderRadius,
      'containerBorderColor': containerBorderColor,
      'containerBorderWidth': containerBorderWidth,
      'logo': logo.toJson(),
      'recentColors': recentColors,
      'favoriteColors': favoriteColors,
    };
  }

  /// Creates a QR design configuration from a JSON-compatible map.
  factory QrDesignConfig.fromJson(Map<String, dynamic> json) {
    final defaults = QrDesignConfig.defaults();
    return QrDesignConfig(
      qrSize: (json['qrSize'] as num?)?.toDouble() ?? defaults.qrSize,
      foregroundColor: (json['foregroundColor'] as num?)?.toInt() ??
          defaults.foregroundColor,
      backgroundColor: (json['backgroundColor'] as num?)?.toInt() ??
          defaults.backgroundColor,
      margin: (json['margin'] as num?)?.toDouble() ?? defaults.margin,
      moduleShape: QrModuleShape.fromName(json['moduleShape']),
      moduleRoundness: (json['moduleRoundness'] as num?)?.toDouble() ??
          defaults.moduleRoundness,
      unifiedEyes: json['unifiedEyes'] as bool? ?? defaults.unifiedEyes,
      containerPadding: (json['containerPadding'] as num?)?.toDouble() ??
          defaults.containerPadding,
      containerBorderRadius:
          (json['containerBorderRadius'] as num?)?.toDouble() ??
              defaults.containerBorderRadius,
      containerBorderColor: (json['containerBorderColor'] as num?)?.toInt() ??
          defaults.containerBorderColor,
      containerBorderWidth:
          (json['containerBorderWidth'] as num?)?.toDouble() ??
              defaults.containerBorderWidth,
      logo: json['logo'] is Map<String, dynamic>
          ? LogoConfig.fromJson(json['logo'] as Map<String, dynamic>)
          : LogoConfig.defaults(),
      recentColors: _intList(json['recentColors']),
      favoriteColors: _intList(json['favoriteColors']),
    );
  }

  static List<int> _intList(Object? raw) {
    if (raw is! List) return const [];
    return raw.whereType<num>().map((value) => value.toInt()).toList();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QrDesignConfig &&
        other.qrSize == qrSize &&
        other.foregroundColor == foregroundColor &&
        other.backgroundColor == backgroundColor &&
        other.margin == margin &&
        other.moduleShape == moduleShape &&
        other.moduleRoundness == moduleRoundness &&
        other.unifiedEyes == unifiedEyes &&
        other.containerPadding == containerPadding &&
        other.containerBorderRadius == containerBorderRadius &&
        other.containerBorderColor == containerBorderColor &&
        other.containerBorderWidth == containerBorderWidth &&
        other.logo == logo &&
        _listEquals(other.recentColors, recentColors) &&
        _listEquals(other.favoriteColors, favoriteColors);
  }

  @override
  int get hashCode => Object.hash(
        qrSize,
        foregroundColor,
        backgroundColor,
        margin,
        moduleShape,
        moduleRoundness,
        unifiedEyes,
        containerPadding,
        containerBorderRadius,
        containerBorderColor,
        containerBorderWidth,
        logo,
        Object.hashAll(recentColors),
        Object.hashAll(favoriteColors),
      );

  static bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
