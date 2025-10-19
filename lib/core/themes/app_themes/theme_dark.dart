import 'package:flutter/material.dart';
import '../text_themes/text_styles.dart';

class ThemeDark {
  static final ThemeDark instance = ThemeDark._init();

  ThemeDark._init();

  ThemeData get theme => ThemeData(
        fontFamily: 'Lato',
        scaffoldBackgroundColor: const Color(0xFF323232),
        appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
        bottomAppBarTheme: BottomAppBarThemeData(color: Color(0xFF222222)),
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          //Primary
          primary: Color(0xffFFA000),
          onPrimary: Color(0xffD9D9D9),
          primaryContainer: const Color(0xFF272727),
          onPrimaryContainer: Colors.white,

          //Secondary
          secondary: const Color(0xFF333333),
          onSecondary: Colors.white.withValues(alpha: 0.87),
          secondaryContainer: const Color(0xFF2B2B2B),
          onSecondaryContainer: Colors.white,

          //Error
          error: const Color(0xFFFF4949),
          onError: Colors.white.withValues(alpha: 0.7),

          //Surface
          surface: const Color(0xFF363636),
          onSurface: Colors.white.withValues(alpha: 0.87),

          //Outline
          outline: const Color(0xffFFA000),
          outlineVariant: const Color(0xFF979797),

          tertiary: const Color(0xff2D3047),
          tertiaryFixed: Color(0xFF232323),
          tertiaryFixedDim: Color(0xFF3C3C3C),
        ),
        iconTheme: IconThemeData(color: const Color(0xEFFFFFFF)),
        primaryIconTheme: IconThemeData(color: const Color(0xEFFFFFFF)),
        textTheme: AppTextStyles.getTextTheme(
          Color(0xffD9D9D9),
          //Color(0xff2D3047),
        ),
      );
}
