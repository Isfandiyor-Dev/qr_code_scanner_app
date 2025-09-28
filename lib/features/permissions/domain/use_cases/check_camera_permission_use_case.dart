import '../repositories/permission_repository.dart';

class CheckCameraPermissionUseCase {
  final PermissionRepository permissionRepository;

  CheckCameraPermissionUseCase(this.permissionRepository);

  Future<bool> execute() async {
    return await permissionRepository.checkCameraPermission();
  }
}
