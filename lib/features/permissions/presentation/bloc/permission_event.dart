part of 'permission_bloc.dart';

class PermissionEvent {}

class CheckCameraEvent extends PermissionEvent {
  final ValueChanged<bool> result;
  CheckCameraEvent({
    required this.result,
  });
}

class CheckStorageEvent extends PermissionEvent {
  final ValueChanged<bool> result;
  CheckStorageEvent({
    required this.result,
  });
}

class RequestCameraEvent extends PermissionEvent {
  final ValueChanged<bool> result;
  RequestCameraEvent({
    required this.result,
  });
}

class RequestStorageEvent extends PermissionEvent {
  final ValueChanged<bool> result;
  RequestStorageEvent({
    required this.result,
  });
}
