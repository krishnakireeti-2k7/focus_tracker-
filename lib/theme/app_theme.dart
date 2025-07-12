import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      displayMedium: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      filled: true,
      fillColor: Colors.grey[100],
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 16),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.1),
    ),
  );

  static final darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}
