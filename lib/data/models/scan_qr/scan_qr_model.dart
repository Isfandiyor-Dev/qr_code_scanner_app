class QrModel {
  int id;
  String code;
  DateTime scannetAt;
  bool isGenerated;

  QrModel(this.id, this.code, this.scannetAt, this.isGenerated);

  // JSON dan obyekt yaratish
  factory QrModel.fromJson(Map<String, dynamic> json) {
    return QrModel(
        json['id'] as int,
        json['code'] as String,
        DateTime.parse(json['scannetAt'] as String),
        (json['isGenerated']) == 1);
  }

  // Obyektdan JSON yaratish
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'scannetAt': scannetAt.toIso8601String(),
      'isGenerated': isGenerated ? 1 : 0,
    };
  }
}
