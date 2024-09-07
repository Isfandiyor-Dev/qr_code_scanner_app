import 'package:qr_code_scanner_app/data/models/generate_qr/gen_qr_model.dart';

class WebsiteQRCode extends GenQrModel {
  final String url;

  WebsiteQRCode({required this.url}) : super("website");

  @override
  Map<String, dynamic> toMap() {
    return {
      'url': url,
    };
  }

  factory WebsiteQRCode.fromMap(Map<String, dynamic> map) {
    return WebsiteQRCode(
      url: map['url'] ?? '',
    );
  }
}
