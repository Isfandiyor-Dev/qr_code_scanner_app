// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner_app/ui/widgets/image_view_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryItemDetail extends StatelessWidget {
  final String qrCode;
  const HistoryItemDetail({
    super.key,
    required this.qrCode,
  });

  String? getTextButton() {
    if (qrCode.startsWith(RegExp(r'^WIFI:'))) {
      return "Go to WiFi settings";
    } else if (qrCode.startsWith(RegExp(r'^https?://'))) {
      return "Go to site";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Bu qrCode: $qrCode");
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: getTextButton() != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity, // Butun kenglikni egallaydi
                height: 60, // Tugma balandligini sozlash
                child: GestureDetector(
                  onTap: () {
                    if (qrCode.startsWith(RegExp(r'^WIFI:'))) {
                      if (Platform.isAndroid) {
                        openWifiSettingsAndroid();
                      } else if (Platform.isIOS) {
                        _openWiFiSettingsIOS(); // Funksiyani chaqirish
                      } else {
                        print('Qurilma boshqa platformada.');
                      }
                    } else if (qrCode.startsWith(RegExp(r'^https?://'))) {
                      launchUrl(Uri.parse(qrCode)); // URLni ochish
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
                          color: const Color(0xff000000).withOpacity(0.1),
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
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xff333333),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff000000).withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xffFDB623),
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
          top: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: QrImageViewWidget(message: qrCode),
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
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        FlutterClipboard.copy(qrCode).then((_) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "Copied",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.grey.withOpacity(0.5),
                              padding: const EdgeInsets.all(15),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            snackBarAnimationStyle: AnimationStyle(
                              curve: Curves.bounceIn,
                              reverseCurve: Curves.bounceOut,
                              duration: const Duration(milliseconds: 200),
                              reverseDuration:
                                  const Duration(milliseconds: 200),
                            ),
                          );
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
                        if (urlPattern.hasMatch(qrCode)) {
                          await Share.shareUri(Uri.parse(qrCode));
                        } else {
                          await Share.share(qrCode);
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
                qrCode.startsWith("WIFI")
                    ? extractWifiInfo(qrCode)
                    : stringIsMap(qrCode) != null
                        ? stringIsMap(qrCode)!
                        : qrCode,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? stringIsMap(String qrData) {
    try {
      Map<String, dynamic> map = jsonDecode(qrData);
      print("String is a valid Map: $map");
      String data = "";
      map.forEach(
        (key, value) {
          data += '$key : $value\n';
        },
      );
      return data;
    } catch (e) {
      print("String is not a valid Map.");
      return null;
    }
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
        return "QR kod format noto'g'ri yoki ma'lumot topilmadi.";
      }
    } catch (e) {
      print("Wifi ma'lumotlarnini formatlashda xatolik: $e");
      throw Exception("Xatolik yuz berdi!");
    }
  }

  static const platform = MethodChannel('samples.flutter.dev/wifi');

  Future<void> openWifiSettingsAndroid() async {
    try {
      final String result = await platform.invokeMethod('openWifiSettings');
      print(result); // "Opened Wi-Fi settings"
    } on PlatformException catch (e) {
      print("Failed to open Wi-Fi settings: '${e.message}'.");
    }
  }

  void _openWiFiSettingsIOS() async {
    const url = 'App-Prefs:root=WIFI'; // iOS uchun Wi-Fi sozlamalariga URL

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      // canLaunch o'rniga canLaunchUrl ishlatiladi
      await launchUrl(uri);
    } else {
      throw 'URL ochilolmadi: $url';
    }
  }
}
