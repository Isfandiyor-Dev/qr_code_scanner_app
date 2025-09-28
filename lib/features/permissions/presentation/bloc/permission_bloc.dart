// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/check_camera_permission_use_case.dart';
import '../../domain/use_cases/check_storage_permission_use_case.dart';
import '../../domain/use_cases/request_camera_permission_use_case.dart';
import '../../domain/use_cases/request_storage_permission_use_case.dart';

part 'permission_event.dart';
part 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  final CheckCameraPermissionUseCase checkCameraUseCase;
  final CheckStoragePermissionUseCase checkStorageUseCase;
  final RequestCameraPermissionUseCase requestCameraUseCase;
  final RequestStoragePermissionUseCase requestStorageUseCase;

  PermissionBloc({
    required this.checkCameraUseCase,
    required this.checkStorageUseCase,
    required this.requestCameraUseCase,
    required this.requestStorageUseCase,
  }) : super(PermissionState()) {
    on<CheckCameraEvent>(_checkCamera);
    on<CheckStorageEvent>(_checkStorage);
    on<RequestCameraEvent>(_requestCamera);
    on<RequestStorageEvent>(_requestStorage);
  }

  Future<void> _handlePermissionEvent<T>(
      Future<bool> Function() useCase,
      ValueChanged<bool> result,
      Emitter emit,
      T Function(PermissionState state, bool isGranted) stateUpdater) async {
    try {
      final isGranted = await useCase();
      emit(stateUpdater(state, isGranted));
      result(isGranted);
    } catch (_) {
      emit(stateUpdater(state, false));
      result(false);
    }
  }

  Future<void> _checkCamera(CheckCameraEvent event, Emitter emit) async {
    await _handlePermissionEvent(
      checkCameraUseCase.execute,
      event.result,
      emit,
      (state, isGranted) => state.copyWith(isGrantedCamera: isGranted),
    );
  }

  Future<void> _checkStorage(CheckStorageEvent event, Emitter emit) async {
    await _handlePermissionEvent(
      checkStorageUseCase.execute,
      event.result,
      emit,
      (state, isGranted) => state.copyWith(isGrantedStorage: isGranted),
    );
  }

  Future<void> _requestCamera(RequestCameraEvent event, Emitter emit) async {
    await _handlePermissionEvent(
      requestCameraUseCase.execute,
      event.result,
      emit,
      (state, isGranted) => state.copyWith(isGrantedCamera: isGranted),
    );
  }

  Future<void> _requestStorage(RequestStorageEvent event, Emitter emit) async {
    await _handlePermissionEvent(
      requestStorageUseCase.execute,
      event.result,
      emit,
      (state, isGranted) => state.copyWith(isGrantedStorage: isGranted),
    );
  }
}
