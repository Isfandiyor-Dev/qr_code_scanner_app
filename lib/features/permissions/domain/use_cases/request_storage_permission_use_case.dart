import '../repositories/permission_repository.dart';

class RequestStoragePermissionUseCase {
  final PermissionRepository permissionRepository;

  RequestStoragePermissionUseCase(this.permissionRepository);

  Future<bool> execute() async {
    return await permissionRepository.requestStoragePermission();
  }
}
