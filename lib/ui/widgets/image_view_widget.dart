import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrImageViewWidget extends StatelessWidget {
  final String message;
  const QrImageViewWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.amber, width: 4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: QrImageView(
        data: message,
        version: QrVersions.auto,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Colors.black,
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Colors.black,
        ),
        embeddedImage:
            const AssetImage('assets/images/4.0x/logo_yakka_transparent.png'),
        embeddedImageStyle: const QrEmbeddedImageStyle(
          size: Size.square(40),
          color: Colors.black,
        ),
      ),
    );
  }
}
