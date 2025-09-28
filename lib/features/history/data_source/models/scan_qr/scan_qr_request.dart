class QrCodeRequest {
  String code;
  String scannedAt;
  int isGenerated;

  QrCodeRequest({
    required this.code,
    required this.scannedAt,
    required this.isGenerated,
  });

  // Obyektdan JSON yaratish
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'scannedAt': scannedAt,
      'isGenerated': isGenerated,
    };
  }
}