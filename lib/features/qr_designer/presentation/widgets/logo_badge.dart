import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

import '../../data_source/models/logo_config.dart';
import '../../data_source/models/qr_design_enums.dart';
import '../utils/icon_catalog.dart';

/// The styled center logo rendered on top of the QR code.
///
/// Supports Material icons, gallery images and SVGs, each wrapped in a badge
/// with a configurable background, border, shape, padding, opacity, shadow and
/// (best-effort) backdrop blur. Renders nothing when no logo is configured.
class LogoBadge extends StatelessWidget {
  final LogoConfig logo;

  const LogoBadge({super.key, required this.logo});

  @override
  Widget build(BuildContext context) {
    if (!logo.hasLogo) return const SizedBox.shrink();

    final content = SizedBox(
      width: logo.size,
      height: logo.size,
      child: _buildContent(),
    );

    final isCircle = logo.shape == LogoShape.circle;
    final radius = switch (logo.shape) {
      LogoShape.circle => BorderRadius.zero,
      LogoShape.square => BorderRadius.zero,
      LogoShape.roundedRect => BorderRadius.circular(logo.borderRadius),
    };

    final background = logo.transparentBackground
        ? Colors.transparent
        : Color(logo.backgroundColor);

    Widget badge = Container(
      padding: EdgeInsets.all(logo.padding),
      decoration: BoxDecoration(
        color: background,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : radius,
        border: logo.borderWidth > 0
            ? Border.all(
                color: Color(logo.borderColor), width: logo.borderWidth)
            : null,
        boxShadow: logo.shadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.22),
                  blurRadius: logo.elevation * 2.2,
                  offset: Offset(0, logo.elevation * 0.6),
                ),
              ]
            : null,
      ),
      child: content,
    );

    // Frosted-glass effect: blur whatever sits behind the badge (the QR modules).
    if (logo.blur > 0) {
      badge = ClipRRect(
        borderRadius: isCircle ? BorderRadius.circular(1000) : radius,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: logo.blur, sigmaY: logo.blur),
          child: badge,
        ),
      );
    }

    return Opacity(opacity: logo.opacity.clamp(0.0, 1.0), child: badge);
  }

  Widget _buildContent() {
    switch (logo.type) {
      case LogoType.none:
        return const SizedBox.shrink();
      case LogoType.materialIcon:
        final icon = iconForCodePoint(logo.materialIconCodePoint);
        if (icon == null) return const SizedBox.shrink();
        return FittedBox(
          child: Icon(icon, size: logo.size, color: Color(logo.color)),
        );
      case LogoType.assetIcon:
        return _buildAssetIcon();
      case LogoType.image:
        return _buildImage();
      case LogoType.svg:
        return _buildSvg();
    }
  }

  Widget _buildAssetIcon() {
    final path = logo.assetIconPath;
    if (path == null) return const SizedBox.shrink();
    // Built-in brand SVGs keep their own colors (no tint).
    return SvgPicture.asset(
      path,
      fit: BoxFit.contain,
      placeholderBuilder: (_) => const SizedBox.shrink(),
    );
  }

  Widget _buildImage() {
    final path = logo.imagePath;
    if (path == null || !File(path).existsSync()) {
      return const SizedBox.shrink();
    }
    return Image.file(
      File(path),
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  }

  Widget _buildSvg() {
    final path = logo.svgPath;
    if (path == null || !File(path).existsSync()) {
      return const SizedBox.shrink();
    }
    return SvgPicture.file(
      File(path),
      fit: BoxFit.contain,
      // Preserve the SVG's own colors (tinting would flatten multi-color logos).
      placeholderBuilder: (_) => const SizedBox.shrink(),
    );
  }
}
