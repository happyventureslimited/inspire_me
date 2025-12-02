import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: Colors.indigo,
    visualDensity: VisualDensity.adaptivePlatformDensity,

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: Colors.indigo,
    visualDensity: VisualDensity.adaptivePlatformDensity,

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
