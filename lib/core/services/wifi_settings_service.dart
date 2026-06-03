import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_app/core/widgets/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens the device's Wi-Fi settings for a scanned `WIFI:` QR code.
class WifiSettingsService {
  const WifiSettingsService._();

  /// Copies the Wi-Fi payload to the clipboard (so the password can be pasted)
  /// and opens the platform Wi-Fi settings.
  static Future<void> open(BuildContext context, String qrData) async {
    await FlutterClipboard.copy(qrData);
    if (!context.mounted) return;
    if (Platform.isAndroid) {
      await _openAndroid(context);
    } else if (Platform.isIOS) {
      await _openIOS(context);
    } else if (context.mounted) {
      showMessageSnackBar('This platform is not supported!', context);
    }
  }

  static Future<void> _openAndroid(BuildContext context) async {
    const platform = MethodChannel('samples.flutter.dev/wifi');
    try {
      await platform.invokeMethod('openWifiSettings');
    } on PlatformException catch (e) {
      if (context.mounted) {
        showErrorSnackBar("Failed to open Wi-Fi settings: '${e.message}", context);
      }
    }
  }

  static Future<void> _openIOS(BuildContext context) async {
    const url = 'App-Prefs:root=WIFI';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else if (context.mounted) {
      showErrorSnackBar('Could not launch $url', context);
    }
  }
}
