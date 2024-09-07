import 'package:qr_code_scanner_app/data/models/scan_qr/scan_qr_model.dart';

sealed class HistoryState {}

final class InitialHistoryState extends HistoryState {}

final class LoadingHistoryState extends HistoryState {}

final class LoadedHistoryState extends HistoryState {
  final List<ScanQrModel> qrCodesList;

  LoadedHistoryState({required this.qrCodesList});
}

final class ErrorHistoryState extends HistoryState {
  final String message;

  ErrorHistoryState({required this.message});
}
