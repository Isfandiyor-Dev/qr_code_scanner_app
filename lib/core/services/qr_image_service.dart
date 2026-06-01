import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner_app/core/widgets/loading_dialog.dart';
import 'package:qr_code_scanner_app/core/widgets/snackbar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

/// Captures a designed QR preview (any widget wrapped in a [RepaintBoundary])
/// and saves or shares it as a PNG.
///
/// Shared by the result screen and the design editor so the whole flow -
/// permission request, capture, gallery write, sharing and user feedback - is
/// identical everywhere. Callers just pass the [GlobalKey] of their preview's
/// [RepaintBoundary].
class QrImageService {
  const QrImageService._();

  static const Uuid _uuid = Uuid();

  /// Rasterizes the [RepaintBoundary] identified by [previewKey] to PNG bytes,
  /// or `null` if the boundary isn't currently on screen.
  static Future<Uint8List?> capturePng(
    GlobalKey previewKey, {
    double pixelRatio = 4.0,
  }) async {
    final boundary =
        previewKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  /// Requests the gallery permission appropriate for the platform and OS version:
  /// iOS uses "add only"; Android 10+ (API 29+) needs none (MediaStore); older
  /// Android needs `WRITE_EXTERNAL_STORAGE`.
  static Future<bool> ensureGalleryPermission() async {
    if (Platform.isIOS) {
      final status = await Permission.photosAddOnly.request();
      return status.isGranted || status.isLimited;
    }
    final sdkInt = (await DeviceInfoPlugin().androidInfo).version.sdkInt;
    if (sdkInt >= 29) return true;
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  /// Saves the captured preview to the gallery and shows user feedback.
  static Future<void> saveToGallery(
    BuildContext context,
    GlobalKey previewKey,
  ) async {
    if (!await ensureGalleryPermission()) {
      if (context.mounted) showMessageSnackBar('Permission denied', context);
      return;
    }
    if (!context.mounted) return;

    showLoadingDialog(context);
    try {
      final bytes = await capturePng(previewKey);
      if (!context.mounted) return;
      if (bytes == null) {
        Navigator.of(context).pop();
        showErrorSnackBar('Could not render the QR image.', context);
        return;
      }
      await ImageGallerySaverPlus.saveImage(
        bytes,
        name: 'qr_code_${_uuid.v4().substring(0, 8)}',
        quality: 100,
      );
      if (!context.mounted) return;
      Navigator.of(context).pop();
      showMessageSnackBar('QR code saved to gallery!', context);
    } catch (_) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      showErrorSnackBar('An error occurred while saving.', context);
    }
  }

  /// Shares the captured preview as a temporary PNG file.
  static Future<void> shareImage(
    BuildContext context,
    GlobalKey previewKey,
  ) async {
    try {
      final bytes = await capturePng(previewKey);
      if (bytes == null) {
        if (context.mounted) {
          showErrorSnackBar('Could not render the QR image.', context);
        }
        return;
      }
      final tempDir = await getTemporaryDirectory();
      final file = await File(
        '${tempDir.path}/qr_share_${_uuid.v4().substring(0, 8)}.png',
      ).create();
      await file.writeAsBytes(bytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'image/png')],
          text: 'Scan this QR Code',
        ),
      );
    } catch (_) {
      if (context.mounted) {
        showErrorSnackBar('Failed to share the QR code.', context);
      }
    }
  }
}
