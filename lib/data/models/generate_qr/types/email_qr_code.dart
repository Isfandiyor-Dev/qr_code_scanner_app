import 'package:qr_code_scanner_app/data/models/generate_qr/gen_qr_model.dart';

class EmailQrCode extends GenQrModel {
  final String email;

  EmailQrCode({required this.email}): super("email");

  @override
  Map<String, dynamic> toMap() {
    return {
      'email': email,
    };
  }

  factory EmailQrCode.fromMap(Map<String, dynamic> map) {
    return EmailQrCode(
      email: map['email'] ?? '',
    );
  }
}
