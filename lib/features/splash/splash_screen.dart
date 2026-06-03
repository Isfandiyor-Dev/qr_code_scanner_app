import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_app/core/di/di.dart';
import 'package:qr_code_app/core/widgets/snackbar.dart';
import 'package:qr_code_app/features/result_screen/presentation/result_page.dart';
import 'package:qr_code_app/core/enums/result_screen.dart';
import 'package:qr_code_app/features/root/presentation/screens/screens_manager.dart';
import 'package:qr_code_app/gen/assets.gen.dart';
import 'package:share_handler/share_handler.dart';
import 'package:svg_flutter/svg_flutter.dart';

/// Splash screen that routes shared images or opens the main app shell.
class SplashScreen extends StatefulWidget {
  /// Creates the splash screen.
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

  /// Initializes share handling before deciding the first route.
  Future<void> _initShareHandler() async {
    _sharedMedia = await _shareHandler.getInitialSharedMedia();

    // Continue listening so shared images are handled when the app is resumed.
    _shareHandler.sharedMediaStream.listen((SharedMedia media) {
      if (mounted) {
        setState(() {
          _sharedMedia = media;
        });
      }
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (_sharedMedia?.attachments?.isNotEmpty ?? false) {
      await _handleSharedMedia(_sharedMedia!);
    } else {
      _navigateToHome();
    }
  }

  /// Attempts to decode a QR code from an image shared into the app.
  Future<void> _handleSharedMedia(SharedMedia media) async {
    try {
      final files = media.attachments;

      if (files == null || files.isEmpty) {
        showErrorSnackBar("No image found in shared content.", context);
        _navigateToHome();
        return;
      }

      // Only the first attachment is processed because the result screen shows one QR.
      final firstFile = files.first;
      final filePath = firstFile?.path;

      if (filePath == null || !File(filePath).existsSync()) {
        showErrorSnackBar("Invalid file received.", context);
        _navigateToHome();
        return;
      }

      // Keep decoding limited to image formats supported by MobileScanner.
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

  /// Opens the main application shell.
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
          Assets.icons.logo.path,
          width: 80,
          height: 80,
        ),
      ),
    );
  }
}
