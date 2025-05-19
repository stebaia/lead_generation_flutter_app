import 'package:flutter/material.dart';

class ThemeHelper {
  static Color background = Color(0xffF3F5F9);
  static Color backgroundDark = Color(0xff1F1F1F);
  static Color primaryColor = Color.fromARGB(255, 0, 194, 103);

  static ThemeData myThemeData(bool isDarkTheme, BuildContext buildContext) {
    return ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.green,
        fontFamily: 'Poppins',
        primaryColor: primaryColor,
        textTheme: myTextTheme(isDarkTheme, buildContext),
        colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light());
  }

  static TextTheme myTextTheme(bool isDarkTheme, BuildContext context) {
    return TextTheme(
      bodyLarge: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
      displayLarge: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
      displayMedium:
          TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
      bodyMedium: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
      titleMedium: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
    );
  }
}
