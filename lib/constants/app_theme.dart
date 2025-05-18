import 'package:flutter/material.dart';
import '/constants/app_colors.dart';

class AppTheme {
  // Dark theme data
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkBlue,
    scaffoldBackgroundColor: AppColors.black,
    cardColor: AppColors.accentBlue,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.lightBlue,
      secondary: AppColors.accentBlue,
      background: AppColors.black,
      surface: AppColors.secondaryBlack,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.white),
      bodyMedium: TextStyle(color: AppColors.white),
      titleLarge: TextStyle(color: AppColors.white),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.secondaryBlack,
      foregroundColor: AppColors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.secondaryBlack,
      selectedItemColor: AppColors.lightBlue,
      unselectedItemColor: AppColors.grey,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AppColors.secondaryBlack,
      indicatorColor: Colors.transparent,
    ),
  );
  // Light theme data
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.lightBg,
    cardColor: AppColors.lightSecondaryBg,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryBlue,
      secondary: AppColors.skyBlue,
      tertiary: AppColors.lightDarkBlue,
      background: AppColors.lightBg,
      surface: AppColors.lightSecondaryBg,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onBackground: AppColors.darkText,
      onSurface: AppColors.darkText,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkText, fontSize: 16),
      bodyMedium: TextStyle(color: AppColors.darkText, fontSize: 14),
      titleLarge: TextStyle(color: AppColors.darkText, fontWeight: FontWeight.bold, fontSize: 20),
      titleMedium: TextStyle(color: AppColors.darkText, fontWeight: FontWeight.w600, fontSize: 18),
      titleSmall: TextStyle(color: AppColors.darkText, fontWeight: FontWeight.w500, fontSize: 16),
      labelLarge: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w500),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightSecondaryBg,
      foregroundColor: AppColors.darkText,
      elevation: 0,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightSecondaryBg,
      selectedItemColor: AppColors.primaryBlue,
      unselectedItemColor: AppColors.lightGrey,
          ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.lightSecondaryBg,
      indicatorColor: AppColors.lightAccentBlue,
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(color: AppColors.darkText, fontSize: 12)
      ),
    ),
  );
}
