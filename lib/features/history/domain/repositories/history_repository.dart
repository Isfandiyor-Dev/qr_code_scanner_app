import '../../data_source/models/scan_qr/scan_qr_model.dart';
import '../../data_source/models/scan_qr/scan_qr_request.dart';

/// Contract for QR history persistence.
abstract interface class IHistoryRepository {
  /// Returns all QR history entries.
  Future<List<QrCodeModel>> getQrCodes();

  /// Adds or updates a QR history entry.
  Future<int> addQrCode(QrCodeRequest data);

  /// Deletes a QR history entry by [id].
  Future<int> deleteQrCode(int id);
}
