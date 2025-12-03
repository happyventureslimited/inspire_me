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
      onSecondary: const Color(0xFFF5F5F5),
      tertiary: const Color(0xFFF5F5F5),
      onTertiaryFixed: Color(0xFFCFCFCF),
    ),

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Color(0xFFD6952D),
      titleTextStyle: TextStyle(color: Color(0xFFF5F5F5), fontSize: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      iconTheme: IconThemeData(color: Color(0xFFF5F5F5), size: 22),
    ),

    cardTheme: CardThemeData(
      color: Color(0xFFF5F5F5),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    fontFamily: 'Fredoka',
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.dark(
      surface: const Color(0xFF1A1A1A),
      onSurface: const Color(0xFFE6E6E6), 
      primary: const Color(0xFFD6952D,),
      onPrimary: const Color(0xFF000000),
      secondary: const Color(0xFFFFB132),
      onSecondary: const Color(0xFF2A2A2A),
      tertiary: const Color(0xFF222222),
      onTertiaryFixed: const Color(0xFF1D1D1D),
    ),

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Color(0xFFD6952D),
      titleTextStyle: TextStyle(color: Color(0xFF222222), fontSize: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      iconTheme: IconThemeData(color: Color(0xFF222222), size: 22),
    ),

    cardTheme: CardThemeData(
      color: Color(0xFF222222),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
