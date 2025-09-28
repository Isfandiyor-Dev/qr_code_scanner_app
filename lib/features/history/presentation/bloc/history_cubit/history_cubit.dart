import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryCubit extends Cubit<int> {
  HistoryCubit() : super(0);

  void setIndexPage(int newIndex) => emit(newIndex);
}
