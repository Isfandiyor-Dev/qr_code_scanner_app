import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_app/core/di/di.dart';
import 'package:qr_code_app/core/extensions/context/app_media_query_size_extension.dart';
import 'package:qr_code_app/core/extensions/context/app_text_theme_extension.dart';
import 'package:qr_code_app/core/services/qr_image_service.dart';
import 'package:qr_code_app/core/widgets/snackbar.dart';

import '../../data_source/models/qr_design_config.dart';
import '../cubit/qr_customization_cubit.dart';
import '../cubit/qr_customization_state.dart';
import '../widgets/controls/reset_menu.dart';
import '../widgets/controls/segmented_selector.dart';
import '../widgets/designer_qr_preview.dart';
import '../widgets/sections/color_section.dart';
import '../widgets/sections/logo_section.dart';
import '../widgets/sections/qr_appearance_section.dart';

/// Full-screen QR design editor for a single QR [code].
///
/// Owns its own [QrCustomizationCubit] seeded with [initialConfig]; all edits
/// live only in this session until the user saves. Returns `true` to the result
/// screen when changes were saved.
class QrDesignEditPage extends StatelessWidget {
  final String code;
  final String data;
  final QrDesignConfig initialConfig;

  const QrDesignEditPage({
    super.key,
    required this.code,
    required this.data,
    required this.initialConfig,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QrCustomizationCubit>(
      create: (_) => getIt<QrCustomizationCubit>()..start(code: code, initial: initialConfig),
      child: _QrDesignEditView(data: data),
    );
  }
}

enum _LeaveAction { save, discard }

class _QrDesignEditView extends StatefulWidget {
  final String data;

  const _QrDesignEditView({required this.data});

  @override
  State<_QrDesignEditView> createState() => _QrDesignEditViewState();
}

class _QrDesignEditViewState extends State<_QrDesignEditView> {
  final GlobalKey _previewKey = GlobalKey();
  int _tabIndex = 0;

  // Save and leave handling.

  Future<void> _save() async {
    final cubit = context.read<QrCustomizationCubit>();
    final navigator = Navigator.of(context);
    final ok = await cubit.save();
    if (!mounted) return;
    if (ok) {
      navigator.pop(true);
    } else {
      showErrorSnackBar(cubit.state.errorMessage ?? 'Could not save', context);
    }
  }

  Future<void> _handlePop() async {
    final action = await _showUnsavedDialog();
    if (!mounted || action == null) return; // Closing the dialog keeps editing.
    if (action == _LeaveAction.save) {
      await _save();
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<_LeaveAction?> _showUnsavedDialog() {
    final colorScheme = context.colorScheme;
    return showDialog<_LeaveAction>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 14, 14, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Save changes?',
                      style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    icon: const Icon(Icons.close_rounded),
                    color: colorScheme.onSurface,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'You have unsaved changes to this QR design.',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(_LeaveAction.discard),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        foregroundColor: colorScheme.onSurface,
                        side: BorderSide(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text("Don't Save"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(dialogContext).pop(_LeaveAction.save),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Downloads the current (possibly unsaved) design via the shared service, so
  /// the permission + capture + feedback flow matches the result screen exactly.
  Future<void> _download() => QrImageService.saveToGallery(context, _previewKey);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QrCustomizationCubit, QrCustomizationState>(
      buildWhen: (previous, current) => previous.isDirty != current.isDirty,
      builder: (context, state) {
        return PopScope(
          canPop: !state.isDirty,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _handlePop();
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              title: Text(
                'Design your QR',
                style: context.textTheme.headlineSmall,
              ),
              actions: [
                IconButton(
                  tooltip: 'Reset',
                  onPressed: () => showQrResetMenu(context),
                  icon: const Icon(Icons.restart_alt_rounded),
                ),
                const SizedBox(width: 4),
              ],
            ),
            body: Column(
              children: [
                _preview(context),
                _tabs(context),
                Expanded(
                  child: IndexedStack(
                    index: _tabIndex,
                    children: const [
                      _TabScrollView(child: QrAppearanceSection()),
                      _TabScrollView(child: LogoSection()),
                      _TabScrollView(child: ColorSection()),
                    ],
                  ),
                ),
                _footer(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _preview(BuildContext context) {
    final previewHeight = (context.height * 0.34).clamp(240.0, 360.0);
    return Container(
      height: previewHeight,
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: BlocBuilder<QrCustomizationCubit, QrCustomizationState>(
        buildWhen: (previous, current) => previous.config != current.config,
        builder: (context, state) {
          return FittedBox(
            fit: BoxFit.scaleDown,
            child: RepaintBoundary(
              key: _previewKey,
              child: DesignerQrPreview(
                data: widget.data,
                config: state.config,
                showShadow: false,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _tabs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: SegmentedSelector<int>(
        selected: _tabIndex,
        onChanged: (index) => setState(() => _tabIndex = index),
        options: const [
          SegmentedOption(value: 0, label: 'QR', icon: Icons.qr_code_2_rounded),
          SegmentedOption(value: 1, label: 'Logo', icon: Icons.image_rounded),
          SegmentedOption(value: 2, label: 'Colors', icon: Icons.palette_rounded),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context) {
    final colorScheme = context.colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.25),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _download,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  foregroundColor: colorScheme.onSurface,
                  side: BorderSide(color: colorScheme.primary, width: 1.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.file_download_rounded),
                label: const Text(
                  'Download',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.bookmark_added_rounded),
                label: Text(
                  'Save',
                  style: context.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabScrollView extends StatelessWidget {
  final Widget child;

  const _TabScrollView({required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      physics: const BouncingScrollPhysics(),
      child: child,
    );
  }
}
