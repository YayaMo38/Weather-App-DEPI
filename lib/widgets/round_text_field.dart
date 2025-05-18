import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants/app_colors.dart';
import '/providers/theme_provider.dart';

class RoundTextField extends ConsumerWidget {
  const RoundTextField({
    super.key,
    this.controller,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLightMode = ref.watch(themeProvider) == ThemeMode.light;
    
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: isLightMode ? AppColors.lightAccentBlue : AppColors.accentBlue,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        style: TextStyle(
          color: isLightMode ? AppColors.darkText : AppColors.white,
        ),
        controller: controller,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          fillColor: Colors.white,
          focusColor: Colors.white,
          prefixIcon: Icon(
            Icons.search,
            color: isLightMode ? AppColors.lightGrey : AppColors.grey,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(
            color: isLightMode ? AppColors.lightGrey : AppColors.grey,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
