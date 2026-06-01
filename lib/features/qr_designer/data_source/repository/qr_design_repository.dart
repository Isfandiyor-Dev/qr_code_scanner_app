import 'dart:convert';

import '../../domain/repositories/qr_design_repository.dart';
import '../data_source/logo_file_storage.dart';
import '../data_source/qr_design_data_source.dart';
import '../models/qr_design_config.dart';

/// Default [IQrDesignRepository] backed by sqflite ([QrDesignDataSource]) for the
/// per-QR + default config blobs and [LogoFileStorage] for durable logo files.
class QrDesignRepositoryImpl implements IQrDesignRepository {
  final QrDesignDataSource _dataSource;
  final LogoFileStorage _logoStorage;

  /// Creates a QR design repository using local persistence and logo storage.
  QrDesignRepositoryImpl({
    required QrDesignDataSource dataSource,
    required LogoFileStorage logoStorage,
  })  : _dataSource = dataSource,
        _logoStorage = logoStorage;

  /// Loads the saved design for [code], falling back to the global default.
  @override
  Future<QrDesignConfig> loadForCode(String code) async {
    final raw = await _dataSource.getConfigForCode(code);
    final decoded = _decode(raw);
    if (decoded != null) return decoded;
    // No per-QR design yet, so start from the global default.
    return loadDefault();
  }

  /// Persists [config] for a specific QR [code].
  @override
  Future<void> saveForCode(String code, QrDesignConfig config) async {
    await _dataSource.saveConfigForCode(code, jsonEncode(config.toJson()));
  }

  /// Deletes the design saved for [code].
  @override
  Future<void> deleteForCode(String code) =>
      _dataSource.deleteConfigForCode(code);

  /// Loads the global default design.
  @override
  Future<QrDesignConfig> loadDefault() async {
    final raw = await _dataSource.getDefaultConfig();
    return _decode(raw) ?? QrDesignConfig.defaults();
  }

  /// Persists [config] as the global default design.
  @override
  Future<void> saveDefault(QrDesignConfig config) async {
    await _dataSource.saveDefaultConfig(jsonEncode(config.toJson()));
  }

  /// Copies a picked logo file into durable app storage.
  @override
  Future<String> persistLogoFile(String sourcePath, {String? previousPath}) {
    return _logoStorage.persist(sourcePath, previousPath: previousPath);
  }

  /// Deletes a stored logo file when present.
  @override
  Future<void> deleteLogoFile(String? path) => _logoStorage.delete(path);

  /// Decodes a stored JSON blob into a config, tolerating corrupt/legacy data.
  QrDesignConfig? _decode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return QrDesignConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
