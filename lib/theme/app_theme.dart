import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    fontFamily: 'Fredoka',
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.light(
      surface: const Color(0xFFFFF8EF),
      onSurface: Color(0xFF444444),
      primary: const Color(0xFFD6952D),
      onPrimary: const Color(0xFFFFFFFF),
      secondary: const Color(0xFFFFB132),
      onSecondary: Color(0xFF555555),
      // onSecondaryFixed: const Color(0xFFBEBEBE),
      tertiary: const Color(0xFFF5F5F5),
      onTertiaryFixed: Color(0xFFCFCFCF)
    ),

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Color(0xFFD6952D),
      titleTextStyle: TextStyle(color: Color(0xFFF5F5F5), fontSize: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15)
        )
      ),
      iconTheme: IconThemeData(color: Color(0xFFF5F5F5), size: 22),
    ),

    cardTheme: CardThemeData(
      color: Color(0xFFF5F5F5),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
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
    fontFamily: 'Fredoka',
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
