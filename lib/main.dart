import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner_app/blocs/history/history_bloc.dart';
import 'package:qr_code_scanner_app/blocs/navigation_bar/navigation_bar_cubit.dart';
import 'package:qr_code_scanner_app/blocs/size_scanner/overlay_cubit.dart';
import 'package:qr_code_scanner_app/blocs/zoom_slider/zoom_camera_cubit.dart';
import 'package:qr_code_scanner_app/data/repositories/history_repository.dart';
import 'package:qr_code_scanner_app/services/history_service.dart';
import 'package:qr_code_scanner_app/ui/screens/screens_manager.dart';
import 'package:qr_code_scanner_app/utils/di.dart';

void main() {
  setUp();
  final HistoryService historyService = HistoryService();

  runApp(
    RepositoryProvider(
      create: (context) => HistoryRepository(
        historyService: historyService,
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ZoomCameraCubit(getIt.get<MobileScannerController>()),
          ),
          BlocProvider(
            create: (context) => OverlayCubit(),
          ),
          BlocProvider(
            create: (context) => NavigationBarCubit(),
          ),
          BlocProvider(
            create: (context) => HistoryBloc(
              historyRepository: context.read<HistoryRepository>(),
            ),
          ),
        ],
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScreensManager(),
    );
  }
}
