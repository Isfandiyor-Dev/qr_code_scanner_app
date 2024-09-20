import 'package:bloc/bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner_app/blocs/camera_cubit/camera_control_state.dart';

class CameraControlCubit extends Cubit<CameraControlState> {
  final MobileScannerController controller;

  CameraControlCubit(this.controller) : super(CameraControlState());

  void toggleTorch() {
    if (state.isMainCamera) {
      controller.toggleTorch();
      emit(state.copyWith(isTorchOn: !state.isTorchOn));
    }
  }

  void switchCamera() {
    controller.switchCamera();
    emit(state.copyWith(isMainCamera: !state.isMainCamera));

    if (!state.isMainCamera) {
      controller.toggleTorch();
      emit(state.copyWith(isTorchOn: false));
    }
  }
}
