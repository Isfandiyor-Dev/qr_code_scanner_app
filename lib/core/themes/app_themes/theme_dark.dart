import 'package:flutter/material.dart';
import '../text_themes/text_styles.dart';

/// Dark application theme configuration.
class ThemeDark {
  static final ThemeDark instance = ThemeDark._init();

  ThemeDark._init();

  /// The app-wide dark [ThemeData].
  ThemeData get theme => ThemeData(
        fontFamily: 'Lato',
        // image_00e2a1.jpg dagi dark fon uslubiga mos, chuqur to'q ko'k-kulrang
        scaffoldBackgroundColor: const Color(0xFF12141D),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
        bottomAppBarTheme: const BottomAppBarThemeData(color: Color(0xFF1D2029)),
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          // Desaturated (saturatsiyasi pasaytirilgan) professional Indigo/Ko'k rang
          primary: const Color(0xFF6366F1),
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFF1D2029),
          onPrimaryContainer: Colors.white,
          secondary: const Color(0xFF1E293B),
          onSecondary: Colors.white.withValues(alpha: 0.87),
          secondaryContainer: const Color(0xFF262A37),
          onSecondaryContainer: Colors.white,
          error: const Color(0xFFEF4444), // Desaturated qizil
          onError: Colors.white.withValues(alpha: 0.7),
          surface: const Color(0xFF1D2029), // Fon qismlari uchun
          onSurface: Colors.white.withValues(alpha: 0.87),
          // Outline ham asosiy desaturated rangga moslandi
          outline: const Color(0xFF6366F1),
          outlineVariant: const Color(0xFF475569),
          tertiary: const Color(0xFF334155),
          tertiaryFixed: const Color(0xFF1D2029),
          tertiaryFixedDim: const Color(0xFF2D3748),
        ),
        iconTheme: const IconThemeData(color: Color(0xEFFFFFFF)),
        primaryIconTheme: const IconThemeData(color: Color(0xEFFFFFFF)),
        textTheme: AppTextStyles.getTextTheme(
          const Color(0xffE2E8F0), // Matn uchun o'ta oq emas, biroz yumshatilgan oq
        ),
      );
}

// import 'package:flutter/material.dart';
// import '../text_themes/text_styles.dart';

// /// Dark application theme configuration.
// class ThemeDark {
//   static final ThemeDark instance = ThemeDark._init();

//   ThemeDark._init();

//   /// The app-wide dark [ThemeData].
//   ThemeData get theme => ThemeData(
//         fontFamily: 'Lato',
//         scaffoldBackgroundColor: const Color(0xFF323232),
//         appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
//         bottomAppBarTheme: BottomAppBarThemeData(color: Color(0xFF222222)),
//         colorScheme: ColorScheme(
//           brightness: Brightness.dark,
//           primary: Color(0xffFFA000),
//           onPrimary: Color(0xffD9D9D9),
//           primaryContainer: const Color(0xFF272727),
//           onPrimaryContainer: Colors.white,
//           secondary: const Color(0xFF333333),
//           onSecondary: Colors.white.withValues(alpha: 0.87),
//           secondaryContainer: const Color(0xFF2B2B2B),
//           onSecondaryContainer: Colors.white,
//           error: const Color(0xFFFF4949),
//           onError: Colors.white.withValues(alpha: 0.7),
//           surface: const Color(0xFF363636),
//           onSurface: Colors.white.withValues(alpha: 0.87),
//           outline: const Color(0xffFFA000),
//           outlineVariant: const Color(0xFF979797),
//           tertiary: const Color(0xff2D3047),
//           tertiaryFixed: Color(0xFF232323),
//           tertiaryFixedDim: Color(0xFF3C3C3C),
//         ),
//         iconTheme: IconThemeData(color: const Color(0xEFFFFFFF)),
//         primaryIconTheme: IconThemeData(color: const Color(0xEFFFFFFF)),
//         textTheme: AppTextStyles.getTextTheme(
//           Color(0xffD9D9D9),
//         ),
//       );
// }
