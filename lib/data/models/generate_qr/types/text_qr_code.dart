import 'package:qr_code_scanner_app/data/models/generate_qr/gen_qr_model.dart';

class TextQRCode extends GenQrModel{
 
  final String text;

  TextQRCode({required this.text}) : super("text");

  @override
  Map<String, dynamic> toMap() {
    return {
      'text': text,
    };
  }

  factory TextQRCode.fromMap(Map<String, dynamic> map) {
    return TextQRCode(
      text: map['text'] ?? '',
    );
  }
}