// import 'package:uuid/uuid.dart';
// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_code_scanner_app/core/enum/result_screen.dart';
import 'package:qr_code_scanner_app/core/widgets/image_view_widget.dart';
import 'package:qr_code_scanner_app/core/widgets/snackbar.dart';
// import 'package:qr_code_scanner_app/features/permissions/presentation/bloc/permission_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class ResultPage extends StatefulWidget {
  final String qrCode;
  final FromScreenEnum fromScreen;

  const ResultPage({
    super.key,
    required this.qrCode,
    required this.fromScreen,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final uuid = const Uuid();

  String? getTextButton() {
    if (widget.qrCode.startsWith(RegExp(r'^WIFI:'))) {
      return "Go to WiFi settings";
    } else if (widget.qrCode.startsWith(RegExp(r'^https?://'))) {
      return "Go to site";
    } else if (widget.fromScreen == FromScreenEnum.generated) {
      return "Regenerate";
    } else if (widget.fromScreen == FromScreenEnum.scanned) {
      return "Scan again";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: getTextButton() != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: GestureDetector(
                  onTap: () {
                    if (widget.qrCode.startsWith(RegExp(r'^WIFI:'))) {
                      FlutterClipboard.copy(widget.qrCode);
                      if (Platform.isAndroid) {
                        openWifiSettingsAndroid(context);
                      } else if (Platform.isIOS) {
                        _openWiFiSettingsIOS(context);
                      } else {
                        showMessageSnackBar(
                          "This platform is not supported!",
                          context,
                        );
                      }
                    } else if (widget.qrCode
                        .startsWith(RegExp(r'^https?://'))) {
                      launchUrl(Uri.parse(widget.qrCode));
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        getTextButton()!,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 80,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Center(
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.yellow,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Result",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                IconButton(
                  onPressed: () => saveQrToGallery(widget.qrCode, context),
                  icon: const Icon(
                    Icons.file_download_rounded,
                    color: Colors.yellow,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Center(
              child: SizedBox(
                width: 220,
                height: 220,
                child: QrImageViewWidget(message: widget.qrCode),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Information:",
                  style: TextStyle(
                    fontSize: 17,
                    height: 5,
                    color: Colors.white70,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        FlutterClipboard.copy(widget.qrCode).then((_) {
                          showMessageSnackBar("Copied", context);
                        });
                      },
                      color: Colors.white,
                      icon: const Icon(
                        Icons.copy,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final urlPattern = RegExp(r'^(http|https)://');
                        if (urlPattern.hasMatch(widget.qrCode)) {
                          await Share.shareUri(Uri.parse(widget.qrCode));
                        } else {
                          await Share.share(widget.qrCode);
                        }
                      },
                      icon: const Icon(
                        Icons.share_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: 350,
              child: Text(
                widget.qrCode.startsWith("WIFI")
                    ? extractWifiInfo(widget.qrCode, context) ?? ""
                    : stringIsMap(widget.qrCode, context) != null
                        ? stringIsMap(widget.qrCode, context)!
                        : widget.qrCode,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? stringIsMap(String qrData, BuildContext context) {
    try {
      Map<String, dynamic> map = jsonDecode(qrData);
      String data = "";
      map.forEach(
        (key, value) {
          data += '$key : $value\n';
        },
      );
      return data;
    } catch (e) {
      return null;
    }
  }

  String? extractWifiInfo(String qrData, BuildContext context) {
    final wifiRegex = RegExp(r'WIFI:T:(.*?);P:(.*?);S:(.*?);');
    final match = wifiRegex.firstMatch(qrData);
    try {
      if (match != null) {
        final securityType = match.group(1) ?? 'N/A';
        final password = match.group(2) ?? 'N/A';
        final ssid = match.group(3) ?? 'N/A';

        return '''
Network security: $securityType
Password: $password
Network name: $ssid
    ''';
      } else {
        return "QR code format is incorrect or no information found.";
      }
    } catch (e) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showErrorSnackBar("Error formatting Wi-Fi information: $e", context);
      });
      return null;
    }
  }

  Future<void> saveQrToGallery(String qrData, BuildContext ctx) async {
    try {
      // 1️⃣ Android versiyasini tekshiramiz

      // Create QR Code
      final qrCode = QrCode.fromData(
        data: qrData,
        errorCorrectLevel: QrErrorCorrectLevel.H,
      );
      final qrImage = QrImage(qrCode);

      // Convert QR Code to bytes with a border
      const double borderWidth = 100.0; // Border width in pixels
      const double qrSize = 2048.0; // QR Code size
      const double totalSize = qrSize + borderWidth * 2;

      final recorder = ui.PictureRecorder();
      final canvas =
          Canvas(recorder, const Rect.fromLTWH(0, 0, totalSize, totalSize));

      // Draw the border (white background)
      final paint = Paint()..color = Colors.white;
      canvas.drawRect(const Rect.fromLTWH(0, 0, totalSize, totalSize), paint);

      // Draw the QR code in the center
      final qrImageBytes = await qrImage.toImageAsBytes(
        size: qrSize.toInt(),
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
      );

      final qrImageBuffer = qrImageBytes!.buffer.asUint8List();
      final codec = await ui.instantiateImageCodec(qrImageBuffer);
      final frame = await codec.getNextFrame();
      final ui.Image qrUiImage = frame.image;

      final paintQr = Paint();
      const offset = Offset(borderWidth, borderWidth); // Offset for the border
      canvas.drawImage(qrUiImage, offset, paintQr);

      // Convert to bytes
      final picture = recorder.endRecording();
      final img = await picture.toImage(totalSize.toInt(), totalSize.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();

      // Save to gallery
      await ImageGallerySaver.saveImage(
        buffer,
        name: "qr_code_${const Uuid().v4().substring(0, 8)}",
        quality: 100,
      );
      showMessageSnackBar("QR code saved to gallery!", ctx);
    } catch (e, s) {
      log("Xatolik: $e");
      log("$s");
      showErrorSnackBar("An error occurred.", ctx);
    }
  }

//   Future<void> checkAndRequestPermission() async {
//   final androidVersion = await _getAndroidVersion();

//   if (androidVersion < 29) { // Android 9 va oldin
//     final status = await Permission.storage.request();
//     if (status.isGranted) {
//       print("✅ Storage ruxsati berildi!");
//     } else if (status.isPermanentlyDenied) {
//       print("⚠️ Ruxsat rad etilgan, Sozlamalar ochiladi.");
//       openAppSettings();
//     } else {
//       print("❌ Ruxsat rad etildi.");
//     }
//   } else if (androidVersion == 29) { // Android 10 (API 29)
//     final status = await Permission.storage.request();
//     if (status.isGranted) {
//       print("✅ Android 10 uchun storage ruxsati berildi!");
//     } else if (status.isPermanentlyDenied) {
//       print("⚠️ Ruxsat rad etilgan, Sozlamalar ochiladi.");
//       openAppSettings();
//     } else {
//       print("❌ Ruxsat rad etildi.");
//     }
//   } else { // Android 11 va undan yuqorisi
//     final status = await Permission.manageExternalStorage.request();
//     if (status.isGranted) {
//       print("✅ Manage External Storage ruxsati berildi!");
//     } else if (status.isPermanentlyDenied) {
//       print("⚠️ Ruxsat rad etilgan, Sozlamalar ochiladi.");
//       openAppSettings();
//     } else {
//       print("❌ Ruxsat rad etildi.");
//     }
//   }
// }

  // // 📌 Android versiyasini olish
  // Future<int> _getAndroidVersion() async {
  //   if (Platform.isAndroid) {
  //     final version = await Process.run('getprop', ['ro.build.version.sdk']);
  //     return int.tryParse(version.stdout.trim()) ?? 30; // Default: Android 11+
  //   }
  //   return 30;
  // }

  Future<void> openWifiSettingsAndroid(BuildContext ctx) async {
    const platform = MethodChannel('samples.flutter.dev/wifi');
    try {
      await platform.invokeMethod('openWifiSettings');
    } on PlatformException catch (e) {
      showErrorSnackBar(
        "Failed to open Wi-Fi settings: '${e.message}",
        ctx,
      );
    }
  }

  void _openWiFiSettingsIOS(BuildContext ctx) async {
    const url = 'App-Prefs:root=WIFI';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      showErrorSnackBar("Could not launch $url", ctx);
    }
  }
}
