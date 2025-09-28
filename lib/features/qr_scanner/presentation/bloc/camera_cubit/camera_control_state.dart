class CameraControlState {
  final bool isTorchOn;
  final bool isMainCamera;

  CameraControlState({this.isTorchOn = false, this.isMainCamera = true});

  CameraControlState copyWith({bool? isTorchOn, bool? isMainCamera}) {
    return CameraControlState(
      isTorchOn: isTorchOn ?? this.isTorchOn,
      isMainCamera: isMainCamera ?? this.isMainCamera,
    );
  }
}
