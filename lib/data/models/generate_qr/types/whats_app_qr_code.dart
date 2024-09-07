import 'package:qr_code_scanner_app/data/models/generate_qr/gen_qr_model.dart';

class WhatsAppQRCode extends GenQrModel {
  final String whatsappNumber;

  WhatsAppQRCode({required this.whatsappNumber}) : super("whatsapp");

  @override
  Map<String, dynamic> toMap() {
    return {
      'whatsappNumber': whatsappNumber,
    };
  }

  factory WhatsAppQRCode.fromMap(Map<String, dynamic> map) {
    return WhatsAppQRCode(
      whatsappNumber: map['whatsappNumber'] ?? '',
    );
  }
}
