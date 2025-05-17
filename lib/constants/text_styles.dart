import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle h1(BuildContext context) => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white,
      );

  static TextStyle h2(BuildContext context) => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white,
      );

  static TextStyle h3(BuildContext context) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white,
      );

  static TextStyle subtitleText(BuildContext context) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
      );

  static TextStyle largeSubtitle(BuildContext context) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7) ?? Colors.white70,
      );
}
