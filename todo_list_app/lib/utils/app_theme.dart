import 'package:flutter/material.dart';

class AppTheme {
  static const Color primarySoftBlue = Color(0xFF7CB9E8);
  static const Color secondaryBlue = Color(0xFFA8D8F0);
  static const Color lightBlue = Color(0xFFD4EDFF);
  static const Color veryLightBlue = Color(0xFFF0F8FF);
  static const Color darkBlue = Color(0xFF4A90B8);
  static const Color accentGreen = Color(0xFF5CB85C);
  static const Color accentOrange = Color(0xFFFFA726);
  static const Color accentRed = Color(0xFFEF5350);
  
  static ThemeData lightTheme = ThemeData(
    primaryColor: primarySoftBlue,
    scaffoldBackgroundColor: veryLightBlue,
    colorScheme: ColorScheme.light(
      primary: primarySoftBlue,
      secondary: secondaryBlue,
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primarySoftBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 0.5,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primarySoftBlue,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightBlue, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightBlue, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primarySoftBlue, width: 2.5),
      ),
    ),
  );
  
  static BoxShadow cardShadow = BoxShadow(
    color: primarySoftBlue.withValues(alpha: 0.15),
    blurRadius: 15,
    offset: const Offset(0, 5),
  );
}