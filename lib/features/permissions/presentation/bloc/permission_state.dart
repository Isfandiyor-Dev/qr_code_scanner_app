// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'permission_bloc.dart';

class PermissionState {
  final bool isGrantedCamera;
  final bool isGrantedStorage;

  PermissionState({
    this.isGrantedCamera = false,
    this.isGrantedStorage = false,
  });

  PermissionState copyWith({
    bool? isGrantedCamera,
    bool? isGrantedStorage,
  }) {
    return PermissionState(
      isGrantedCamera: isGrantedCamera ?? this.isGrantedCamera,
      isGrantedStorage: isGrantedStorage ?? this.isGrantedStorage,
    );
  }
}
