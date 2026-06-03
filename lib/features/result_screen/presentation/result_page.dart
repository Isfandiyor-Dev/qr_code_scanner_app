// ignore_for_file: use_build_context_synchronously

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:qr_code_app/core/di/di.dart';
import 'package:qr_code_app/core/enums/result_screen.dart';
import 'package:qr_code_app/core/services/contact_service.dart';
import 'package:qr_code_app/core/services/qr_image_service.dart';
import 'package:qr_code_app/core/services/wifi_settings_service.dart';
import 'package:qr_code_app/core/utils/qr_content_parser.dart';
import 'package:qr_code_app/core/widgets/back_widget.dart';
import 'package:qr_code_app/core/widgets/snackbar.dart';
import 'package:qr_code_app/features/qr_designer/presentation/cubit/qr_customization_cubit.dart';
import 'package:qr_code_app/features/qr_designer/presentation/cubit/qr_customization_state.dart';
import 'package:qr_code_app/features/qr_designer/presentation/screens/qr_design_edit_page.dart';
import 'package:qr_code_app/features/qr_designer/presentation/widgets/designer_qr_preview.dart';
import 'package:qr_code_app/features/qr_designer/presentation/widgets/result_action_buttons.dart';
import 'package:qr_code_app/features/root/presentation/screens/screens_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Displays a scanned, generated, shared, or history QR result.
class ResultPage extends StatefulWidget {
  /// Raw QR payload to render and describe.
  final String qrCode;

  /// Flow that opened the result page, used to choose navigation behavior.
  final FromScreenEnum fromScreen;

  /// Creates a result page for [qrCode].
  const ResultPage({
    super.key,
    required this.qrCode,
    required this.fromScreen,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  /// Wraps the live designed preview so exports capture exactly what's on screen.
  final GlobalKey _previewKey = GlobalKey();

  /// Holds this QR's design (loaded for [ResultPage.qrCode]); drives the preview.
  late final QrCustomizationCubit _designCubit;

  @override
  void initState() {
    super.initState();
    _designCubit = getIt<QrCustomizationCubit>()..start(code: widget.qrCode);
  }

  @override
  void dispose() {
    _designCubit.close();
    super.dispose();
  }

  /// Opens the full-screen editor and refreshes the preview if changes were saved.
  Future<void> _openEditor() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => QrDesignEditPage(
          code: widget.qrCode,
          data: widget.qrCode,
          initialConfig: _designCubit.state.config,
        ),
      ),
    );
    if (saved == true) {
      await _designCubit.load();
      if (mounted) showMessageSnackBar("Design saved successfully", context);
    }
  }

  /// Runs the result screen's primary action based on the QR content type.
  Future<void> _onPrimaryAction() async {
    final code = widget.qrCode;
    if (code.startsWith(RegExp(r'^WIFI:'))) {
      await WifiSettingsService.open(context, code);
    } else if (code.startsWith(RegExp(r'^https?://'))) {
      await launchUrl(Uri.parse(code));
    } else if (code.startsWith("BEGIN:VCARD") || code.startsWith("MECARD:")) {
      await ContactService.importFromQr(context, code);
    } else if (mounted) {
      Navigator.pop(context);
    }
  }

  /// Shares the raw QR text/link (separate from sharing the rendered image).
  Future<void> _shareText() async {
    final box = context.findRenderObject() as RenderBox?;
    final isUrl = RegExp(r'^(http|https)://').hasMatch(widget.qrCode);
    final origin = box!.localToGlobal(Offset.zero) & box.size;

    final params = isUrl
        ? ShareParams(
            uri: Uri.parse(widget.qrCode),
            title: "Share QR link",
            sharePositionOrigin: origin,
          )
        : ShareParams(
            text: widget.qrCode,
            title: "Share QR code",
            sharePositionOrigin: origin,
          );

    final result = await SharePlus.instance.share(params);
    if (result.status == ShareResultStatus.success) {
      showMessageSnackBar("Thanks for sharing!", context);
    }
  }

  void _onBack() {
    if (widget.fromScreen == FromScreenEnum.shared) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ScreensManager()),
      );
    } else {
      Navigator.pop(context);
      if (widget.fromScreen == FromScreenEnum.generated) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final actionLabel = QrContentParser.actionLabel(
      widget.qrCode,
      fromScreen: widget.fromScreen,
    );

    return PopScope(
      canPop: widget.fromScreen != FromScreenEnum.shared,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && widget.fromScreen == FromScreenEnum.shared) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ScreensManager()),
          );
        }
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: actionLabel == null
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: GestureDetector(
                    onTap: _onPrimaryAction,
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          actionLabel,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leadingWidth: 80,
          leading: BackWidget(onTap: _onBack),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Result",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: BlocBuilder<QrCustomizationCubit, QrCustomizationState>(
                  bloc: _designCubit,
                  buildWhen: (previous, current) => previous.config != current.config,
                  builder: (context, state) {
                    return FittedBox(
                      fit: BoxFit.scaleDown,
                      child: RepaintBoundary(
                        key: _previewKey,
                        child: DesignerQrPreview(
                          data: widget.qrCode,
                          config: state.config,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Gap(28),
              ResultActionButtons(
                onEdit: _openEditor,
                onDownload: () => QrImageService.saveToGallery(context, _previewKey),
                onShare: () => QrImageService.shareImage(context, _previewKey),
              ),
              const Gap(40),
              Divider(color: Colors.grey.shade600),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Information:",
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          FlutterClipboard.copy(widget.qrCode).then((_) {
                            showMessageSnackBar("Copied", context);
                          });
                        },
                        color: Colors.white,
                        icon: const Icon(Icons.copy, size: 20),
                      ),
                      IconButton(
                        onPressed: _shareText,
                        icon: const Icon(
                          Icons.share_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 350,
                child: Text(
                  QrContentParser.describe(widget.qrCode),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
