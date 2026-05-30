// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_code_scanner_app/core/enums/result_screen.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_text_theme_extension.dart';
import 'package:qr_code_scanner_app/core/widgets/back_widget.dart';
import 'package:qr_code_scanner_app/core/widgets/image_view_widget.dart';
import 'package:qr_code_scanner_app/core/widgets/snackbar.dart';
import 'package:qr_code_scanner_app/features/root/presentation/screens/screens_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

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
    } else if (widget.qrCode.startsWith("BEGIN:VCARD") ||
        widget.qrCode.startsWith("MECARD:")) {
      return "Import contact";
    } else if (widget.fromScreen == FromScreenEnum.scanned) {
      return "Scan again";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.fromScreen != FromScreenEnum.shared,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && widget.fromScreen == FromScreenEnum.shared) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ScreensManager()),
          );
        }
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: getTextButton() != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: GestureDetector(
                    onTap: () async {
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
                      } else if (widget.qrCode.startsWith("BEGIN:VCARD") ||
                          widget.qrCode.startsWith("MECARD:")) {
                        final vCardData = normalizeToVCard(widget.qrCode);

                        if (vCardData != null) {
                          await importContact(vCardData, context);
                        } else {
                          showErrorSnackBar(
                              "This QR code is not a valid contact format.",
                              context);
                        }
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
                            color: Colors.black.withValues(alpha: 0.1),
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
          leading: BackWidget(
            onTap: () {
              if (widget.fromScreen == FromScreenEnum.shared) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ScreensManager()),
                );
              } else {
                Navigator.pop(context);
                if (widget.fromScreen == FromScreenEnum.generated) {
                  Navigator.pop(context);
                }
              }
            },
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
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            saveQrToGallery(widget.qrCode, context),
                        icon: const Icon(
                          Icons.file_download_rounded,
                          color: Colors.yellow,
                        ),
                      ),
                      IconButton(
                        onPressed: () => shareQrImage(widget.qrCode, context),
                        icon: Icon(
                          Icons.share_rounded,
                          color: Colors.yellow,
                        ),
                      ),
                    ],
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
              Gap(40),
              Divider(color: Colors.grey.shade600),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Information:",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
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
                          size: 20,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final urlPattern = RegExp(r'^(http|https)://');
                          final box = context.findRenderObject() as RenderBox?;

                          final params = urlPattern.hasMatch(widget.qrCode)
                              ? ShareParams(
                                  uri: Uri.parse(widget.qrCode),
                                  title: "Share QR link",
                                  sharePositionOrigin:
                                      box!.localToGlobal(Offset.zero) &
                                          box.size,
                                )
                              : ShareParams(
                                  text: widget.qrCode,
                                  title: "Share QR code",
                                  sharePositionOrigin:
                                      box!.localToGlobal(Offset.zero) &
                                          box.size,
                                );

                          final result = await SharePlus.instance.share(params);

                          if (result.status == ShareResultStatus.success) {
                            showMessageSnackBar("Thanks for sharing!", context);
                          }
                        },
                        icon: const Icon(
                          Icons.share_rounded,
                          color: Colors.white,
                          size: 20,
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
                      : widget.qrCode.startsWith("BEGIN:VCARD")
                          ? extractVCardInfo(widget.qrCode, context) ?? ""
                          : widget.qrCode.startsWith("MECARD:")
                              ? extractMecardInfo(widget.qrCode, context) ?? ""
                              : stringIsMap(widget.qrCode, context) ??
                                  widget.qrCode,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? normalizeToVCard(String rawData) {
    if (rawData.trim().isEmpty) return null;

    // 1. Agar bu allaqachon vCard bo‘lsa — o‘sha holatda qaytaramiz
    if (rawData.startsWith("BEGIN:VCARD")) {
      return rawData.trim();
    }

    // 2. Agar bu MeCard bo‘lsa — vCard formatga o‘tkazamiz
    if (rawData.startsWith("MECARD:")) {
      final fields = rawData.replaceFirst('MECARD:', '').split(';');
      final Map<String, String> data = {};

      for (var field in fields) {
        if (field.contains(':')) {
          final parts = field.split(':');
          if (parts.length == 2) {
            data[parts[0].trim()] = parts[1].trim();
          }
        }
      }

      final name = data['N'] ?? '';
      final phone = data['TEL'] ?? '';
      final email = data['EMAIL'] ?? '';
      final org = data['ORG'] ?? '';
      final url = data['URL'] ?? '';
      final adr = data['ADR'] ?? '';

      return '''
BEGIN:VCARD
VERSION:3.0
FN:$name
N:$name
TEL:$phone
EMAIL:$email
ORG:$org
URL:$url
ADR:$adr
END:VCARD
'''
          .trim();
    }

    // 3. Aks holda hech qanday formatga to‘g‘ri kelmadi
    return null;
  }

  Future<void> importContact(String qrData, BuildContext context) async {
    try {
      //  1. Temporary fayl yaratamiz
      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/contact_${const Uuid().v4().substring(0, 8)}.vcf';
      final file = File(filePath);
      await file.writeAsString(qrData);

      //  2. Faqat Android uchun ishlaydi
      if (Platform.isAndroid) {
        const channel = MethodChannel('app.channel.shared.data');
        await channel.invokeMethod('getFileUri', {'path': file.path});
      } else {
        showMessageSnackBar(
            "This feature is available only on Android for now.", context);
      }
    } catch (e) {
      showErrorSnackBar("Error importing contact", context);
    }
  }

  String? extractMecardInfo(String qrData, BuildContext context) {
    try {
      if (!qrData.startsWith("MECARD:")) return null;

      final data = qrData.substring(7); // "MECARD:"ni olib tashlaymiz
      final fields = data.split(';');

      String name = '';
      String phone = '';
      String email = '';
      String org = '';
      String address = '';
      String website = '';
      String note = '';

      for (final field in fields) {
        if (field.startsWith('N:')) {
          name = field.substring(2);
        } else if (field.startsWith('TEL:')) {
          phone = field.substring(4);
        } else if (field.startsWith('EMAIL:')) {
          email = field.substring(6);
        } else if (field.startsWith('ORG:')) {
          org = field.substring(4);
        } else if (field.startsWith('ADR:')) {
          address = field.substring(4);
        } else if (field.startsWith('URL:')) {
          website = field.substring(4);
        } else if (field.startsWith('NOTE:')) {
          note = field.substring(5);
        }
      }

      final buffer = StringBuffer();
      if (name.isNotEmpty) buffer.writeln('Full Name: $name');
      if (phone.isNotEmpty) buffer.writeln('Phone: $phone');
      if (email.isNotEmpty) buffer.writeln('Email: $email');
      if (org.isNotEmpty) buffer.writeln('Company: $org');
      if (address.isNotEmpty) buffer.writeln('Address: $address');
      if (website.isNotEmpty) buffer.writeln('Website: $website');
      if (note.isNotEmpty) buffer.writeln('Note: $note');

      return buffer.isEmpty ? 'No valid MECARD data found.' : buffer.toString();
    } catch (e) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showErrorSnackBar("Error parsing MECARD", context);
      });
      return null;
    }
  }

  String? extractVCardInfo(String qrData, BuildContext context) {
    try {
      if (!qrData.startsWith("BEGIN:VCARD")) return null;

      final lines = qrData.split('\n');
      String fullName = '';
      String phone = '';
      String email = '';
      String company = '';
      String title = '';
      String website = '';
      String address = '';

      for (final line in lines) {
        if (line.startsWith('FN:')) {
          fullName = line.substring(3).trim();
        } else if (line.startsWith('TEL:')) {
          phone = line.substring(4).trim();
        } else if (line.startsWith('EMAIL:')) {
          email = line.substring(6).trim();
        } else if (line.startsWith('ORG:')) {
          company = line.substring(4).trim();
        } else if (line.startsWith('TITLE:')) {
          title = line.substring(6).trim();
        } else if (line.startsWith('URL:')) {
          website = line.substring(4).trim();
        } else if (line.startsWith('ADR:')) {
          // ADR:;;123 Main St;Tashkent;;;Uzbekistan
          final parts = line.substring(4).split(';');
          final street = parts.length > 2 ? parts[2] : '';
          final city = parts.length > 3 ? parts[3] : '';
          final country = parts.length > 6 ? parts[6] : '';
          address = [street, city, country]
              .where((part) => part.isNotEmpty)
              .join(', ');
        }
      }

      // ✅ Ma'lumotlarni yig'amiz
      final buffer = StringBuffer();

      if (fullName.isNotEmpty) buffer.writeln('Full Name: $fullName');
      if (phone.isNotEmpty) buffer.writeln('Phone: $phone');
      if (email.isNotEmpty) buffer.writeln('Email: $email');
      if (company.isNotEmpty) buffer.writeln('Company: $company');
      if (title.isNotEmpty) buffer.writeln('Job Title: $title');
      if (website.isNotEmpty) buffer.writeln('Website: $website');
      if (address.isNotEmpty) buffer.writeln('Address: $address');

      return buffer.isEmpty ? 'No valid vCard data found.' : buffer.toString();
    } catch (e) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showErrorSnackBar("Error parsing vCard", context);
      });
      return null;
    }
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
    try {
      // 🔹 "WIFI:" boshini olib tashlaymiz va ortiqcha nuqta-vergullarni tozalaymiz
      String cleaned = qrData.trim();
      if (cleaned.startsWith('WIFI:')) {
        cleaned = cleaned.substring(5);
      }
      cleaned = cleaned.replaceAll(';;', ';');

      // 🔹 Ma’lumotlarni `;` bo‘yicha ajratamiz
      final parts = cleaned.split(';');
      final Map<String, String> data = {};

      for (final part in parts) {
        if (part.contains(':')) {
          final key = part.split(':').first;
          final value = part.substring(part.indexOf(':') + 1);
          if (key.isNotEmpty && value.isNotEmpty) {
            data[key.trim()] = value.trim();
          }
        }
      }

      // 🔹 Asosiy qiymatlarni olish
      final ssid = data['S'] ?? 'N/A';
      final securityType = data['T'] ?? 'N/A';
      final password = data['P'] ?? '';
      final hidden = data['H'];

      // 🔹 Password yo‘q bo‘lsa
      final displayPassword = password.isEmpty ? 'No password' : password;

      // 🔹 Hidden qiymati bo‘lsa chiqaramiz
      final hiddenText = (hidden == null || hidden.isEmpty)
          ? ''
          : '\nHidden network: ${hidden == "true" ? "Yes" : "No"}';

      // 🔹 Agar SSID yoki Type topilmasa
      if (ssid == 'N/A' && securityType == 'N/A') {
        return "QR code format is incorrect or no Wi-Fi information found.";
      }

      // 🔹 Natijani chiqaramiz
      return '''
Network name (SSID): $ssid
Security type: $securityType
Password: $displayPassword$hiddenText
''';
    } catch (e) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showErrorSnackBar("Error parsing Wi-Fi information", context);
      });
      return null;
    }
  }

  Future<void> shareQrImage(String qrData, BuildContext ctx) async {
    try {
      const double borderWidth = 100.0;
      const double qrSize = 720.0;
      const double totalSize = qrSize + borderWidth * 2;

      // QR kodni yaratamiz
      final qrCode = QrCode.fromData(
        data: qrData,
        errorCorrectLevel: QrErrorCorrectLevel.H,
      );
      final qrImage = QrImage(qrCode);

      // QR-ni chizamiz
      final recorder = ui.PictureRecorder();
      final canvas =
          Canvas(recorder, const Rect.fromLTWH(0, 0, totalSize, totalSize));
      final paint = Paint()..color = Colors.white;
      canvas.drawRect(const Rect.fromLTWH(0, 0, totalSize, totalSize), paint);

      final qrBytes = await qrImage.toImageAsBytes(
        size: qrSize.toInt(),
        decoration: const PrettyQrDecoration(
          background: Colors.white,
          shape: PrettyQrSmoothSymbol(roundFactor: 0.6),
        ),
      );

      final qrImageBuffer = qrBytes!.buffer.asUint8List();
      final codec = await ui.instantiateImageCodec(qrImageBuffer);
      final frame = await codec.getNextFrame();
      final qrUiImage = frame.image;

      // QR kodni joylashtiramiz
      canvas.drawImage(
          qrUiImage, const Offset(borderWidth, borderWidth), Paint());

      // PNG formatga o‘tkazamiz
      final picture = recorder.endRecording();
      final img = await picture.toImage(totalSize.toInt(), totalSize.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      // Xotirada vaqtincha fayl yaratamiz
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/qr_share.png').create();
      await file.writeAsBytes(bytes);

      // Faylni share qilamiz
      await SharePlus.instance.share(
        ShareParams(
            files: [XFile(file.path, mimeType: 'image/png')],
            text: "Scan this QR Code"),
      );
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text("QR kodni ulashishda xatolik yuz berdi.")),
      );
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // foydalanuvchi orqaga chiqolmaydi
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (_) => Center(
        child: CupertinoActivityIndicator(
          color: context.colorScheme.primary,
          radius: 15,
        ),
      ),
    );
  }

  Future<void> saveQrToGallery(String qrData, BuildContext ctx) async {
    // Request the appropriate permission on every press.
    // On Android 13+, Permission.storage is auto-granted; on older versions it
    // triggers the OS dialog. On iOS, Permission.photos covers the photo library.
    final permission = Platform.isIOS ? Permission.photos : Permission.storage;
    final status = await permission.request();

    if (!status.isGranted) {
      showMessageSnackBar("Permission denied", ctx);
      return;
    }

    try {
      showLoadingDialog(ctx);

      const double borderWidth = 100.0;
      const double qrSize = 720.0;
      const double totalSize = qrSize + borderWidth * 2;

      final qrCode = QrCode.fromData(
        data: qrData,
        errorCorrectLevel: QrErrorCorrectLevel.H,
      );
      final qrImage = QrImage(qrCode);

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
        recorder,
        const Rect.fromLTWH(0, 0, totalSize, totalSize),
      );

      canvas.drawRect(
        const Rect.fromLTWH(0, 0, totalSize, totalSize),
        Paint()..color = Colors.white,
      );

      final qrImageBytes = await qrImage.toImageAsBytes(
        size: qrSize.toInt(),
        decoration: const PrettyQrDecoration(
          background: Colors.white,
          shape: PrettyQrSmoothSymbol(roundFactor: 0.6),
        ),
      );

      final codec = await ui.instantiateImageCodec(
        qrImageBytes!.buffer.asUint8List(),
      );
      final qrUiImage = (await codec.getNextFrame()).image;

      canvas.drawImage(qrUiImage, const Offset(borderWidth, borderWidth), Paint());

      final img = await recorder
          .endRecording()
          .toImage(totalSize.toInt(), totalSize.toInt());
      final pngBytes =
          (await img.toByteData(format: ui.ImageByteFormat.png))!
              .buffer
              .asUint8List();

      await ImageGallerySaverPlus.saveImage(
        pngBytes,
        name: "qr_code_${const Uuid().v4().substring(0, 8)}",
        quality: 100,
      );

      Navigator.pop(ctx);
      showMessageSnackBar("QR code saved to gallery!", ctx);
    } catch (e) {
      Navigator.pop(ctx);
      showErrorSnackBar("An error occurred while saving.", ctx);
    }
  }

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
