import 'package:qr_code_scanner_app/features/history/data_source/models/scan_qr/scan_qr_model.dart';
import 'package:qr_code_scanner_app/features/history/domain/repositories/history_repository.dart';

class GetQrCodesUseCase {
  final IHistoryRepository historyRepository;
  GetQrCodesUseCase({required this.historyRepository});

  Future<List<QrCodeModel>> call() async {
    return await historyRepository.getQrCodes();
  }
}
