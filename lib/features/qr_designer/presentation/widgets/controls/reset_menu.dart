import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_text_theme_extension.dart';
import 'package:qr_code_scanner_app/core/widgets/snackbar.dart';

import '../../cubit/qr_customization_cubit.dart';

/// Opens the reset options sheet: granular resets (QR / Logo / Colors) plus a
/// guarded "Reset Everything" that asks for confirmation.
///
/// All resets are in-memory (the editing session) and only persist when the
/// user saves. Invoked from the editor's AppBar.
Future<void> showQrResetMenu(BuildContext context) {
  final cubit = context.read<QrCustomizationCubit>();

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: context.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: sheetContext.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 8),
            _ResetTile(
              icon: Icons.qr_code_2_rounded,
              title: 'Reset QR settings',
              subtitle: 'Size, shape, margin & card',
              onTap: () {
                Navigator.of(sheetContext).pop();
                cubit.resetQrSettings();
                showMessageSnackBar('QR settings reset', context);
              },
            ),
            _ResetTile(
              icon: Icons.image_rounded,
              title: 'Reset logo settings',
              subtitle: 'Removes the logo and its styling',
              onTap: () {
                Navigator.of(sheetContext).pop();
                cubit.resetLogoSettings();
                showMessageSnackBar('Logo settings reset', context);
              },
            ),
            _ResetTile(
              icon: Icons.palette_rounded,
              title: 'Reset colors',
              subtitle: 'Clears recent & favorite colors',
              onTap: () {
                Navigator.of(sheetContext).pop();
                cubit.resetColors();
                showMessageSnackBar('Colors reset', context);
              },
            ),
            Divider(
              color: sheetContext.colorScheme.outlineVariant
                  .withValues(alpha: 0.3),
              indent: 20,
              endIndent: 20,
            ),
            _ResetTile(
              icon: Icons.delete_sweep_rounded,
              title: 'Reset everything',
              subtitle: 'Restore all settings to defaults',
              danger: true,
              onTap: () async {
                Navigator.of(sheetContext).pop();
                final confirmed = await _confirmResetEverything(context);
                if (confirmed) {
                  cubit.resetEverything();
                  if (context.mounted) {
                    showMessageSnackBar(
                        'Everything reset to defaults', context);
                  }
                }
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
}

Future<bool> _confirmResetEverything(BuildContext context) async {
  final colorScheme = context.colorScheme;
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Reset everything?', style: context.textTheme.titleLarge),
      content: Text(
        'This restores all QR and logo settings to their defaults. '
        'Your design is only persisted when you save.',
        style: context.textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text('Cancel', style: TextStyle(color: colorScheme.onSurface)),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
          child: const Text('Reset'),
        ),
      ],
    ),
  );
  return result ?? false;
}

class _ResetTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool danger;

  const _ResetTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final color = danger ? colorScheme.error : colorScheme.onSurface;

    return ListTile(
      onTap: onTap,
      leading:
          Icon(icon, color: danger ? colorScheme.error : colorScheme.primary),
      title: Text(
        title,
        style: context.textTheme.bodyLarge?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: context.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
