import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/core/bloc/bloc_scope/bloc_scope.dart';
import 'package:qr_code_scanner_app/core/di/di.dart';
import 'package:qr_code_scanner_app/core/themes/app_themes/theme_dark.dart';
import 'package:qr_code_scanner_app/features/splash/splash_screen.dart';

/// Initializes app dependencies and launches the Flutter application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpDi();
  runApp(const BlocScope(child: MainApp()));
}

/// Root application widget that configures the global theme and first screen.
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
