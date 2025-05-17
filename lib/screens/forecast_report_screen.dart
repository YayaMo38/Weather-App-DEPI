import 'package:flutter/material.dart';

import '/constants/text_styles.dart';
import '/extensions/datetime.dart';
import '/views/gradient_container.dart';
import '/views/hourly_forecast_view.dart';
import '/views/weekly_forecast_view.dart';

class ForecastReportScreen extends StatelessWidget {
  const ForecastReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GradientContainer(
      children: [
        // Page Title
        Align(
          alignment: Alignment.center,
          child: Text(
            'Forecast Report',
            style: TextStyles.h1(context),
          ),
        ),

        const SizedBox(height: 40),

        // Today's date
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today',
              style: TextStyles.h2(context),
            ),
            Text(
              DateTime.now().dateTime,
              style: TextStyles.subtitleText(context),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Today's forecast
        const HourlyForecastView(),

        const SizedBox(height: 20),

        // Next Forecast
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Next Forecast',
              style: TextStyles.h2(context),
            ),
            Icon(
              Icons.calendar_month_rounded,
              color: theme.iconTheme.color,
            ),
          ],
        ),

        const SizedBox(height: 30),

        // Weekly forecast
        const WeeklyForecastView(),
      ],
    );
  }
}
