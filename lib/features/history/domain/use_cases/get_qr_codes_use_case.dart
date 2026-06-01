import 'package:qr_code_scanner_app/features/history/data_source/models/scan_qr/scan_qr_model.dart';
import 'package:qr_code_scanner_app/features/history/domain/repositories/history_repository.dart';

/// Use case that loads all QR history entries.
class GetQrCodesUseCase {
  /// Repository used to read history.
  final IHistoryRepository historyRepository;

  /// Creates the history loading use case.
  GetQrCodesUseCase({required this.historyRepository});

  /// Returns all stored QR codes.
  Future<List<QrCodeModel>> call() async {
    return await historyRepository.getQrCodes();
  }
}
