class QrCodeModel {
  int id;
  String code;
  DateTime scannedAt;
  bool isGenerated;

  QrCodeModel({
    required this.id,
    required this.code,
    required this.scannedAt,
    required this.isGenerated,
  });

  // JSON dan obyekt yaratish
  factory QrCodeModel.fromJson(Map<String, dynamic> json) {
    return QrCodeModel(
        id: json['id'] as int,
        code: json['code'] as String,
        scannedAt: DateTime.parse(json['scannedAt'] as String),
        isGenerated: (json['isGenerated']) == 1);
  }
}
