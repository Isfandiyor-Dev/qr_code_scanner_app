import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight, synchronous wrapper around [SharedPreferences] for persisting
/// user preferences.
///
/// Currently it stores the two scan-feedback toggles shown on the Settings
/// screen. Both default to `true` when nothing has been persisted yet, which is
/// why the switches start in the ON position on a fresh install.
class LocalConfig {
  LocalConfig({required SharedPreferences preferences})
      : _preferences = preferences;

  final SharedPreferences _preferences;

  static const String _vibrateKey = 'settings_vibrate_enabled';
  static const String _beepKey = 'settings_beep_enabled';

  /// Whether the device should vibrate on a successful scan. Defaults to `true`.
  bool get vibrateEnabled => _preferences.getBool(_vibrateKey) ?? true;

  /// Whether a beep should play on a successful scan. Defaults to `true`.
  bool get beepEnabled => _preferences.getBool(_beepKey) ?? true;

  /// Persists whether vibration feedback is enabled.
  Future<void> setVibrateEnabled(bool value) =>
      _preferences.setBool(_vibrateKey, value);

  /// Persists whether beep feedback is enabled.
  Future<void> setBeepEnabled(bool value) =>
      _preferences.setBool(_beepKey, value);
}
