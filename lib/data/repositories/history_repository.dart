import 'package:qr_code_scanner_app/data/models/scan_qr/scan_qr_model.dart';
import 'package:qr_code_scanner_app/services/history_service.dart';

class HistoryRepository {
  final HistoryService _historyService;

  HistoryRepository({
    required HistoryService historyService,
  }) : _historyService = historyService;

  Future<List<QrModel>> getQrCodes() async {
    List<Map<String, dynamic>> data = await _historyService.getQrCodes();
    return data.map((element) {
      return QrModel.fromJson(element);
    }).toList();
  }

  Future<int> addQrCode(Map<String, dynamic> data) async {
    return await _historyService.insertQrCode(data);
  }

  Future<int> deleteQrCode(int id) async {
    return await _historyService.deleteQrCode(id);
  }
}
