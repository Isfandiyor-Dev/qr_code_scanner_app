import 'package:qr_code_scanner_app/features/history/domain/repositories/history_repository.dart';

class DeleteQrCodeUseCase {
  final IHistoryRepository historyRepository;
  DeleteQrCodeUseCase({required this.historyRepository});

  Future<int> call(int params) async {
    return await historyRepository.deleteQrCode(params);
  }
}
