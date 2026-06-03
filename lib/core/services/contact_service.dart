import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_app/core/utils/qr_content_parser.dart';
import 'package:qr_code_app/core/widgets/snackbar.dart';
import 'package:uuid/uuid.dart';

/// Imports a contact encoded in a QR code into the device address book.
class ContactService {
  const ContactService._();

  /// Normalizes [qrData] to vCard and hands it to the OS to import.
  ///
  /// Currently wired for Android via a temporary `.vcf` and a platform channel;
  /// other platforms show an informational message.
  static Future<void> importFromQr(BuildContext context, String qrData) async {
    final vCard = QrContentParser.normalizeToVCard(qrData);
    if (vCard == null) {
      if (context.mounted) {
        showErrorSnackBar('This QR code is not a valid contact format.', context);
      }
      return;
    }

    try {
      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/contact_${const Uuid().v4().substring(0, 8)}.vcf',
      );
      await file.writeAsString(vCard);

      if (Platform.isAndroid) {
        const channel = MethodChannel('app.channel.shared.data');
        await channel.invokeMethod('getFileUri', {'path': file.path});
      } else if (context.mounted) {
        showMessageSnackBar(
          'This feature is available only on Android for now.',
          context,
        );
      }
    } catch (_) {
      if (context.mounted) showErrorSnackBar('Error importing contact', context);
    }
  }
}
