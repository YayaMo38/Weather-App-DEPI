import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants/app_colors.dart';
import '/constants/text_styles.dart';
import '/extensions/datetime.dart';
import '/extensions/temperature_extensions.dart'; // Add this import
import '/providers/get_weekly_forecast_provider.dart';
import '/providers/temperature_unit_provider.dart'; // Add this import
import '/providers/theme_provider.dart'; // Import theme provider
import '/utils/get_weather_icons.dart';
import '/widgets/subscript_text.dart';

class WeeklyForecastView extends ConsumerWidget {
  const WeeklyForecastView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyForecast = ref.watch(weeklyForecastProvider);
    final temperatureUnit = ref.watch(temperatureUnitProvider); // For temperature conversion
    final themeMode = ref.watch(themeProvider); // For checking light/dark mode
    final isLightMode = themeMode == ThemeMode.light;

    return weeklyForecast.when(
      data: (weatherData) {
        return ListView.builder(
          itemCount: weatherData.daily.weatherCode.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final dayOfWeek =
                DateTime.parse(weatherData.daily.time[index]).dayOfWeek;
            final date = weatherData.daily.time[index];
            final temp = weatherData.daily.temperature2mMax[index];
            final icon = weatherData.daily.weatherCode[index];

            return WeeklyForecastTile(
              date: date,
              day: dayOfWeek,
              icon: getWeatherIcon2(icon),
              temp: temp.round(),
              temperatureUnit: temperatureUnit,
              isLightMode: isLightMode, // Pass light mode info
            );
          },
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text(
            error.toString(),
          ),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class WeeklyForecastTile extends StatelessWidget {
  const WeeklyForecastTile({
    super.key,
    required this.day,
    required this.date,
    required this.temp,
    required this.icon,
    required this.temperatureUnit,
    required this.isLightMode,
  });

  final String day;
  final String date;
  final int temp;
  final String icon;
  final TemperatureUnit temperatureUnit;
  final bool isLightMode;

  @override
  Widget build(BuildContext context) {
    // Convert temperature if needed
    final displayTemp = temperatureUnit == TemperatureUnit.celsius
        ? temp
        : (temp * 9 / 5 + 32).round();
    final unitSymbol = temperatureUnit == TemperatureUnit.celsius ? '°C' : '°F';

    // Set color based on theme
    final textColor = isLightMode ? AppColors.darkText : AppColors.white;
    final bgColor = isLightMode ? AppColors.lightSecondaryBg : AppColors.accentBlue;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: bgColor,
        boxShadow: isLightMode ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                day,
                style: isLightMode
                    ? TextStyles.lightH3.copyWith(color: textColor)
                    : TextStyles.h3,
              ),
              const SizedBox(height: 5),
              Text(
                date,
                style: isLightMode
                    ? TextStyles.lightSubtitleText.copyWith(color: textColor.withOpacity(0.7))
                    : TextStyles.subtitleText,
              ),
            ],
          ),

          // Temperature
          SuperscriptText(
            text: '$displayTemp',
            color: isLightMode ? AppColors.darkText : AppColors.white,
            superScript: unitSymbol,
            superscriptColor: isLightMode ? AppColors.darkText : AppColors.white,
          ),

          // weather icon
          Image.asset(
            icon,
            width: 60,
          ),
        ],
      ),
    );
  }
}
