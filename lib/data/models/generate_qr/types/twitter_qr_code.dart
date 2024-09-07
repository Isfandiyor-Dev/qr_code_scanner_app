import 'package:qr_code_scanner_app/data/models/generate_qr/gen_qr_model.dart';

class TwitterQRCode extends GenQrModel {
  final String username;

  TwitterQRCode({required this.username}): super("twitter");

  @override
  Map<String, dynamic> toMap() {
    return {
      'username': username,
    };
  }

  factory TwitterQRCode.fromMap(Map<String, dynamic> map) {
    return TwitterQRCode(
      username: map['username'] ?? '',
    );
  }
}
