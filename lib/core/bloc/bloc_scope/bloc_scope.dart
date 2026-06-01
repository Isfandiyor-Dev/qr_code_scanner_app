import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_app/core/di/di.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history/history_bloc.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history_cubit/history_cubit.dart';
import 'package:qr_code_scanner_app/features/qr_scanner/presentation/bloc/size_scanner/overlay_cubit.dart';
import 'package:qr_code_scanner_app/features/qr_scanner/presentation/bloc/zoom_slider/zoom_camera_cubit.dart';
import 'package:qr_code_scanner_app/features/root/presentation/bloc/navigation_bar/navigation_bar_cubit.dart';

/// Provides the application-wide blocs and cubits used by the main navigation.
class BlocScope extends StatelessWidget {
  /// The widget subtree that can read the registered bloc providers.
  final Widget child;

  /// Creates a scope that injects shared bloc dependencies above [child].
  const BlocScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<ZoomCameraCubit>()),
        BlocProvider(create: (context) => getIt<OverlayCubit>()),
        BlocProvider(create: (context) => getIt<NavigationBarCubit>()),
        BlocProvider(create: (context) => getIt<HistoryBloc>()),
        BlocProvider(create: (context) => getIt<HistoryCubit>()),
      ],
      child: child,
    );
  }
}
