import 'dart:io'; // Platform ishlatish uchun import qilinadi

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner_app/ui/widgets/image_view_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wifi_iot/wifi_iot.dart';

class ResultPage extends StatelessWidget {
  final String qrCode;
  const ResultPage({super.key, required this.qrCode});

  @override
  Widget build(BuildContext context) {
    print("Bu qrCode: $qrCode");
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (qrCode.startsWith(RegExp(r'^WIFI:'))) {
              if (Platform.isAndroid) {
                requestPermission();
                print('Qurilma Android platformasida.');
              } else if (Platform.isIOS) {
                _openWiFiSettings(); // Funksiyani chaqirish
                print('Qurilma iOS platformasida.');
              } else {
                print('Qurilma boshqa platformada.');
              }
            } else if (qrCode.startsWith(RegExp(r'^https?://'))) {
              launchUrl(Uri.parse(qrCode)); // URLni ochish
            } else {
              Navigator.pop(context);
            }
          },
          child: Ink(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                qrCode.startsWith(RegExp(r'^WIFI:'))
                    ? "Connect to wifi"
                    : qrCode.startsWith(RegExp(r'^https?://'))
                        ? "Go to site"
                        : "Scan again",
                style: const TextStyle(
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
              "Information about the QR code:",
              style: TextStyle(
                fontSize: 15,
                height: 5,
              ),
            ),
            SizedBox(
              width: 350,
              child: Text(
                qrCode.startsWith("WIFI") ? extractWifiInfo(qrCode) : qrCode,
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

  String extractWifiInfo(String qrData) {
    final wifiRegex = RegExp(r'WIFI:T:(.*?);P:(.*?);S:(.*?);');
    final match = wifiRegex.firstMatch(qrData);
    try {
      if (match != null) {
        final securityType = match.group(1) ?? 'N/A';
        final password = match.group(2) ?? 'N/A';
        final ssid = match.group(3) ?? 'N/A';

        return '''
Tarmoq xavfsizligi: $securityType
Parol: $password
Tarmoq nomi: $ssid
    ''';
      } else {
        return 'QR kod format notoʻgʻri yoki maʼlumot topilmadi.';
      }
    } catch (e) {
      print("Wifi ma'lumotlarnini formatlashda xatolik: $e");
      throw Exception("Xatolik yuz berdi!");
    }
  }

  void connectToWifi(String qrData) async {
    final wifiRegex = RegExp(r'WIFI:T:(.*?);P:(.*?);S:(.*?);');
    final match = wifiRegex.firstMatch(qrData);
    try {
      if (match != null) {
        final password = match.group(2) ?? 'N/A';
        final ssid = match.group(3) ?? 'N/A';
        await WiFiForIoTPlugin.connect(ssid, password: password);
      } else {
        print("Ma'lumot yo'q");
      }
    } catch (e) {
      print("Wifiga ulanishda xatolik: $e");
      throw Exception("Xatolik yuz berdi!");
    }
  }

  void _openWiFiSettings() async {
    const url = 'App-Prefs:root=WIFI'; // iOS uchun Wi-Fi sozlamalariga URL

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      // canLaunch o'rniga canLaunchUrl ishlatiladi
      await launchUrl(uri);
    } else {
      throw 'URL ochilolmadi: $url';
    }
  }

  Future<void> requestPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      // Ruxsat berilgan, Wi-Fi ulanish funksiyasini chaqiring
      connectToWifi(qrCode);
    } else if (status.isDenied) {
      // Ruxsat berilmagan, foydalanuvchiga ruxsat berishni so'rang
      print('Ruxsat berilmagan');
    } else if (status.isPermanentlyDenied) {
      // Foydalanuvchi ruxsatni abadiy rad etdi, ilova sozlamalariga o'ting
      print('Ruxsatni abadiy rad etdi');
      await openAppSettings();
    }
  }
}
