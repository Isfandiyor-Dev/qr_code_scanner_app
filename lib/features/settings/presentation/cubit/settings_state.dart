/// Immutable state for the Settings screen: the two scan-feedback toggles.
class SettingsState {
  /// Whether vibration feedback is enabled after a successful scan.
  final bool vibrateEnabled;

  /// Whether beep feedback is enabled after a successful scan.
  final bool beepEnabled;

  /// Creates immutable Settings screen state.
  const SettingsState({
    this.vibrateEnabled = true,
    this.beepEnabled = true,
  });

  /// Returns a copy of this state with selected values changed.
  SettingsState copyWith({bool? vibrateEnabled, bool? beepEnabled}) {
    return SettingsState(
      vibrateEnabled: vibrateEnabled ?? this.vibrateEnabled,
      beepEnabled: beepEnabled ?? this.beepEnabled,
    );
  }
}
