import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner_app/core/di/di.dart';
import 'package:qr_code_scanner_app/core/widgets/snackbar.dart';
import 'package:qr_code_scanner_app/features/result_screen/presentation/result_page.dart';
import 'package:qr_code_scanner_app/core/enums/result_screen.dart';
import 'package:qr_code_scanner_app/features/root/presentation/screens/screens_manager.dart';
import 'package:share_handler/share_handler.dart';
import 'package:svg_flutter/svg_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final controller = getIt.get<MobileScannerController>();
  late final ShareHandlerPlatform _shareHandler;
  SharedMedia? _sharedMedia;

  @override
  void initState() {
    super.initState();
    _shareHandler = ShareHandler.instance;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initShareHandler();
    });
  }

  Future<void> _initShareHandler() async {
    // Share orqali keldi mi yoki yo‘q
    _sharedMedia = await _shareHandler.getInitialSharedMedia();

    // Agar ilova backgroundda bo‘lsa, kelgan yangi sharingni ham tinglaymiz
    _shareHandler.sharedMediaStream.listen((SharedMedia media) {
      if (mounted) {
        setState(() {
          _sharedMedia = media;
        });
      }
    });

    // 0.5 soniya kutamiz, shunda animatsiya bo‘lsin
    await Future.delayed(const Duration(milliseconds: 500));

    if (_sharedMedia?.attachments?.isNotEmpty ?? false) {
      await _handleSharedMedia(_sharedMedia!);
    } else {
      // Oddiy ishga tushish holati
      _navigateToHome();
    }
  }

  Future<void> _handleSharedMedia(SharedMedia media) async {
    try {
      final files = media.attachments;

      if (files == null || files.isEmpty) {
        showErrorSnackBar("No image found in shared content.", context);
        _navigateToHome();
        return;
      }

      // Faqat birinchi fayl bilan ishlaymiz (ko‘p rasm yuborilsa)
      final firstFile = files.first;
      final filePath = firstFile?.path;

      if (filePath == null || !File(filePath).existsSync()) {
        showErrorSnackBar("Invalid file received.", context);
        _navigateToHome();
        return;
      }

      // Faqat rasm formatlariga ruxsat
      final ext = filePath.split('.').last.toLowerCase();
      if (!['jpg', 'jpeg', 'png', 'bmp', 'gif', 'webp'].contains(ext)) {
        showErrorSnackBar("Please share a valid image file.", context);
        _navigateToHome();
        return;
      }

      final result = await controller.analyzeImage(filePath);

      if (result == null || result.barcodes.isEmpty) {
        showErrorSnackBar("No QR code detected in the shared image.", context);
        _navigateToHome();
        return;
      }

      final code = result.barcodes.first.rawValue;
      if (code == null || code.isEmpty) {
        showErrorSnackBar("Invalid QR code detected.", context);
        _navigateToHome();
        return;
      }

      // ✅ QR code topildi → natija sahifasiga o‘tamiz
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(
            qrCode: code,
            fromScreen: FromScreenEnum.shared,
          ),
        ),
      );
    } catch (e) {
      showErrorSnackBar("Failed to process the shared image.", context);
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ScreensManager()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          'assets/icons/logo.svg',
          width: 65,
          height: 65,
        ),
      ),
    );
  }
}
