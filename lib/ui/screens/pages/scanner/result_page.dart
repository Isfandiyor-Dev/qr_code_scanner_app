import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/ui/widgets/image_view_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultPage extends StatelessWidget {
  final String qrCode;
  const ResultPage({super.key, required this.qrCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: InkWell(
          onTap: () {
            launchUrl(Uri.parse(qrCode));
          },
          child: Ink(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                "Go to site",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Result",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                height: 2,
              ),
            ),
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: QrImageViewWidget(message: qrCode),
              ),
            ),
            const Text(
              "Information about the site:",
              style: TextStyle(
                fontSize: 15,
                height: 5,
              ),
            ),
            SizedBox(
              width: 350,
              child: Text(
                qrCode,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    FlutterClipboard.copy(qrCode).then((_) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            "Url copied",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.grey.withOpacity(0.5),
                          padding: const EdgeInsets.all(15),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        snackBarAnimationStyle: AnimationStyle(
                          curve: Curves.bounceIn,
                          reverseCurve: Curves.bounceOut,
                          duration: const Duration(milliseconds: 200),
                          reverseDuration: const Duration(milliseconds: 200),
                        ),
                      );
                    });
                  },
                  icon: const Icon(Icons.copy),
                ),
                const SizedBox(width: 30),
                IconButton(
                  onPressed: () async {
                    final urlPattern = RegExp(r'^(http|https)://');
                    if (urlPattern.hasMatch(qrCode)) {
                      await Share.shareUri(Uri.parse(qrCode));
                    } else {
                      await Share.share(qrCode);
                    }
                  },
                  icon: const Icon(
                    Icons.share_rounded,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
