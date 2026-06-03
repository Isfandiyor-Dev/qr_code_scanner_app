import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_app/core/bloc/bloc_scope/bloc_scope.dart';
import 'package:qr_code_app/core/di/di.dart';
import 'package:qr_code_app/core/themes/app_themes/theme_dark.dart';
import 'package:qr_code_app/features/splash/splash_screen.dart';

/// Initializes app dependencies and launches the Flutter application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize dependency injection
  await setUpDi();

  /// Lock the app to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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


///npx create-docusaurus@latest qr-docs classic
///iltimos Docusaurusga ko'p tillik ham qo'shilsin.
/*
[SUCCESS] Created qr-docs.
[INFO] Inside that directory, you can run several commands:

  `npm start`
    Starts the development server.

  `npm run build`
    Bundles your website into static files for production.

  `npm run serve`
    Serves the built website locally.

  `npm run deploy`
    Publishes the website to GitHub pages.

We recommend that you begin by typing:

  `cd qr-docs`
  `npm start`

Happy building awesome websites!
*/