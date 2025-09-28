import 'package:qr_code_scanner_app/features/history/data_source/models/scan_qr/scan_qr_model.dart';

sealed class HistoryState {}

final class InitialHistoryState extends HistoryState {}

final class LoadedHistoryState extends HistoryState {
  final List<QrCodeModel> qrCodesList;

  LoadedHistoryState({required this.qrCodesList});
}

final class ErrorHistoryState extends HistoryState {
  final String message;

  ErrorHistoryState({required this.message});
}
