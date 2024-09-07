import 'package:qr_code_scanner_app/data/models/generate_qr/gen_qr_model.dart';

class PhoneQRCode extends GenQrModel {
  final String phoneNumber;

  PhoneQRCode({required this.phoneNumber}): super("phone");

  @override
  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
    };
  }

  factory PhoneQRCode.fromMap(Map<String, dynamic> map) {
    return PhoneQRCode(
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
}
