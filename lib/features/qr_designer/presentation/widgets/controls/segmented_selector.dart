import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_text_theme_extension.dart';

/// A single option within a [SegmentedSelector].
class SegmentedOption<T> {
  final T value;
  final String label;
  final IconData? icon;

  const SegmentedOption({required this.value, required this.label, this.icon});
}

/// A premium pill-style segmented control used for discrete choices (module
/// shape, logo type, logo shape, and similar values). Animates the selected segment and adapts to
/// any number of options by sharing width evenly.
class SegmentedSelector<T> extends StatelessWidget {
  final List<SegmentedOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;

  const SegmentedSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (final option in options)
            Expanded(
              child: _Segment<T>(
                option: option,
                selected: option.value == selected,
                onTap: () => onChanged(option.value),
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment<T> extends StatelessWidget {
  final SegmentedOption<T> option;
  final bool selected;
  final VoidCallback onTap;

  const _Segment({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final foreground = selected
        ? colorScheme.secondary
        : colorScheme.onSurface.withValues(alpha: 0.7);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (option.icon != null) ...[
              Icon(option.icon, size: 19, color: foreground),
              const SizedBox(height: 4),
            ],
            Text(
              option.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: context.textTheme.labelSmall?.copyWith(
                color: foreground,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
