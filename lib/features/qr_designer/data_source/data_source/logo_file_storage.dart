import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Persists user-picked logo files (gallery images / SVGs) into a stable
/// location the app fully controls.
///
/// `image_picker` and `file_picker` hand back temporary/cache paths that the OS
/// may purge, so a saved design would lose its logo after a restart. This copies
/// the chosen file into `<app documents>/qr_logos/<uuid><ext>` and returns that
/// durable path, cleaning up any previously stored logo.
class LogoFileStorage {
  static const _folder = 'qr_logos';
  final _uuid = const Uuid();

  Future<Directory> _logosDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, _folder));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Copies [sourcePath] into app storage and returns the new durable path.
  ///
  /// If [previousPath] points at a file we previously stored, it is removed so
  /// orphaned logos don't accumulate.
  Future<String> persist(String sourcePath, {String? previousPath}) async {
    final dir = await _logosDir();
    final ext = p.extension(sourcePath);
    final destination = p.join(dir.path, '${_uuid.v4()}$ext');

    await File(sourcePath).copy(destination);
    if (previousPath != null && previousPath != destination) {
      await delete(previousPath);
    }
    return destination;
  }

  /// Deletes a previously stored logo file if it still exists. Safe to call with
  /// a null or already-removed path.
  Future<void> delete(String? path) async {
    if (path == null) return;
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Best-effort cleanup: a missing or locked file must never crash a save.
    }
  }
}
