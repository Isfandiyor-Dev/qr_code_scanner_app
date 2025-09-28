import 'package:get_it/get_it.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../features/history/data_source/data_source/history_data_source.dart';
import '../../features/history/data_source/repository/history_repository.dart';
import '../../features/history/domain/repositories/history_repository.dart';
import '../../features/history/domain/use_cases/add_qr_code_use_case.dart';
import '../../features/history/domain/use_cases/delete_qr_code_use_case.dart';
import '../../features/history/domain/use_cases/get_qr_codes_use_case.dart';
import '../../features/history/presentation/bloc/history/history_bloc.dart';
import '../../features/history/presentation/bloc/history_cubit/history_cubit.dart';
import '../../features/permissions/di_container.dart';
import '../../features/qr_scanner/presentation/bloc/size_scanner/overlay_cubit.dart';
import '../../features/qr_scanner/presentation/bloc/zoom_slider/zoom_camera_cubit.dart';
import '../../features/root/presentation/bloc/navigation_bar/navigation_bar_cubit.dart';

final getIt = GetIt.instance;

void setUp() {
  //CONTROLLERS
  getIt.registerSingleton<MobileScannerController>(MobileScannerController());

  //DATA SOURCES
  getIt.registerLazySingleton(() => HistoryDataSource());

  //REPOSITORIES
  getIt.registerLazySingleton<IHistoryRepository>(
    () => HistoryRepositoryImpl(historyDataSource: getIt()),
  );

  //USE CASES
  getIt.registerLazySingleton(
    () => GetQrCodesUseCase(historyRepository: getIt()),
  );
  getIt.registerLazySingleton(
    () => AddQrCodeUseCase(historyRepository: getIt()),
  );
  getIt.registerLazySingleton(
    () => DeleteQrCodeUseCase(historyRepository: getIt()),
  );

  //BLOC AND CUBITS
  getIt.registerFactory(() => ZoomCameraCubit(getIt()));
  getIt.registerFactory(() => OverlayCubit());
  getIt.registerFactory(() => NavigationBarCubit());
  getIt.registerFactory(() => HistoryCubit());

  getIt.registerFactory(
    () => HistoryBloc(
      getQrCodesUseCase: getIt(),
      addQrCodeUseCase: getIt(),
      deleteQrCodeUseCase: getIt(),
    ),
  );

  setUpPermission();
}
