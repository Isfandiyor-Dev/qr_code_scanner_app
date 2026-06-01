import '../../data_source/models/qr_design_config.dart';

/// Lifecycle status of the QR customization flow.
enum QrCustomizationStatus {
  /// Before the saved design has been read.
  initial,

  /// Reading the saved design from storage.
  loading,

  /// A design is loaded and editable.
  ready,

  /// A save is in progress.
  saving,

  /// The design was just persisted (transient, used to trigger feedback).
  saved,

  /// An operation failed; see [QrCustomizationState.errorMessage].
  error,
}

/// Immutable state for [QrCustomizationCubit].
///
/// Holds the live [config] (source of truth for the preview), the current
/// [status], whether there are unsaved changes ([isDirty]) and an optional
/// [errorMessage].
class QrCustomizationState {
  final QrDesignConfig config;
  final QrCustomizationStatus status;
  final bool isDirty;
  final String? errorMessage;

  const QrCustomizationState({
    required this.config,
    required this.status,
    required this.isDirty,
    this.errorMessage,
  });

  /// Starting state before any load, using sensible defaults so the preview can
  /// render immediately.
  factory QrCustomizationState.initial() {
    return QrCustomizationState(
      config: QrDesignConfig.defaults(),
      status: QrCustomizationStatus.initial,
      isDirty: false,
    );
  }

  /// Returns a copy of this state with selected values changed.
  QrCustomizationState copyWith({
    QrDesignConfig? config,
    QrCustomizationStatus? status,
    bool? isDirty,
    Object? errorMessage = _undefined,
  }) {
    return QrCustomizationState(
      config: config ?? this.config,
      status: status ?? this.status,
      isDirty: isDirty ?? this.isDirty,
      errorMessage: identical(errorMessage, _undefined)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QrCustomizationState &&
        other.config == config &&
        other.status == status &&
        other.isDirty == isDirty &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(config, status, isDirty, errorMessage);
}

const Object _undefined = Object();
