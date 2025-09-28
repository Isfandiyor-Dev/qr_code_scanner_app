import 'package:qr_code_scanner_app/features/history/domain/repositories/history_repository.dart';

import '../../data_source/models/scan_qr/scan_qr_request.dart';

class AddQrCodeUseCase {
  final IHistoryRepository historyRepository;
  AddQrCodeUseCase({required this.historyRepository});

  Future<int> call(QrCodeRequest params) async {
    return await historyRepository.addQrCode(params);
  }
}
