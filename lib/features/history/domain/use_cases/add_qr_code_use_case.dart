import 'package:qr_code_app/features/history/domain/repositories/history_repository.dart';

import '../../data_source/models/scan_qr/scan_qr_request.dart';

/// Use case that stores a scanned or generated QR code in history.
class AddQrCodeUseCase {
  /// Repository used to persist history.
  final IHistoryRepository historyRepository;

  /// Creates the add-history use case.
  AddQrCodeUseCase({required this.historyRepository});

  /// Adds [params] to history and returns the affected row count/id.
  Future<int> call(QrCodeRequest params) async {
    return await historyRepository.addQrCode(params);
  }
}
