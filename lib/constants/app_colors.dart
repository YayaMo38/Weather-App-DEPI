import 'package:flutter/material.dart';

@immutable
class AppColors {
  // Dark Theme Colors
  //? Blues
  static const Color darkBlue = Color(0xFF0A0B39); // dark blue
  static const Color lightBlue = Color(0xFF1D85E4);
  static const Color accentBlue = Color(0xFF23224A);

  static const Color grey = Color(0xFFB7B6C4);
  static const Color blueGrey = Color(0xFF0A0B39);
  static const Color white = Color(0xFFFFFFFF);

  //! Blacks
  static const Color black = Color(0xFF000000);
  static const Color secondaryBlack = Color(0xFF060620);
  
  // Light Theme Colors
  static const Color lightBg = Color(0xFFEDF2F7);         // Light background with slight blue tint
  static const Color lightSecondaryBg = Color(0xFFFFFFFF); // Crisp white for cards/surfaces
  static const Color lightAccentBlue = Color(0xFFDEEBFD); // Soft blue for containers
  static const Color lightDarkBlue = Color(0xFF3B82F6);   // Vibrant blue for accents
  static const Color primaryBlue = Color(0xFF2563EB);     // Primary blue for buttons/actions
  static const Color skyBlue = Color(0xFF60A5FA);         // Sky blue for gradients
  static const Color lightGrey = Color(0xFF6B7280);       // Grey for secondary text
  static const Color paleGrey = Color(0xFFE5E7EB);        // Pale grey for borders
  static const Color darkText = Color(0xFF1F2937);        // Dark color for text in light mode
  static const Color lightText = Color(0xFF374151);       // Secondary text color for light mode
}
