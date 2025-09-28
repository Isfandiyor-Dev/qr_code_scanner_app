import 'package:flutter/material.dart';

class ThemeDark {
  static final ThemeDark instance = ThemeDark._init();

  ThemeDark._init();

  ThemeData get theme => ThemeData(
        scaffoldBackgroundColor: const Color(0xFF282828),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xffD9D9D9),
        ),
        fontFamily: 'Itim',
      );
}
