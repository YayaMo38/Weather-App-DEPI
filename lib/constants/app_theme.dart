import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
  inputDecorationTheme: const InputDecorationTheme(
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    filled: false,
  ),
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.white,
  primaryColor: AppColors.lightBlue,
  colorScheme: const ColorScheme.light(
    background: AppColors.white,
    surface: AppColors.white,
    onBackground: AppColors.black,
    onSurface: AppColors.black,
    primary: AppColors.lightBlue,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.lightBlue,
    foregroundColor: AppColors.white,
  ),
  iconTheme: const IconThemeData(color: AppColors.black),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.white,
    selectedItemColor: AppColors.lightBlue,
    unselectedItemColor: AppColors.grey,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.black),
    bodyMedium: TextStyle(color: AppColors.blueGrey),
    bodySmall: TextStyle(color: AppColors.grey),
  ),
  cardColor: AppColors.white,
  dialogTheme: DialogTheme(backgroundColor: AppColors.darkBlue),
);


  static final darkTheme = ThemeData(
  inputDecorationTheme: const InputDecorationTheme(
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    filled: false,
  ),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.darkBlue,
  primaryColor: AppColors.lightBlue,
  colorScheme: const ColorScheme.dark(
    background: AppColors.darkBlue,
    surface: AppColors.darkBlue,
    onBackground: AppColors.white,
    onSurface: AppColors.white,
    primary: AppColors.lightBlue,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.secondaryBlack,
    foregroundColor: AppColors.white,
  ),
  iconTheme: const IconThemeData(color: AppColors.white),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.secondaryBlack,
    selectedItemColor: AppColors.lightBlue,
    unselectedItemColor: AppColors.grey,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.white),
    bodyMedium: TextStyle(color: AppColors.grey),
    bodySmall: TextStyle(color: AppColors.grey),
  ),
  cardColor: AppColors.secondaryBlack,
  dialogTheme: DialogTheme(backgroundColor: AppColors.white),
);

}
