import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_app/blocs/history/history_event.dart';
import 'package:qr_code_scanner_app/blocs/history/history_state.dart';
import 'package:qr_code_scanner_app/data/models/scan_qr/scan_qr_model.dart';
import 'package:qr_code_scanner_app/data/repositories/history_repository.dart';

class HistoryBloc extends Bloc<HistoryEvents, HistoryState> {
  final HistoryRepository _historyRepository;

  HistoryBloc({required HistoryRepository historyRepository})
      : _historyRepository = historyRepository,
        super(InitialHistoryState()) {
    on<GetHistoryEvent>(_getHistories);
    on<AddHistoryEvent>(_addHistories);
    on<DeleteHistoryEvent>(_deleteHistories);
  }

  void _getHistories(GetHistoryEvent event, Emitter<HistoryState> emit) async {
    emit(LoadingHistoryState());
    try {
      // get
      List<ScanQrModel> qrCodes = await _historyRepository.getQrCodes();
      emit(LoadedHistoryState(qrCodesList: qrCodes));
    } catch (e) {
      print("Error on receiving histories $e");
      emit(ErrorHistoryState(message: e.toString()));
    }
  }

  void _addHistories(AddHistoryEvent event, Emitter<HistoryState> emit) async {
    emit(LoadingHistoryState());
    try {
      // add
      await _historyRepository.addQrCode(event.code);
    } catch (e) {
      print("Error on adding histories $e");
      emit(ErrorHistoryState(message: e.toString()));
    }
  }

  void _deleteHistories(
      DeleteHistoryEvent event, Emitter<HistoryState> emit) async {
    emit(LoadingHistoryState());
    try {
      // delete
      await _historyRepository.deleteQrCode(event.id);
      List<ScanQrModel> qrCodes = await _historyRepository.getQrCodes();
      emit(LoadedHistoryState(qrCodesList: qrCodes));
    } catch (e) {
      print("Error on deleting histories $e");
      emit(ErrorHistoryState(message: e.toString()));
    }
  }
}
