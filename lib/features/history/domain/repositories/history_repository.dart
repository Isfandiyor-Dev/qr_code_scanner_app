import '../../data_source/models/scan_qr/scan_qr_model.dart';
import '../../data_source/models/scan_qr/scan_qr_request.dart';

abstract interface class IHistoryRepository {
  Future<List<QrCodeModel>> getQrCodes();
  Future<int> addQrCode(QrCodeRequest data);
  Future<int> deleteQrCode(int id);
}
