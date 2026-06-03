import 'package:flutter/material.dart';
import 'package:qr_code_app/core/extensions/context/app_text_theme_extension.dart';
import 'package:svg_flutter/svg.dart';

import '../../utils/icon_catalog.dart';

/// A 4-row, horizontally-scrolling picker of center-logo icons.
///
/// Bundled social/brand SVGs (on light tiles) come first, then a divider, then
/// the curated Material icons (on dark tiles) so the two groups read as clearly
/// distinct and the user scrolls sideways from social to standard icons. The
/// selected tile is highlighted with a border and a slight shadow.
class LogoIconGrid extends StatelessWidget {
  /// Code point of the currently selected Material icon (if any).
  final int? selectedCodePoint;

  /// Asset path of the currently selected social/brand icon (if any).
  final String? selectedAssetPath;

  final ValueChanged<int> onSelectMaterial;
  final ValueChanged<String> onSelectSocial;

  const LogoIconGrid({
    super.key,
    required this.selectedCodePoint,
    required this.selectedAssetPath,
    required this.onSelectMaterial,
    required this.onSelectSocial,
  });

  static const double _cell = 56;
  static const double _gap = 10;
  static const int _rows = 4;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    const gridHeight = _cell * _rows + _gap * (_rows - 1);

    final socialCells = [
      for (final path in kSocialLogoAssets)
        _IconCell(
          selected: path == selectedAssetPath,
          background: Colors.white,
          onTap: () => onSelectSocial(path),
          child: SvgPicture.asset(path, fit: BoxFit.contain),
        ),
    ];

    final materialCells = [
      for (final icon in kLogoIconCatalog)
        _IconCell(
          selected: icon.codePoint == selectedCodePoint,
          background: colorScheme.primaryContainer.withValues(alpha: 0.7),
          onTap: () => onSelectMaterial(icon.codePoint),
          child: Icon(
            icon,
            size: 26,
            color: colorScheme.onSurface.withValues(alpha: 0.85),
          ),
        ),
    ];

    return SizedBox(
      height: gridHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._columns(socialCells),
            if (socialCells.isNotEmpty && materialCells.isNotEmpty)
              _divider(colorScheme, gridHeight),
            ..._columns(materialCells),
          ],
        ),
      ),
    );
  }

  /// Chunks [cells] into vertical columns of [_rows], laid out left-to-right.
  List<Widget> _columns(List<Widget> cells) {
    final columns = <Widget>[];
    for (var i = 0; i < cells.length; i += _rows) {
      final end = (i + _rows <= cells.length) ? i + _rows : cells.length;
      final chunk = cells.sublist(i, end);
      columns.add(
        Padding(
          padding: const EdgeInsets.only(right: _gap),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var j = 0; j < chunk.length; j++)
                Padding(
                  padding: EdgeInsets.only(bottom: j == chunk.length - 1 ? 0 : _gap),
                  child: chunk[j],
                ),
            ],
          ),
        ),
      );
    }
    return columns;
  }

  Widget _divider(ColorScheme colorScheme, double height) {
    // Full row height, horizontal margin only; vertical margin would
    // exceed the fixed row height and overflow.
    return Container(
      width: 1,
      height: height,
      margin: const EdgeInsets.only(right: 20, left: 10),
      color: colorScheme.outlineVariant.withValues(alpha: 0.4),
    );
  }
}

class _IconCell extends StatelessWidget {
  final bool selected;
  final Color background;
  final VoidCallback onTap;
  final Widget child;

  const _IconCell({
    required this.selected,
    required this.background,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 56,
        height: 56,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                selected ? colorScheme.primary : colorScheme.outlineVariant.withValues(alpha: 0.2),
            width: selected ? 2.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 7,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(child: child),
      ),
    );
  }
}
