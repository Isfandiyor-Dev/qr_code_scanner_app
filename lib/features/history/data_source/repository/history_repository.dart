import 'package:qr_code_app/features/history/data_source/models/scan_qr/scan_qr_model.dart';
import 'package:qr_code_app/features/history/data_source/data_source/history_data_source.dart';
import 'package:qr_code_app/features/history/domain/repositories/history_repository.dart';
import '../models/scan_qr/scan_qr_request.dart';

/// Default [IHistoryRepository] implementation backed by [HistoryDataSource].
class HistoryRepositoryImpl implements IHistoryRepository {
  final HistoryDataSource _historyDataSource;

  /// Creates a repository that reads and writes QR history.
  HistoryRepositoryImpl({
    required HistoryDataSource historyDataSource,
  }) : _historyDataSource = historyDataSource;

  /// Returns all QR history entries as domain-ready models.
  @override
  Future<List<QrCodeModel>> getQrCodes() async {
    List<Map<String, dynamic>> data = await _historyDataSource.getQrCodes();
    return data.map((element) {
      return QrCodeModel.fromJson(element);
    }).toList();
  }

  /// Adds a scanned or generated QR code to history.
  @override
  Future<int> addQrCode(QrCodeRequest data) async {
    return await _historyDataSource.insertQrCode(data);
  }

  /// Deletes a QR code history entry by [id].
  @override
  Future<int> deleteQrCode(int id) async {
    return await _historyDataSource.deleteQrCode(id);
  }
}
