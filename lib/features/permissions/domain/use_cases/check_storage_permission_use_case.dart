import '../repositories/permission_repository.dart';

class CheckStoragePermissionUseCase {
  final PermissionRepository permissionRepository;

  CheckStoragePermissionUseCase(this.permissionRepository);

  Future<bool> execute() async {
    return await permissionRepository.checkStoragePermission();
  }
}
