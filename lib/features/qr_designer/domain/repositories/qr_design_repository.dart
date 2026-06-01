import '../../data_source/models/qr_design_config.dart';

/// Contract for loading/saving **per-QR** design configurations plus the global
/// default, and for durably storing picked logo files.
abstract interface class IQrDesignRepository {
  /// Returns the design saved for [code]; if none, the global default; if that
  /// is also unset, [QrDesignConfig.defaults].
  Future<QrDesignConfig> loadForCode(String code);

  /// Persists [config] as the design for [code].
  Future<void> saveForCode(String code, QrDesignConfig config);

  /// Removes the saved design for [code].
  Future<void> deleteForCode(String code);

  /// Returns the global default design (or [QrDesignConfig.defaults]).
  Future<QrDesignConfig> loadDefault();

  /// Persists [config] as the global default applied to new QR codes.
  Future<void> saveDefault(QrDesignConfig config);

  /// Copies a picked logo file into durable app storage, returning its path.
  Future<String> persistLogoFile(String sourcePath, {String? previousPath});

  /// Removes a stored logo file (best-effort).
  Future<void> deleteLogoFile(String? path);
}
