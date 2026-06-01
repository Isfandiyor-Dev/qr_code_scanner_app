import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

import '../config/local_config.dart';

/// Produces the audible (beep) and haptic (vibration) feedback that fires when a
/// QR code is scanned successfully.
///
/// Both effects are gated by the user's preferences, which are read fresh from
/// [LocalConfig] on every scan so that toggling a switch on the Settings screen
/// takes effect immediately. Every method is defensive: feedback must never
/// break or delay the scan flow, so all failures are swallowed.
class ScanFeedbackService {
  ScanFeedbackService({required LocalConfig config}) : _config = config;

  final LocalConfig _config;
  final AudioPlayer _player = AudioPlayer();

  /// Path is relative to the `assets/` folder; `audioplayers` prepends it,
  /// so this resolves to `assets/sound/beep.mp3`.
  static const String _beepAsset = 'sound/beep.mp3';

  /// Beep playback volume (0.0-1.0). Kept below full volume so the cue is
  /// noticeable without being harsh.
  static const double _beepVolume = 0.7;

  /// Call once when a scan succeeds. Runs the beep and vibration concurrently.
  Future<void> onScanSuccess() async {
    await Future.wait([_playBeep(), _vibrate()]);
  }

  Future<void> _playBeep() async {
    if (!_config.beepEnabled) return;
    try {
      // Restart from the beginning so rapid successive scans each beep.
      await _player.stop();
      await _player.play(AssetSource(_beepAsset), volume: _beepVolume);
    } catch (_) {
      // Ignore audio failures; scan completion must not depend on playback.
    }
  }

  Future<void> _vibrate() async {
    if (!_config.vibrateEnabled) return;
    try {
      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(duration: 150);
      }
    } catch (_) {
      // Ignore vibration failures; scan completion must not depend on haptics.
    }
  }

  /// Releases audio resources held by the feedback player.
  void dispose() => _player.dispose();
}
