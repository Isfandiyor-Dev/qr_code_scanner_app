// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner_app/core/enums/result_screen.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_text_theme_extension.dart';
import 'package:qr_code_scanner_app/core/widgets/snackbar.dart';
import 'package:qr_code_scanner_app/features/qr_scanner/presentation/bloc/camera_cubit/camera_control_cubit.dart';
import 'package:qr_code_scanner_app/features/qr_scanner/presentation/bloc/camera_cubit/camera_control_state.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history/history_bloc.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history/history_event.dart';
import 'package:qr_code_scanner_app/features/qr_scanner/presentation/bloc/size_scanner/overlay_cubit.dart';
import 'package:qr_code_scanner_app/features/result_screen/presentation/result_page.dart';
import 'package:qr_code_scanner_app/features/qr_scanner/presentation/widgets/zoom_slider.dart';
import 'package:qr_code_scanner_app/core/di/di.dart';
import 'package:qr_code_scanner_app/core/services/scan_feedback_service.dart';
import 'package:qr_code_scanner_app/features/settings/presentation/screens/settings.dart';
import 'package:qr_code_scanner_app/gen/assets.gen.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

/// Camera-based QR scanner screen with gallery import and zoom controls.
class QrScannerPage extends StatefulWidget {
  /// Creates the scanner page.
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final ImagePicker _picker = ImagePicker();
  final controller = getIt.get<MobileScannerController>();

  late final CameraControlCubit _cameraCubit;

  @override
  void initState() {
    super.initState();
    _cameraCubit = CameraControlCubit(controller);
  }

  Future<void> _scanImage() async {
    try {
      XFile? pikedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pikedImage != null) {
        final result = await controller.analyzeImage(pikedImage.path);
        if (result != null && result.barcodes.length == 1) {
          controller.stop();
          getIt<ScanFeedbackService>().onScanSuccess();
          String code = result.barcodes.first.rawValue!;
          BlocProvider.of<HistoryBloc>(context).add(
            AddHistoryEvent(code: code, isGenerated: false),
          );
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => ResultPage(
                qrCode: code,
                fromScreen: FromScreenEnum.scanned,
              ),
            ),
          );
          controller.start();
        } else {
          throw "The image could not be scanned. Please make sure the image is clear and contains a valid QR code.";
        }
      }
    } catch (e) {
      showErrorSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cameraCubit,
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<OverlayCubit, double>(builder: (context, state) {
              return MobileScanner(
                controller: controller,
                scanWindow: Rect.fromCenter(
                  center: MediaQuery.of(context).size.center(Offset.zero),
                  width: state,
                  height: state,
                ),
                onDetect: (barcode) async {
                  if (barcode.barcodes.length == 1) {
                    controller.stop();

                    _cameraCubit.resetTorchState();

                    getIt<ScanFeedbackService>().onScanSuccess();

                    String code = barcode.barcodes.first.rawValue!;
                    BlocProvider.of<HistoryBloc>(context).add(
                      AddHistoryEvent(code: code, isGenerated: false),
                    );
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => ResultPage(
                          qrCode: code,
                          fromScreen: FromScreenEnum.scanned,
                        ),
                      ),
                    );
                    controller.start();
                  }
                },
              );
            }),
            BlocBuilder<OverlayCubit, double>(
              builder: (context, state) {
                return GestureDetector(
                  onPanUpdate: (details) {
                    context.read<OverlayCubit>().onPanUpdate(
                          details: details,
                          context: context,
                        );
                  },
                  child: QRScannerOverlay(
                    overlayColor: Colors.black.withValues(alpha: .2),
                    borderRadius: 15,
                    borderColor: context.colorScheme.primary,
                    scanAreaHeight: state,
                    scanAreaWidth: state,
                  ),
                );
              },
            ),
            Align(
              alignment: const Alignment(0, -0.82),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: context.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: context.colorScheme.secondary
                            .withValues(alpha: 0.6),
                        blurRadius: 10,
                      )
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _scanImage,
                      icon: const Icon(
                        CupertinoIcons.photo,
                        color: Colors.white,
                      ),
                    ),
                    BlocBuilder<CameraControlCubit, CameraControlState>(
                      builder: (context, state) {
                        return IconButton(
                          onPressed: () {
                            _cameraCubit.toggleTorch();
                          },
                          icon: Icon(
                            Icons.flash_on_rounded,
                            color: state.isTorchOn
                                ? context.colorScheme.primary
                                : Colors.white,
                          ),
                        );
                      },
                    ),
                    BlocBuilder<CameraControlCubit, CameraControlState>(
                      builder: (context, state) {
                        return IconButton(
                          onPressed: () {
                            _cameraCubit.switchCamera();
                          },
                          icon: Icon(
                            CupertinoIcons.camera_rotate_fill,
                            color: state.isMainCamera
                                ? Colors.white
                                : context.colorScheme.primary,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      icon: Assets.icons.settings.svg(
                        width: 22,
                        height: 22,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.75),
              child: SizedBox(
                height: 40,
                width: 350,
                child: MyZoomSlider(
                  controller: controller,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
