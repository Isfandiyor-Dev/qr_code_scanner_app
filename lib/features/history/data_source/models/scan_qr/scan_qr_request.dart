/// Data transfer object used when inserting QR history rows.
class QrCodeRequest {
  /// Raw QR payload.
  String code;

  /// ISO-8601 timestamp string for the history row.
  String scannedAt;

  /// Integer flag stored in sqflite (`1` generated, `0` scanned).
  int isGenerated;

  /// Creates a request for inserting a QR history row.
  QrCodeRequest({
    required this.code,
    required this.scannedAt,
    required this.isGenerated,
  });

  /// Converts this request to a database insert map.
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'scannedAt': scannedAt,
      'isGenerated': isGenerated,
    };
  }
}
