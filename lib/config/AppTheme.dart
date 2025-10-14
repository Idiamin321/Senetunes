import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Montserrat',
    primaryColor: primary,
    scaffoldBackgroundColor: const Color(0xfff7f8fa),
    tabBarTheme: const TabBarTheme(labelColor: Color.fromRGBO(255, 255, 255, 1)),
    appBarTheme: const AppBarTheme(
      backgroundColor: white,
      foregroundColor: white,
      elevation: 0,
      iconTheme: IconThemeData(color: white),
      titleTextStyle: TextStyle(
        color: white,
        fontFamily: 'Montserrat',
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardColor: white,
    colorScheme: const ColorScheme.light(
      primary: primary,
      onPrimary: white,
      surface: white,
      onSurface: Colors.black87,
      secondary: Colors.grey,
      onSecondary: white,
    ),
    iconTheme: const IconThemeData(color: white),
    primaryTextTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.red, fontSize: 12),
      headlineSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
        color: white,
      ),
      labelLarge: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
        color: primary,
      ),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(color: white, fontWeight: FontWeight.w100),
      titleMedium: TextStyle(color: white, fontSize: 14.0),
      bodyMedium: TextStyle(color: Colors.black87, fontSize: 14),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Montserrat',
    scaffoldBackgroundColor: const Color(0xff131722),
    primaryColor: primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      foregroundColor: white,
      elevation: 0,
      iconTheme: IconThemeData(color: white),
      titleTextStyle: TextStyle(
        color: white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: primary,
      onPrimary: white,
      surface: surface,
      onSurface: white,
      secondary: Colors.grey,
      onSecondary: white,
    ),
    cardColor: surface,
    iconTheme: const IconThemeData(color: white),
    primaryTextTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.red, fontSize: 12),
      headlineSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: white,
      ),
      labelLarge: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
        color: primary,
      ),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(color: white),
      titleMedium: TextStyle(color: white, fontSize: 14.0),
      bodyMedium: TextStyle(color: white, fontSize: 14),
    ),
  );
}

class InputDecorationStyle {
  static InputDecoration get defaultStyle => const InputDecoration(
    focusColor: Colors.blue,
    labelStyle: TextStyle(color: Colors.white, fontSize: 22),
    errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  );
}
