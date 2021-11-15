import 'package:flutter/material.dart'; import 'package:senetunes/config/AppColors.dart';


class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Montserrat',
    primaryColorLight: white,
    primaryColorDark: white,
    accentColor: Colors.grey,
    primaryColor: primary,
    scaffoldBackgroundColor: Color(0xfff7f8fa),
    tabBarTheme: TabBarTheme(labelColor: Color.fromRGBO(255,255,255,1)),
    appBarTheme: AppBarTheme(
      actionsIconTheme: IconThemeData(color: Color.fromRGBO(255,255,255,1)),
      color: white,
      textTheme: TextTheme(
        headline1: TextStyle(
          color: white,
          fontFamily: 'Montserrat',
        ),
      ),
      iconTheme: IconThemeData(
        color: white,
      ),
    ),
    cardColor: white,
    colorScheme: ColorScheme.light(
      primary: white,
      onPrimary: white,
      primaryVariant: white,
      surface: white,
    ),
    iconTheme: IconThemeData(
      color: white,
    ),
    primaryTextTheme: TextTheme(
      headline1: TextStyle(color: Colors.red, fontSize: 12),
      headline3: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
        color: white,
      ),
      headline5: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
        color: primary,
      ),
    ),
    accentTextTheme: TextTheme(
      subtitle1: TextStyle(color: white, height: 1.5, fontSize: 12),
    ),
    textTheme: TextTheme(
      //  bodyText1: TextStyle(color: white, height: 1.5, fontSize: 12),
      headline1: TextStyle(color: white, fontWeight: FontWeight.w100),
      subtitle1: TextStyle(
        color: white,
        fontSize: 14.0,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Montserrat',
    primaryColorLight: white,
    primaryColorDark: white,
    accentColor: Colors.grey,
    scaffoldBackgroundColor: Color(0xff131722),
    primaryColor: primary,
    appBarTheme: AppBarTheme(
      color: surface,
      textTheme: TextTheme(
        headline1: TextStyle(
          color: white,
        ),
      ),
      iconTheme: IconThemeData(
        color: white,
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: white,
      onPrimary: white,
      primaryVariant: white,
      surface: surface,
    ),
    cardColor: surface,
    iconTheme: IconThemeData(
      color: white,
    ),
    primaryTextTheme: TextTheme(
      headline1: TextStyle(color: Colors.red, fontSize: 12),
      headline3: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: white,
      ),
      headline5: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
        color: primary,
      ),
    ),
    accentTextTheme: TextTheme(
      subtitle1: TextStyle(color: white, height: 1.5, fontSize: 12),
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
        color: white,
      ),
      subtitle1: TextStyle(
        color: white,
        fontSize: 14.0,
      ),
    ),
  );
}


class InputDecorationStyle {
  static InputDecoration get defaultStyle => InputDecoration(
    focusColor: Colors.blue,
    labelStyle: TextStyle(color: Colors.white, fontSize: 22),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    disabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    // filled: true,fillColor: Colors.red,
    // labelText: $t(context, 'email'),

  );
}