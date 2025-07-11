import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue
    ),
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.blueGrey,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blueGrey,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}
