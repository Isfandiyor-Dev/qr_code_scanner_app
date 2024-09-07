import 'package:get_it/get_it.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

final getIt = GetIt.instance;

void setUp() {
  getIt.registerSingleton<MobileScannerController>(MobileScannerController());
}
