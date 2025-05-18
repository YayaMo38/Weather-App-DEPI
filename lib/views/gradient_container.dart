import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants/app_colors.dart';
import '/providers/theme_provider.dart';

class GradientContainer extends ConsumerWidget {
  const GradientContainer({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLightMode = ref.watch(themeProvider) == ThemeMode.light;
    final screenSize = MediaQuery.of(context).size;
    
    return SafeArea(
      child: Container(
        height: screenSize.height,
        width: screenSize.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: isLightMode 
            ? [
                AppColors.lightBg,
                AppColors.lightSecondaryBg.withOpacity(.95),
                AppColors.lightSecondaryBg,
                AppColors.lightSecondaryBg,
                AppColors.lightSecondaryBg.withOpacity(.98),
                AppColors.lightAccentBlue.withOpacity(.7),
                AppColors.lightAccentBlue.withOpacity(.6),
                AppColors.lightAccentBlue.withOpacity(.5),
                AppColors.skyBlue.withOpacity(.3),
                AppColors.skyBlue.withOpacity(.2),
                AppColors.skyBlue.withOpacity(.1),
                AppColors.primaryBlue.withOpacity(.05),
              ]
            : [
                AppColors.black,
                AppColors.secondaryBlack,
                AppColors.secondaryBlack.withOpacity(.99),
                AppColors.secondaryBlack.withOpacity(.98),
                AppColors.secondaryBlack.withOpacity(.97),
                AppColors.secondaryBlack.withOpacity(.96),
                AppColors.secondaryBlack.withOpacity(.95),
                AppColors.secondaryBlack.withOpacity(.94),
                AppColors.secondaryBlack.withOpacity(.93),
                AppColors.secondaryBlack.withOpacity(.92),
                AppColors.secondaryBlack.withOpacity(.91),
                AppColors.secondaryBlack.withOpacity(.90),
                AppColors.darkBlue,
                AppColors.accentBlue,
                AppColors.lightBlue,
              ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 36.0,
          ),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(children),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
