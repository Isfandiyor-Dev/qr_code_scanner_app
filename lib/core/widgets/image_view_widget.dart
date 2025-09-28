import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrImageViewWidget extends StatelessWidget {
  final String message;
  const QrImageViewWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.teal, width: 4),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: PrettyQrView.data(
        data: message,
        decoration: const PrettyQrDecoration(
          background: Colors.white,
          // image: PrettyQrDecorationImage(
          //   image: AssetImage("assets/icons/google.png"),
          //   filterQuality: FilterQuality.high,
          // ),
          shape: PrettyQrSmoothSymbol(
            roundFactor: 0.6,
          ),
        ),
      ),
    );
  }
}
