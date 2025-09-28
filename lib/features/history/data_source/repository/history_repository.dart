import 'package:qr_code_scanner_app/features/history/data_source/models/scan_qr/scan_qr_model.dart';
import 'package:qr_code_scanner_app/features/history/data_source/data_source/history_data_source.dart';
import 'package:qr_code_scanner_app/features/history/domain/repositories/history_repository.dart';
import '../models/scan_qr/scan_qr_request.dart';

class HistoryRepositoryImpl implements IHistoryRepository {
  final HistoryDataSource _historyDataSource;

  HistoryRepositoryImpl({
    required HistoryDataSource historyDataSource,
  }) : _historyDataSource = historyDataSource;

  @override
  Future<List<QrCodeModel>> getQrCodes() async {
    List<Map<String, dynamic>> data = await _historyDataSource.getQrCodes();
    return data.map((element) {
      return QrCodeModel.fromJson(element);
    }).toList();
  }

  @override
  Future<int> addQrCode(QrCodeRequest data) async {
    return await _historyDataSource.insertQrCode(data);
  }

  @override
  Future<int> deleteQrCode(int id) async {
    return await _historyDataSource.deleteQrCode(id);
  }
}
