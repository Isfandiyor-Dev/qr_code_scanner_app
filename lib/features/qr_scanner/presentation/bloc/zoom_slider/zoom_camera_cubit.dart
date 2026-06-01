import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Controls scanner zoom as a percentage value.
class ZoomCameraCubit extends Cubit<double> {
  /// Mobile scanner controller that receives zoom scale updates.
  final MobileScannerController controller;

  /// Creates a zoom cubit bound to [controller].
  ZoomCameraCubit(this.controller) : super(0);

  /// Increases zoom in five-percent steps.
  void increment() {
    if (state <= 95) {
      final newZoom = state + 5;
      emit(newZoom);
      controller.setZoomScale(newZoom / 100);
    }
  }

  /// Decreases zoom in five-percent steps.
  void decrement() {
    if (state >= 5) {
      final newZoom = state - 5;
      emit(newZoom);
      controller.setZoomScale(newZoom / 100);
    }
  }

  /// Sets zoom to an exact percentage value.
  void setZoom(double zoom) {
    emit(zoom);
    controller.setZoomScale(zoom / 100);
  }
}
