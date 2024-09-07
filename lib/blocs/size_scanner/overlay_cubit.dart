import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OverlayCubit extends Cubit<double> {
  OverlayCubit() : super(_initialCutOutSize);

  static const double _initialCutOutSize = 200.0;
  double cutOutSize = _initialCutOutSize;

  void onPanUpdate({
    required DragUpdateDetails details,
    required BuildContext context,
  }) {
    cutOutSize += details.delta.dy;
    if (cutOutSize < 100) cutOutSize = 100;
    if (cutOutSize > MediaQuery.of(context).size.width - 50) {
      cutOutSize = MediaQuery.of(context).size.width - 50;
    }
    emit(cutOutSize);
  }
}
