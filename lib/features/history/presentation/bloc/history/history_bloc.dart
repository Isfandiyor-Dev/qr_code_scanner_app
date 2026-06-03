import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_app/features/history/domain/use_cases/add_qr_code_use_case.dart';
import 'package:qr_code_app/features/history/domain/use_cases/delete_qr_code_use_case.dart';
import 'package:qr_code_app/features/history/domain/use_cases/get_qr_codes_use_case.dart';
import 'package:qr_code_app/features/history/presentation/bloc/history/history_event.dart';
import 'package:qr_code_app/features/history/presentation/bloc/history/history_state.dart';
import 'package:qr_code_app/features/history/data_source/models/scan_qr/scan_qr_model.dart';

import '../../../data_source/models/scan_qr/scan_qr_request.dart';

/// Bloc that loads, inserts, and deletes QR history entries.
class HistoryBloc extends Bloc<HistoryEvents, HistoryState> {
  final GetQrCodesUseCase _getQrCodesUseCase;
  final AddQrCodeUseCase _addQrCodeUseCase;
  final DeleteQrCodeUseCase _deleteQrCodeUseCase;

  /// Creates a history bloc with the required use cases.
  HistoryBloc({
    required GetQrCodesUseCase getQrCodesUseCase,
    required AddQrCodeUseCase addQrCodeUseCase,
    required DeleteQrCodeUseCase deleteQrCodeUseCase,
  })  : _getQrCodesUseCase = getQrCodesUseCase,
        _addQrCodeUseCase = addQrCodeUseCase,
        _deleteQrCodeUseCase = deleteQrCodeUseCase,
        super(InitialHistoryState()) {
    on<GetHistoryEvent>(_getHistories);
    on<AddHistoryEvent>(_addHistories);
    on<DeleteHistoryEvent>(_deleteHistories);
  }

  void _getHistories(GetHistoryEvent event, Emitter<HistoryState> emit) async {
    try {
      List<QrCodeModel> qrCodes = await _getQrCodesUseCase.call();

      qrCodes.sort((a, b) => b.scannedAt.compareTo(a.scannedAt));

      emit(LoadedHistoryState(qrCodesList: qrCodes));
    } catch (e) {
      emit(ErrorHistoryState(message: e.toString()));
    }
  }

  void _addHistories(AddHistoryEvent event, Emitter<HistoryState> emit) async {
    try {
      await _addQrCodeUseCase.call(
        QrCodeRequest(
          code: event.code,
          scannedAt: DateTime.now().toIso8601String(),
          isGenerated: event.isGenerated ? 1 : 0,
        ),
      );
    } catch (e) {
      emit(ErrorHistoryState(message: e.toString()));
    }
  }

  void _deleteHistories(DeleteHistoryEvent event, Emitter<HistoryState> emit) async {
    try {
      await _deleteQrCodeUseCase.call(event.id);
      add(GetHistoryEvent());
    } catch (e) {
      emit(ErrorHistoryState(message: e.toString()));
    }
  }
}
