import 'package:flutter/material.dart';

class AppTextStyles {
  static TextTheme getTextTheme(Color color) => TextTheme(
        //DISPLAY
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: color,
          fontFamily: 'Itim',
        ),
        displayMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: color,
          fontFamily: 'Itim',
        ),
        displaySmall: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: color,
          fontFamily: 'Itim',
        ),

        //HEADLINE
        headlineLarge: TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.bold,
          color: color,
          fontFamily: 'Itim',
        ),
        headlineMedium: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: color,
          fontFamily: 'Itim',
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          color: color,
          fontFamily: 'Itim',
        ),

        //TITLE
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: color,
          fontFamily: 'Itim',
        ),
        titleMedium: TextStyle(
          fontSize: 20,
          color: color,
          fontFamily: 'Itim',
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          color: color,
          fontFamily: 'Itim',
        ),

        //BODY
        bodyLarge: TextStyle(
          fontSize: 16,
          color: color,
          fontFamily: 'Itim',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: color,
          fontFamily: 'Itim',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: color,
          fontFamily: 'Itim',
        ),

        //LABEL
        labelLarge: TextStyle(
          fontSize: 16,
          color: color,
          fontFamily: 'Itim',
        ),
        labelMedium: TextStyle(
          fontSize: 14,
          color: color,
          fontFamily: 'Itim',
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          color: color,
          fontFamily: 'Itim',
        ),
      );
}
