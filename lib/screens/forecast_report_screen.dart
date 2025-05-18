import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants/app_colors.dart';
import '/constants/text_styles.dart';
import '/extensions/datetime.dart';
import '/providers/theme_provider.dart';
import '/views/gradient_container.dart';
import '/views/hourly_forecast_view.dart';
import '/views/weekly_forecast_view.dart';

class ForecastReportScreen extends ConsumerWidget {
  const ForecastReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLightMode = ref.watch(themeProvider) == ThemeMode.light;
    final textColor = isLightMode ? AppColors.darkText : AppColors.white;

    return GradientContainer(
      children: [
        // Page Title
        Align(
          alignment: Alignment.center,
          child: Text(
            'Forecast Report',
            style: isLightMode ? TextStyles.lightH1.copyWith(color: AppColors.darkText) : TextStyles.h1,
          ),
        ),

        const SizedBox(height: 40),

        // Today's date
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today',
              style: isLightMode ? TextStyles.lightH2.copyWith(color: AppColors.darkText) : TextStyles.h2,
            ),
            Text(
              DateTime.now().dateTime,
              style: isLightMode ? TextStyles.lightSubtitleText.copyWith(color: AppColors.darkText.withOpacity(0.7)) : TextStyles.subtitleText,
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Today's forecast
        HourlyForecastView(isLightMode: isLightMode),

        const SizedBox(height: 20),

        // Next Forecast
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Next Forecast',
              style: isLightMode ? TextStyles.lightH2.copyWith(color: AppColors.darkText) : TextStyles.h2,
            ),
            Icon(
              Icons.calendar_month_rounded,
              color: textColor,
            ),
          ],
        ),

        const SizedBox(height: 30),

        // Weekly forecast
        WeeklyForecastView(),
      ],
    );
  }
}
