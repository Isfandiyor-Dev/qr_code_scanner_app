import '../../data_source/models/qr_design_config.dart';
import '../repositories/qr_design_repository.dart';

/// Persists the design [config] for a specific QR [code].
class SaveQrDesignUseCase {
  final IQrDesignRepository repository;

  SaveQrDesignUseCase({required this.repository});

  /// Saves [config] for the QR identified by [code].
  Future<void> call(String code, QrDesignConfig config) =>
      repository.saveForCode(code, config);
}
