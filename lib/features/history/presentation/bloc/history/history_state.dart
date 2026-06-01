import 'package:qr_code_scanner_app/features/history/data_source/models/scan_qr/scan_qr_model.dart';

/// Base class for QR history states.
sealed class HistoryState {}

/// Initial state before history is loaded.
final class InitialHistoryState extends HistoryState {}

/// State containing loaded QR history entries.
final class LoadedHistoryState extends HistoryState {
  /// QR history entries sorted for display.
  final List<QrCodeModel> qrCodesList;

  /// Creates a loaded history state.
  LoadedHistoryState({required this.qrCodesList});
}

/// State emitted when a history operation fails.
final class ErrorHistoryState extends HistoryState {
  /// Error message suitable for logging or simple display.
  final String message;

  /// Creates a history error state.
  ErrorHistoryState({required this.message});
}
