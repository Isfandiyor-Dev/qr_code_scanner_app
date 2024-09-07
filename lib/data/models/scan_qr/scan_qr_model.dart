class ScanQrModel {
  int id;
  String code;
  DateTime scannetAt;

  ScanQrModel(
    this.id,
    this.code,
    this.scannetAt,
  );

  // JSON dan obyekt yaratish
  factory ScanQrModel.fromJson(Map<String, dynamic> json) {
    return ScanQrModel(
      json['id'] as int,
      json['code'] as String,
      DateTime.parse(json['scannetAt'] as String), // String to DateTime
    );
  }

  // Obyektdan JSON yaratish
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'scannetAt': scannetAt.toIso8601String(), // DateTime to String
    };
  }
}
