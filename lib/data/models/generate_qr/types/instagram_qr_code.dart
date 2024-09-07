import 'package:qr_code_scanner_app/data/models/generate_qr/gen_qr_model.dart';

class InstagramQRCode extends GenQrModel {
  final String username;

  InstagramQRCode({required this.username}): super("instagram");

  @override
  Map<String, dynamic> toMap() {
    return {
      'username': username,
    };
  }

  factory InstagramQRCode.fromMap(Map<String, dynamic> map) {
    return InstagramQRCode(
      username: map['username'] ?? '',
    );
  }
}
