import 'package:bloc/bloc.dart';

import '../../../../core/config/local_config.dart';
import 'settings_state.dart';

/// Drives the Settings screen. Seeds its initial state from the persisted
/// [LocalConfig] values (defaulting to ON) and writes every change straight
/// back to disk so the [ScanFeedbackService] always reads the latest value.
class SettingsCubit extends Cubit<SettingsState> {
  final LocalConfig _config;

  SettingsCubit({required LocalConfig config})
      : _config = config,
        super(
          SettingsState(
            vibrateEnabled: config.vibrateEnabled,
            beepEnabled: config.beepEnabled,
          ),
        );

  /// Enables or disables vibration feedback and persists the preference.
  Future<void> toggleVibrate(bool value) async {
    emit(state.copyWith(vibrateEnabled: value));
    await _config.setVibrateEnabled(value);
  }

  /// Enables or disables beep feedback and persists the preference.
  Future<void> toggleBeep(bool value) async {
    emit(state.copyWith(beepEnabled: value));
    await _config.setBeepEnabled(value);
  }
}
