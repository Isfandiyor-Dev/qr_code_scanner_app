import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ZoomCameraCubit extends Cubit<double> {
  final MobileScannerController controller;

  ZoomCameraCubit(this.controller) : super(0);

  void increment() {
    if (state <= 95) {
      print("State before +: $state");
      final newZoom = state + 5;
      emit(newZoom);
      print("New State after +: $state");
      controller.setZoomScale(newZoom / 100);
    }
  }

  void decrement() {
    if (state >= 5) {
      print("State before -: $state");
      final newZoom = state - 5;
      emit(newZoom);
      print("New State after -: $state");
      controller.setZoomScale(newZoom / 100);
    }
  }

  void setZoom(double zoom) {
    emit(zoom);
    controller.setZoomScale(zoom / 100);
  }
}
