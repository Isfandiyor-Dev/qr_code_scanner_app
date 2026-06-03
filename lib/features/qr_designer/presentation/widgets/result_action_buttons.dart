import 'package:flutter/material.dart';
import 'package:qr_code_app/core/extensions/context/app_text_theme_extension.dart';

/// The result-screen action row: a prominent **Edit** button (icon + text)
/// followed by compact filled **Download** and **Share** buttons.
class ResultActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDownload;
  final VoidCallback onShare;

  const ResultActionButtons({
    super.key,
    required this.onEdit,
    required this.onDownload,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: onEdit,
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              minimumSize: const Size.fromHeight(60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            icon: const Icon(Icons.tune_rounded, size: 24),
            label: Text(
              'Edit',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _CompactAction(
          icon: Icons.file_download_rounded,
          tooltip: 'Download',
          onPressed: onDownload,
        ),
        const SizedBox(width: 12),
        _CompactAction(
          icon: Icons.share_rounded,
          tooltip: 'Share',
          onPressed: onShare,
        ),
      ],
    );
  }
}

class _CompactAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _CompactAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Tooltip(
      message: tooltip,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.9),
          fixedSize: const Size(60, 60),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Icon(icon, size: 24),
      ),
    );
  }
}
