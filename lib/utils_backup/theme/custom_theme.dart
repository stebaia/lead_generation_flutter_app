import 'package:flutter/material.dart';

class ThemeHelper {
  static Color background = Color(0xffF3F5F9);
  static Color backgroundDark = Color(0xff1F1F1F);
  static Color primaryColor = Color.fromARGB(255, 255, 191, 15);

  static ThemeData myThemeData(bool isDarkTheme, BuildContext buildContext) {
    return ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.orange,
        fontFamily: 'Poppins',
        primaryColor: primaryColor,
        textTheme: myTextTheme(isDarkTheme, buildContext),
        backgroundColor: isDarkTheme ? backgroundDark : background);
  }

  static TextTheme myTextTheme(bool isDarkTheme, BuildContext context) {
    return TextTheme(
      bodyText1: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
      headline1: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
      headline2: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
      bodyText2: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
      subtitle1: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
    );
  }
}
