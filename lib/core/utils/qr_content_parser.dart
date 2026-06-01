import 'dart:convert';

import 'package:qr_code_scanner_app/core/enums/result_screen.dart';

/// Pure helpers for interpreting QR payloads by parsing the common formats
/// (vCard, MeCard, Wi-Fi, JSON) into human-readable text, normalizing contacts,
/// and deriving the result screen's action label.
///
/// Everything here is side-effect free (no `BuildContext`, no UI) so it's easy
/// to reuse and test.
class QrContentParser {
  const QrContentParser._();

  /// Human-readable description of [qrData] for the info panel; falls back to
  /// the raw payload when it isn't a recognized structured format.
  static String describe(String qrData) {
    if (qrData.startsWith('WIFI')) return wifiInfo(qrData) ?? '';
    if (qrData.startsWith('BEGIN:VCARD')) return vCardInfo(qrData) ?? '';
    if (qrData.startsWith('MECARD:')) return mecardInfo(qrData) ?? '';
    return jsonMapToText(qrData) ?? qrData;
  }

  /// Label for the result screen's primary action button, or `null` for none.
  static String? actionLabel(
    String qrData, {
    required FromScreenEnum fromScreen,
  }) {
    if (qrData.startsWith(RegExp(r'^WIFI:'))) return 'Go to WiFi settings';
    if (qrData.startsWith(RegExp(r'^https?://'))) return 'Go to site';
    if (qrData.startsWith('BEGIN:VCARD') || qrData.startsWith('MECARD:')) {
      return 'Import contact';
    }
    if (fromScreen == FromScreenEnum.scanned) return 'Scan again';
    return null;
  }

  /// Returns a vCard string for [rawData] (passing through vCards and converting
  /// MeCards), or `null` if it isn't a contact format.
  static String? normalizeToVCard(String rawData) {
    if (rawData.trim().isEmpty) return null;

    if (rawData.startsWith('BEGIN:VCARD')) {
      return rawData.trim();
    }

    if (rawData.startsWith('MECARD:')) {
      final fields = rawData.replaceFirst('MECARD:', '').split(';');
      final Map<String, String> data = {};

      for (final field in fields) {
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

    return null;
  }

  /// Formats a MeCard payload into readable lines, or `null` if not a MeCard.
  static String? mecardInfo(String qrData) {
    try {
      if (!qrData.startsWith('MECARD:')) return null;

      final data = qrData.substring(7);
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
    } catch (_) {
      return null;
    }
  }

  /// Formats a vCard payload into readable lines, or `null` if not a vCard.
  static String? vCardInfo(String qrData) {
    try {
      if (!qrData.startsWith('BEGIN:VCARD')) return null;

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
          final parts = line.substring(4).split(';');
          final street = parts.length > 2 ? parts[2] : '';
          final city = parts.length > 3 ? parts[3] : '';
          final country = parts.length > 6 ? parts[6] : '';
          address = [street, city, country]
              .where((part) => part.isNotEmpty)
              .join(', ');
        }
      }

      final buffer = StringBuffer();
      if (fullName.isNotEmpty) buffer.writeln('Full Name: $fullName');
      if (phone.isNotEmpty) buffer.writeln('Phone: $phone');
      if (email.isNotEmpty) buffer.writeln('Email: $email');
      if (company.isNotEmpty) buffer.writeln('Company: $company');
      if (title.isNotEmpty) buffer.writeln('Job Title: $title');
      if (website.isNotEmpty) buffer.writeln('Website: $website');
      if (address.isNotEmpty) buffer.writeln('Address: $address');

      return buffer.isEmpty ? 'No valid vCard data found.' : buffer.toString();
    } catch (_) {
      return null;
    }
  }

  /// Formats a `WIFI:` payload into readable lines, or `null` on failure.
  static String? wifiInfo(String qrData) {
    try {
      String cleaned = qrData.trim();
      if (cleaned.startsWith('WIFI:')) {
        cleaned = cleaned.substring(5);
      }
      cleaned = cleaned.replaceAll(';;', ';');

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

      final ssid = data['S'] ?? 'N/A';
      final securityType = data['T'] ?? 'N/A';
      final password = data['P'] ?? '';
      final hidden = data['H'];

      final displayPassword = password.isEmpty ? 'No password' : password;
      final hiddenText = (hidden == null || hidden.isEmpty)
          ? ''
          : '\nHidden network: ${hidden == "true" ? "Yes" : "No"}';

      if (ssid == 'N/A' && securityType == 'N/A') {
        return 'QR code format is incorrect or no Wi-Fi information found.';
      }

      return '''
Network name (SSID): $ssid
Security type: $securityType
Password: $displayPassword$hiddenText
''';
    } catch (_) {
      return null;
    }
  }

  /// Renders a JSON object payload as `key : value` lines, or `null` if [qrData]
  /// isn't valid JSON.
  static String? jsonMapToText(String qrData) {
    try {
      final Map<String, dynamic> map = jsonDecode(qrData);
      final buffer = StringBuffer();
      map.forEach((key, value) => buffer.writeln('$key : $value'));
      return buffer.toString();
    } catch (_) {
      return null;
    }
  }
}
