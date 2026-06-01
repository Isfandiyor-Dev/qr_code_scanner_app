import 'package:bloc/bloc.dart';

/// Stores the selected root navigation index.
class NavigationBarCubit extends Cubit<int> {
  /// Creates a navigation cubit with the scanner tab selected.
  NavigationBarCubit() : super(0);

  /// Updates the selected root navigation index.
  void toggleBarBtn(int index) {
    emit(index);
  }
}
