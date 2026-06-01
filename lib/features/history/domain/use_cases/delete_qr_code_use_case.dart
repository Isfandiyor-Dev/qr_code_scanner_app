import 'package:qr_code_scanner_app/features/history/domain/repositories/history_repository.dart';

/// Use case that deletes a QR history entry.
class DeleteQrCodeUseCase {
  /// Repository used to delete history rows.
  final IHistoryRepository historyRepository;

  /// Creates the delete-history use case.
  DeleteQrCodeUseCase({required this.historyRepository});

  /// Deletes the history row identified by [params].
  Future<int> call(int params) async {
    return await historyRepository.deleteQrCode(params);
  }
}
