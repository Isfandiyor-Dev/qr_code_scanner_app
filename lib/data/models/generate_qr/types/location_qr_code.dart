import 'package:qr_code_scanner_app/data/models/generate_qr/gen_qr_model.dart';

class LocationQrCode extends GenQrModel {
  final String locationName;
  final double latitude;
  final double longitude;

  LocationQrCode({
    required this.locationName,
    required this.latitude,
    required this.longitude,
  }): super("location");

  @override
  Map<String, dynamic> toMap() {
    return {
      'locationName': locationName,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory LocationQrCode.fromMap(Map<String, dynamic> map) {
    return LocationQrCode(
      locationName: map['locationName'] ?? '',
      longitude: map['longitude'] ?? '',
      latitude: map['latitude'] ?? '',
    );
  }
}
