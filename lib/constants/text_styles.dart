import 'package:flutter/material.dart';

import '/constants/app_colors.dart';

@immutable
class TextStyles {
  // Dark theme text styles
  static const h1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static const h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const h3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const subtitleText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );

  static const largeSubtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.white70,
  );
  
  // Light theme text styles
  static const lightH1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.darkText,
    shadows: [
      Shadow(
        offset: Offset(0, 1),
        blurRadius: 2.0,
        color: Color.fromRGBO(0, 0, 0, 0.1),
      ),
    ],
  );

  static const lightH2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.darkText,
    shadows: [
      Shadow(
        offset: Offset(0, 1),
        blurRadius: 1.0,
        color: Color.fromRGBO(0, 0, 0, 0.1),
      ),
    ],
  );

  static const lightH3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.darkText,
  );

  static const lightSubtitleText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.lightGrey,
  );

  static const lightLargeSubtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.black54,
  );
  
  // Helper method to get the appropriate text style based on theme mode
  static TextStyle getStyle(TextStyle darkStyle, TextStyle lightStyle, bool isLightMode) {
    return isLightMode ? lightStyle : darkStyle;
  }
}
