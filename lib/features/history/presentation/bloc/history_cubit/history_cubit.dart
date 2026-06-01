import 'package:flutter_bloc/flutter_bloc.dart';

/// Stores the selected tab index on the History screen.
class HistoryCubit extends Cubit<int> {
  /// Creates a history tab cubit with the Scan tab selected.
  HistoryCubit() : super(0);

  /// Updates the selected history tab index.
  void setIndexPage(int newIndex) => emit(newIndex);
}
