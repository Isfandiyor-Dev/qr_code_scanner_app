/// Camera controls state for the scanner screen.
class CameraControlState {
  /// Whether the torch is currently enabled.
  final bool isTorchOn;

  /// Whether the rear/main camera is selected.
  final bool isMainCamera;

  /// Creates camera control state.
  CameraControlState({this.isTorchOn = false, this.isMainCamera = true});

  /// Returns a copy of this state with selected values changed.
  CameraControlState copyWith({bool? isTorchOn, bool? isMainCamera}) {
    return CameraControlState(
      isTorchOn: isTorchOn ?? this.isTorchOn,
      isMainCamera: isMainCamera ?? this.isMainCamera,
    );
  }
}
