import 'qr_design_enums.dart';

/// Sentinel used by [LogoConfig.copyWith] to distinguish "argument omitted"
/// from "explicitly set to null" for nullable fields.
const Object _undefined = Object();

/// Immutable description of the center logo badge of a designed QR code.
///
/// Colors are stored as 32-bit ARGB integers so the whole object serializes to
/// plain JSON. The Material icon is stored as a [materialIconCodePoint] which is
/// resolved back to a const `IconData` from the curated catalog at render time
/// (keeping icon tree-shaking intact).
class LogoConfig {
  final LogoType type;

  /// Code point of the selected built-in Material icon (resolved via catalog).
  final int? materialIconCodePoint;

  /// Stable path (inside app documents) of an uploaded raster image.
  final String? imagePath;

  /// Stable path (inside app documents) of an uploaded SVG file.
  final String? svgPath;

  /// Bundled SVG asset path of a built-in icon (e.g. a social network logo).
  final String? assetIconPath;

  /// Logical size of the logo content (icon glyph / image) in pixels.
  final double size;

  /// ARGB tint applied to icons and SVGs (ignored for raster images).
  final int color;

  /// ARGB fill color of the badge behind the logo content.
  final int backgroundColor;

  /// ARGB color of the badge border.
  final int borderColor;

  /// Badge border thickness.
  final double borderWidth;

  /// Corner radius used when [shape] is [LogoShape.roundedRect].
  final double borderRadius;

  /// Inner padding between the badge edge and the logo content.
  final double padding;

  /// Overall badge opacity (0.0-1.0).
  final double opacity;

  /// Badge container shape.
  final LogoShape shape;

  /// Whether to draw a drop shadow under the badge.
  final bool shadow;

  /// Material elevation of the badge (drives shadow depth).
  final double elevation;

  /// Backdrop blur sigma applied behind the badge (best-effort, preview-grade).
  final double blur;

  /// When true the badge background is fully transparent.
  final bool transparentBackground;

  const LogoConfig({
    required this.type,
    required this.materialIconCodePoint,
    required this.imagePath,
    required this.svgPath,
    required this.assetIconPath,
    required this.size,
    required this.color,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.padding,
    required this.opacity,
    required this.shape,
    required this.shadow,
    required this.elevation,
    required this.blur,
    required this.transparentBackground,
  });

  /// Sensible production defaults: no logo, white rounded badge with a soft
  /// shadow that reads well on top of a white QR card.
  factory LogoConfig.defaults() {
    return const LogoConfig(
      type: LogoType.none,
      materialIconCodePoint: null,
      imagePath: null,
      svgPath: null,
      assetIconPath: null,
      size: 52,
      color: 0xFF000000,
      backgroundColor: 0xFFFFFFFF,
      borderColor: 0xFFFFFFFF,
      borderWidth: 0,
      borderRadius: 16,
      padding: 8,
      opacity: 1,
      shape: LogoShape.roundedRect,
      shadow: true,
      elevation: 4,
      blur: 0,
      transparentBackground: false,
    );
  }

  /// Whether a logo is configured and renderable.
  bool get hasLogo {
    switch (type) {
      case LogoType.none:
        return false;
      case LogoType.materialIcon:
        return materialIconCodePoint != null;
      case LogoType.assetIcon:
        return assetIconPath != null;
      case LogoType.image:
        return imagePath != null;
      case LogoType.svg:
        return svgPath != null;
    }
  }

