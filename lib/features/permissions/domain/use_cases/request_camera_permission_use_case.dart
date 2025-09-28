import '../repositories/permission_repository.dart';

class RequestCameraPermissionUseCase {
  final PermissionRepository permissionRepository;

  RequestCameraPermissionUseCase(this.permissionRepository);

  Future<bool> execute() async {
    return await permissionRepository.requestCameraPermission();
  }
}
