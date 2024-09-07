import 'package:qr_code_scanner_app/data/models/generate_qr/gen_qr_model.dart';

class EventQRCode extends GenQrModel{
  final String eventName;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String location;
  final String description;

  EventQRCode({
    required this.eventName,
    required this.startDateTime,
    required this.endDateTime,
    required this.location,
    required this.description,
  }) : super("event");

  @override
  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'location': location,
      'description': description,
    };
  }

  factory EventQRCode.fromMap(Map<String, dynamic> map) {
    return EventQRCode(
      eventName: map['eventName'] ?? '',
      startDateTime: DateTime.parse(map['startDateTime']),
      endDateTime: DateTime.parse(map['endDateTime']),
      location: map['location'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
