import 'package:qr_code_scanner_app/core/di/di.dart';
import 'package:qr_code_scanner_app/features/permissions/domain/use_cases/check_camera_permission_use_case.dart';
import 'package:qr_code_scanner_app/features/permissions/domain/use_cases/check_storage_permission_use_case.dart';
import 'package:qr_code_scanner_app/features/permissions/presentation/bloc/permission_bloc.dart';

import 'data_source/repositories/permission_repository_impl.dart';
import 'domain/repositories/permission_repository.dart';
import 'domain/use_cases/request_camera_permission_use_case.dart';
import 'domain/use_cases/request_storage_permission_use_case.dart';

void setUpPermission() {
  // Permission Repository
  getIt.registerLazySingleton<PermissionRepository>(
      () => PermissionRepositoryImpl());

  // Use Cases
  getIt.registerLazySingleton(() => RequestCameraPermissionUseCase(getIt()));
  getIt.registerLazySingleton(() => RequestStoragePermissionUseCase(getIt()));
  getIt.registerLazySingleton(() => CheckCameraPermissionUseCase(getIt()));
  getIt.registerLazySingleton(() => CheckStoragePermissionUseCase(getIt()));

  // View Models
  getIt.registerLazySingleton(
    () => PermissionBloc(
      checkCameraUseCase: getIt(),
      checkStorageUseCase: getIt(),
      requestCameraUseCase: getIt(),
      requestStorageUseCase: getIt(),
    ),
  );
}
