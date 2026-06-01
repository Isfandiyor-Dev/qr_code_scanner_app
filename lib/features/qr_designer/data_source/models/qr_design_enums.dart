/// Enumerations describing the customizable aspects of a designed QR code.
///
/// All enums are persisted by their [Enum.name] and parsed back defensively so
/// that adding/removing values never breaks an older saved configuration.
library;

/// The shape applied to the QR data modules.
///
/// Note: `pretty_qr_code` applies a single shape to the whole matrix, so this
/// drives the entire symbol. The "eye" treatment is controlled separately by
/// [QrDesignConfig.unifiedEyes].
enum QrModuleShape {
  /// Smoothly connected modules ([PrettyQrSmoothSymbol]).
  smooth,

  /// Square modules with adjustable corner rounding ([PrettyQrSquaresSymbol]).
  rounded,

  /// Detached dots ([PrettyQrDotsSymbol]).
  dots;

  /// Parses [name] into a [QrModuleShape], falling back to [smooth].
  static QrModuleShape fromName(Object? name) {
    return QrModuleShape.values.firstWhere(
      (value) => value.name == name,
      orElse: () => QrModuleShape.smooth,
    );
  }
}

/// The kind of asset shown at the center of the QR code.
enum LogoType {
  /// No center logo.
  none,

  /// A built-in Material icon.
  materialIcon,

  /// A built-in bundled SVG asset (e.g. a social network logo).
  assetIcon,

  /// A raster image picked from the gallery.
  image,

  /// A vector image picked from the file system.
  svg;

  /// Parses [name] into a [LogoType], falling back to [none].
  static LogoType fromName(Object? name) {
    return LogoType.values.firstWhere(
      (value) => value.name == name,
      orElse: () => LogoType.none,
    );
  }
}

/// The container shape of the center logo badge.
enum LogoShape {
  /// A perfect circle.
  circle,

  /// A rounded rectangle (radius driven by [LogoConfig.borderRadius]).
  roundedRect,

  /// A sharp-cornered square.
  square;

  /// Parses [name] into a [LogoShape], falling back to [roundedRect].
  static LogoShape fromName(Object? name) {
    return LogoShape.values.firstWhere(
      (value) => value.name == name,
      orElse: () => LogoShape.roundedRect,
    );
  }
}
