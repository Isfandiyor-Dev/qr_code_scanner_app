import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrImageViewWidget extends StatelessWidget {
  final String message;
  const QrImageViewWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: message,
      version: QrVersions.auto,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Color(0xff128760),
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Color(0xff1a5441),
      ),
      embeddedImage:
          const AssetImage('assets/images/4.0x/logo_yakka_transparent.png'),
      embeddedImageStyle: const QrEmbeddedImageStyle(
        size: Size.square(40),
        color: Colors.white,
      ),
    );
  }
}
