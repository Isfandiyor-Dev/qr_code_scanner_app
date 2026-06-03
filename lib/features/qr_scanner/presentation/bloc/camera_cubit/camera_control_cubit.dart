import 'package:bloc/bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_app/features/qr_scanner/presentation/bloc/camera_cubit/camera_control_state.dart';

/// Controls camera-facing state for the scanner screen.
class CameraControlCubit extends Cubit<CameraControlState> {
  /// Mobile scanner controller that performs torch and camera operations.
  final MobileScannerController controller;

  /// Creates a cubit bound to a [MobileScannerController].
  CameraControlCubit(this.controller) : super(CameraControlState());

  /// Toggles the torch when the rear camera is active.
  void toggleTorch() {
    if (state.isMainCamera) {
      controller.toggleTorch();
      emit(state.copyWith(isTorchOn: !state.isTorchOn));
    }
  }

  /// Switches between front and rear cameras.
  void switchCamera() {
    controller.switchCamera();
    emit(state.copyWith(isMainCamera: !state.isMainCamera));

    if (!state.isMainCamera) {
      controller.toggleTorch();
      emit(state.copyWith(isTorchOn: false));
    }
  }

  /// Marks the torch as off after scanner lifecycle changes.
  void resetTorchState() {
    emit(state.copyWith(isTorchOn: false));
  }
}
