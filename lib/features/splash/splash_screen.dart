// import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner_app/features/root/presentation/screens/screens_manager.dart';
import 'package:svg_flutter/svg.dart';

import '../../core/di/di.dart';
// import '../../core/enum/result_screen.dart';
// import '../../core/widgets/snackbar.dart';
// import '../history/presentation/bloc/history/history_bloc.dart';
// import '../history/presentation/bloc/history/history_event.dart';
// import '../result_screen/presentation/result_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final controller = getIt.get<MobileScannerController>();

  @override
  void initState() {
    super.initState();
    // _checkIntentData();
    Future.delayed(Duration(seconds: 2), () => _navigateToHome());
  }

  // Future<void> _checkIntentData() async {
  //   const platform = MethodChannel('com.example.qrcode/intent');
  //   try {
  //     final imagePath = await platform.invokeMethod<String>('getIntentData');
  //     log("ImagePath  v1: $imagePath");
  //     if (imagePath != null) {
  //       log("ImagePath v2: $imagePath");
  //       try {
  //         final result = await controller.analyzeImage(imagePath);
  //         if (result != null && result.barcodes.length == 1) {
  //           log("Result: $result");
  //           controller.stop();
  //           String code = result.barcodes.first.rawValue!;
  //           BlocProvider.of<HistoryBloc>(context).add(
  //             AddHistoryEvent(code: code, isGenerated: false),
  //           );
  //           await Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (ctx) => ResultPage(
  //                 qrCode: code,
  //                 fromScreen: FromScreenEnum.scanned,
  //               ),
  //             ),
  //           );
  //           controller.start();
  //         } else {
  //           throw "The image could not be scanned. Please make sure the image is clear and contains a valid QR code.";
  //         }
  //       } catch (e) {
  //         log("Error analyzing image: $e");
  //         showErrorSnackBar(e.toString(), context);
  //       }
  //     } else {
  //       _navigateToHome();
  //     }
  //   } catch (e) {
  //     log("Error getting image: $e");
  //     // showErrorSnackBar(e.toString(), context);
  //     _navigateToHome();
  //   }
  // }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ScreensManager()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          'assets/icons/logo.svg',
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}