  /// Returns a copy of this logo configuration with selected values changed.
  LogoConfig copyWith({
    LogoType? type,
    Object? materialIconCodePoint = _undefined,
    Object? imagePath = _undefined,
    Object? svgPath = _undefined,
    Object? assetIconPath = _undefined,
    double? size,
    int? color,
    int? backgroundColor,
    int? borderColor,
    double? borderWidth,
    double? borderRadius,
    double? padding,
    double? opacity,
    LogoShape? shape,
    bool? shadow,
    double? elevation,
    double? blur,
    bool? transparentBackground,
  }) {
    return LogoConfig(
      type: type ?? this.type,
      materialIconCodePoint: identical(materialIconCodePoint, _undefined)
          ? this.materialIconCodePoint
          : materialIconCodePoint as int?,
      imagePath: identical(imagePath, _undefined)
          ? this.imagePath
          : imagePath as String?,
      svgPath:
          identical(svgPath, _undefined) ? this.svgPath : svgPath as String?,
      assetIconPath: identical(assetIconPath, _undefined)
          ? this.assetIconPath
          : assetIconPath as String?,
      size: size ?? this.size,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      opacity: opacity ?? this.opacity,
      shape: shape ?? this.shape,
      shadow: shadow ?? this.shadow,
      elevation: elevation ?? this.elevation,
      blur: blur ?? this.blur,
      transparentBackground:
          transparentBackground ?? this.transparentBackground,
    );
  }

  /// Serializes this logo configuration to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'materialIconCodePoint': materialIconCodePoint,
      'imagePath': imagePath,
      'svgPath': svgPath,
      'assetIconPath': assetIconPath,
      'size': size,
      'color': color,
      'backgroundColor': backgroundColor,
      'borderColor': borderColor,
      'borderWidth': borderWidth,
      'borderRadius': borderRadius,
      'padding': padding,
      'opacity': opacity,
      'shape': shape.name,
      'shadow': shadow,
      'elevation': elevation,
      'blur': blur,
      'transparentBackground': transparentBackground,
    };
  }

  /// Creates a logo configuration from a JSON-compatible map.
  factory LogoConfig.fromJson(Map<String, dynamic> json) {
    final defaults = LogoConfig.defaults();
    return LogoConfig(
      type: LogoType.fromName(json['type']),
      materialIconCodePoint: (json['materialIconCodePoint'] as num?)?.toInt(),
      imagePath: json['imagePath'] as String?,
      svgPath: json['svgPath'] as String?,
      assetIconPath: json['assetIconPath'] as String?,
      size: (json['size'] as num?)?.toDouble() ?? defaults.size,
      color: (json['color'] as num?)?.toInt() ?? defaults.color,
      backgroundColor: (json['backgroundColor'] as num?)?.toInt() ??
          defaults.backgroundColor,
      borderColor:
          (json['borderColor'] as num?)?.toInt() ?? defaults.borderColor,
      borderWidth:
          (json['borderWidth'] as num?)?.toDouble() ?? defaults.borderWidth,
      borderRadius:
          (json['borderRadius'] as num?)?.toDouble() ?? defaults.borderRadius,
      padding: (json['padding'] as num?)?.toDouble() ?? defaults.padding,
      opacity: (json['opacity'] as num?)?.toDouble() ?? defaults.opacity,
      shape: LogoShape.fromName(json['shape']),
      shadow: json['shadow'] as bool? ?? defaults.shadow,
      elevation: (json['elevation'] as num?)?.toDouble() ?? defaults.elevation,
      blur: (json['blur'] as num?)?.toDouble() ?? defaults.blur,
      transparentBackground: json['transparentBackground'] as bool? ??
          defaults.transparentBackground,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LogoConfig &&
        other.type == type &&
        other.materialIconCodePoint == materialIconCodePoint &&
        other.imagePath == imagePath &&
        other.svgPath == svgPath &&
        other.assetIconPath == assetIconPath &&
        other.size == size &&
        other.color == color &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.opacity == opacity &&
        other.shape == shape &&
        other.shadow == shadow &&
        other.elevation == elevation &&
        other.blur == blur &&
        other.transparentBackground == transparentBackground;
  }

  @override
  int get hashCode => Object.hashAll([
        type,
        materialIconCodePoint,
        imagePath,
        svgPath,
        assetIconPath,
        size,
        color,
        backgroundColor,
        borderColor,
        borderWidth,
        borderRadius,
        padding,
        opacity,
        shape,
        shadow,
        elevation,
        blur,
        transparentBackground,
      ]);
}
