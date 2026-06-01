import '../../data_source/models/qr_design_config.dart';
import '../repositories/qr_design_repository.dart';

/// Loads the design saved for a given QR [code] (or the global default / app
/// defaults when none exists).
class LoadQrDesignUseCase {
  final IQrDesignRepository repository;

  LoadQrDesignUseCase({required this.repository});

  /// Loads the design associated with [code].
  Future<QrDesignConfig> call(String code) => repository.loadForCode(code);
}
