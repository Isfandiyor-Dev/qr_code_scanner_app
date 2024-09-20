// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner_app/blocs/camera_cubit/camera_control_cubit.dart';
import 'package:qr_code_scanner_app/blocs/camera_cubit/camera_control_state.dart';
import 'package:qr_code_scanner_app/blocs/history/history_bloc.dart';
import 'package:qr_code_scanner_app/blocs/history/history_event.dart';
import 'package:qr_code_scanner_app/blocs/size_scanner/overlay_cubit.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/scanner/result_page/result_page.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/scanner/widgets/zoom_slider.dart';
import 'package:qr_code_scanner_app/utils/di.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final ImagePicker _picker = ImagePicker();
  final controller = getIt.get<MobileScannerController>();

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _scanImage() async {
    XFile? pikedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pikedImage != null) {
      final result = await controller.analyzeImage(pikedImage.path);
      if (result != null && result.barcodes.length == 1) {
        controller.stop();
        String code = result.barcodes.first.rawValue!;
        BlocProvider.of<HistoryBloc>(context).add(
          AddHistoryEvent(code: code, isGenerated: false),
        );
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => ResultPage(
              qrCode: code,
            ),
          ),
        );
        controller.start();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CameraControlCubit(controller),
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<OverlayCubit, double>(builder: (context, state) {
              return MobileScanner(
                overlayBuilder: (context, constraints) {
                  return GestureDetector(
                    onPanUpdate: (details) {
                      context.read<OverlayCubit>().onPanUpdate(
                            details: details,
                            context: context,
                          );
                    },
                    child: QRScannerOverlay(
                      overlayColor: Colors.black.withOpacity(0.2),
                      borderRadius: 15,
                      borderColor: Colors.amber,
                      scanAreaHeight: state,
                      scanAreaWidth: state,
                    ),
                  );
                },
                controller: controller,
                scanWindow: Rect.fromCenter(
                  center: MediaQuery.of(context).size.center(Offset.zero),
                  width: state,
                  height: state,
                ),
                onDetect: (barcode) async {
                  if (barcode.barcodes.length == 1) {
                    controller.stop();
                    String code = barcode.barcodes.first.rawValue!;
                    BlocProvider.of<HistoryBloc>(context).add(
                      AddHistoryEvent(code: code, isGenerated: false),
                    );
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => ResultPage(
                          qrCode: code,
                        ),
                      ),
                    );
                    controller.start();
                  }
                },
              );
            }),
            Align(
              alignment: const Alignment(0, -0.82),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: const Color(0xff333333),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff333333).withOpacity(0.6),
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
                            context.read<CameraControlCubit>().toggleTorch();
                          },
                          icon: Icon(
                            Icons.flash_on_rounded,
                            color:
                                state.isTorchOn ? Colors.amber : Colors.white,
                          ),
                        );
                      },
                    ),
                    BlocBuilder<CameraControlCubit, CameraControlState>(
                      builder: (context, state) {
                        return IconButton(
                          onPressed: () {
                            context.read<CameraControlCubit>().switchCamera();
                          },
                          icon: Icon(
                            CupertinoIcons.camera_rotate_fill,
                            color: state.isMainCamera
                                ? Colors.white
                                : Colors.amber,
                          ),
                        );
                      },
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
