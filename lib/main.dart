import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/core/bloc/bloc_scope.dart';
import 'package:qr_code_scanner_app/core/theme/app_theme/theme_dark.dart';
import 'package:qr_code_scanner_app/core/di/di.dart';
import 'package:qr_code_scanner_app/features/splash/splash_screen.dart';

void main() {
  setUp();
  runApp(const BlocScope(child: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeDark.instance.theme,
      home: const SplashScreen(),
    );
  }
}
