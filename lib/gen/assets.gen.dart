// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsGenIconsGen {
  const $AssetsGenIconsGen();

  /// File path: assets/gen_icons/background.svg
  SvgGenImage get background =>
      const SvgGenImage('assets/gen_icons/background.svg');

  /// File path: assets/gen_icons/business.svg
  SvgGenImage get business =>
      const SvgGenImage('assets/gen_icons/business.svg');

  /// File path: assets/gen_icons/contact.svg
  SvgGenImage get contact => const SvgGenImage('assets/gen_icons/contact.svg');

  /// File path: assets/gen_icons/email.svg
  SvgGenImage get email => const SvgGenImage('assets/gen_icons/email.svg');

  /// File path: assets/gen_icons/event.svg
  SvgGenImage get event => const SvgGenImage('assets/gen_icons/event.svg');

  /// File path: assets/gen_icons/instagram.svg
  SvgGenImage get instagram =>
      const SvgGenImage('assets/gen_icons/instagram.svg');

  /// File path: assets/gen_icons/location.svg
  SvgGenImage get location =>
      const SvgGenImage('assets/gen_icons/location.svg');

  /// File path: assets/gen_icons/telephone.svg
  SvgGenImage get telephone =>
      const SvgGenImage('assets/gen_icons/telephone.svg');

  /// File path: assets/gen_icons/text.svg
  SvgGenImage get text => const SvgGenImage('assets/gen_icons/text.svg');

  /// File path: assets/gen_icons/twitter.svg
  SvgGenImage get twitter => const SvgGenImage('assets/gen_icons/twitter.svg');

  /// File path: assets/gen_icons/website.svg
  SvgGenImage get website => const SvgGenImage('assets/gen_icons/website.svg');

  /// File path: assets/gen_icons/whatsapp.svg
  SvgGenImage get whatsapp =>
      const SvgGenImage('assets/gen_icons/whatsapp.svg');

  /// File path: assets/gen_icons/wifi.svg
  SvgGenImage get wifi => const SvgGenImage('assets/gen_icons/wifi.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        background,
        business,
        contact,
        email,
        event,
        instagram,
        location,
        telephone,
        text,
        twitter,
        website,
        whatsapp,
        wifi
      ];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/history_item_leading.png
  AssetGenImage get historyItemLeading =>
      const AssetGenImage('assets/icons/history_item_leading.png');

  /// File path: assets/icons/logo.svg
  SvgGenImage get logo => const SvgGenImage('assets/icons/logo.svg');

  /// File path: assets/icons/scan.png
  AssetGenImage get scan => const AssetGenImage('assets/icons/scan.png');

  /// File path: assets/icons/settings.svg
  SvgGenImage get settings => const SvgGenImage('assets/icons/settings.svg');

  /// List of all assets
  List<dynamic> get values => [historyItemLeading, logo, scan, settings];
}

class Assets {
  const Assets._();

  static const SvgGenImage empty = SvgGenImage('assets/empty.svg');
  static const $AssetsGenIconsGen genIcons = $AssetsGenIconsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const SvgGenImage qrcode = SvgGenImage('assets/qrcode.svg');

  /// List of all assets
  static List<SvgGenImage> get values => [empty, qrcode];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
