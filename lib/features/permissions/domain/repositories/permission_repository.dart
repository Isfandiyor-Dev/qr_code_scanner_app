abstract class PermissionRepository {
  Future<bool> requestCameraPermission();
  Future<bool> requestStoragePermission();
  Future<bool> checkCameraPermission();
  Future<bool> checkStoragePermission();
}
