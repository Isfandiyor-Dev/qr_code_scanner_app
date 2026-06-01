import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_text_theme_extension.dart';
import 'package:qr_code_scanner_app/features/qr_scanner/presentation/bloc/zoom_slider/zoom_camera_cubit.dart';

/// Slider control that adjusts the [MobileScannerController] zoom level.
class MyZoomSlider extends StatefulWidget {
  /// Scanner controller to update when zoom changes.
  final MobileScannerController controller;

  /// Creates a scanner zoom slider.
  const MyZoomSlider({super.key, required this.controller});

  @override
  State<MyZoomSlider> createState() => _MyZoomSliderState();
}

class _MyZoomSliderState extends State<MyZoomSlider> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ZoomCameraCubit(widget.controller),
      child: BlocBuilder<ZoomCameraCubit, double>(
        builder: (context, zoom) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    context.read<ZoomCameraCubit>().decrement();
                  },
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Slider(
                    divisions: 20,
                    value: zoom,
                    min: 0,
                    max: 100,
                    label:
                        '${(zoom == 0 ? zoom + 1 : zoom).toStringAsFixed(0)}%',
                    thumbColor: context.colorScheme.primary,
                    activeColor: context.colorScheme.primary,
                    onChanged: (value) {
                      context.read<ZoomCameraCubit>().setZoom(value);
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<ZoomCameraCubit>().increment();
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
