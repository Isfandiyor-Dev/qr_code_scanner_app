import 'package:permission_handler/permission_handler.dart';
import '../../domain/repositories/permission_repository.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  @override
  Future<bool> requestCameraPermission() async {
    if (await Permission.camera.isGranted) {
      return true;
    }

    final status = await Permission.camera.request();
    return status.isGranted; 
  }

  @override
  Future<bool> requestStoragePermission() async {
    if (await Permission.storage.isGranted) {
      return true;
    }

    final status = await Permission.storage.request();
    return status.isGranted;
  }

  @override
  Future<bool> checkCameraPermission() async {
    return await Permission.camera.isGranted;
  }

  @override
  Future<bool> checkStoragePermission() async {
    return await Permission.storage.isGranted;
  }
}
