import 'package:get_it/get_it.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/local_config.dart';
import '../services/scan_feedback_service.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/history/data_source/data_source/history_data_source.dart';
import '../../features/history/data_source/repository/history_repository.dart';
import '../../features/history/domain/repositories/history_repository.dart';
import '../../features/history/domain/use_cases/add_qr_code_use_case.dart';
import '../../features/history/domain/use_cases/delete_qr_code_use_case.dart';
import '../../features/history/domain/use_cases/get_qr_codes_use_case.dart';
import '../../features/history/presentation/bloc/history/history_bloc.dart';
import '../../features/history/presentation/bloc/history_cubit/history_cubit.dart';
import '../../features/qr_designer/data_source/data_source/logo_file_storage.dart';
import '../../features/qr_designer/data_source/data_source/qr_design_data_source.dart';
import '../../features/qr_designer/data_source/repository/qr_design_repository.dart';
import '../../features/qr_designer/domain/repositories/qr_design_repository.dart';
import '../../features/qr_designer/domain/use_cases/load_qr_design_use_case.dart';
import '../../features/qr_designer/domain/use_cases/save_qr_design_use_case.dart';
import '../../features/qr_designer/presentation/cubit/qr_customization_cubit.dart';
import '../../features/qr_scanner/presentation/bloc/size_scanner/overlay_cubit.dart';
import '../../features/qr_scanner/presentation/bloc/zoom_slider/zoom_camera_cubit.dart';
import '../../features/root/presentation/bloc/navigation_bar/navigation_bar_cubit.dart';

final getIt = GetIt.instance;

/// Registers application services, repositories, use cases, blocs, and cubits.
Future<void> setUpDi() async {
  // Controllers.
  getIt.registerSingleton<MobileScannerController>(MobileScannerController());

  // Configuration and services.
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerLazySingleton(() => LocalConfig(preferences: getIt()));
  getIt.registerLazySingleton(() => ScanFeedbackService(config: getIt()));

  // Data sources.
  getIt.registerLazySingleton(() => HistoryDataSource());
  getIt.registerLazySingleton(() => QrDesignDataSource());
  getIt.registerLazySingleton(() => LogoFileStorage());

  // Repositories.
  getIt.registerLazySingleton<IHistoryRepository>(
    () => HistoryRepositoryImpl(historyDataSource: getIt()),
  );
  getIt.registerLazySingleton<IQrDesignRepository>(
    () => QrDesignRepositoryImpl(dataSource: getIt(), logoStorage: getIt()),
  );

  // Use cases.
  getIt.registerLazySingleton(
    () => GetQrCodesUseCase(historyRepository: getIt()),
  );
  getIt.registerLazySingleton(
    () => AddQrCodeUseCase(historyRepository: getIt()),
  );
  getIt.registerLazySingleton(
    () => DeleteQrCodeUseCase(historyRepository: getIt()),
  );
  getIt.registerLazySingleton(() => LoadQrDesignUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => SaveQrDesignUseCase(repository: getIt()));

  // Blocs and cubits.
  getIt.registerFactory(() => ZoomCameraCubit(getIt()));
  getIt.registerFactory(() => OverlayCubit());
  getIt.registerFactory(() => NavigationBarCubit());
  getIt.registerFactory(() => HistoryCubit());
  getIt.registerFactory(() => SettingsCubit(config: getIt()));
  getIt.registerFactory(
    () => QrCustomizationCubit(
      loadUseCase: getIt(),
      saveUseCase: getIt(),
      repository: getIt(),
    ),
  );

  getIt.registerFactory(
    () => HistoryBloc(
      getQrCodesUseCase: getIt(),
      addQrCodeUseCase: getIt(),
      deleteQrCodeUseCase: getIt(),
    ),
  );
}
