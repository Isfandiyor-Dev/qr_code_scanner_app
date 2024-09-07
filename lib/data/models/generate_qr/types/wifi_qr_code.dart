
import 'package:qr_code_scanner_app/data/models/generate_qr/gen_qr_model.dart';

class WiFiQRCode extends GenQrModel {
  final String network;
  final String password;

  WiFiQRCode({required this.network, required this.password}) : super("wifi");

  @override
  Map<String, dynamic> toMap() {
    return {
      'network': network,
      'password': password,
    };
  }

  factory WiFiQRCode.fromMap(Map<String, dynamic> map) {
    return WiFiQRCode(
      network: map['network'] ?? '',
      password: map['password'] ?? '',
    );
  }
}
