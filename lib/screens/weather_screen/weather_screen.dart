import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants/app_colors.dart';
import '/constants/text_styles.dart';
import '/extensions/datetime.dart';
import '/extensions/strings.dart';
import '/providers/get_current_weather_provider.dart';
import '/providers/theme_provider.dart';
import '/views/gradient_container.dart';
import '/views/hourly_forecast_view.dart';
import 'weather_info.dart';

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherData = ref.watch(currentWeatherProvider);
    final isLightMode = ref.watch(themeProvider) == ThemeMode.light;
    final textColor = isLightMode ? AppColors.darkText : AppColors.white;
    // temperatureUnit is handled inside WeatherInfo and HourlyForecastView

    return weatherData.when(
      data: (weather) {
        return GradientContainer(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: double.infinity,
                ),
                // Country name text
                Text(
                  weather.name,
                  style: isLightMode ? TextStyles.lightH1.copyWith(color: AppColors.darkText) : TextStyles.h1,
                ),

                const SizedBox(height: 20),

                // Today's date
                Text(
                  DateTime.now().dateTime,
                  style: isLightMode ? TextStyles.lightSubtitleText.copyWith(color: AppColors.darkText.withOpacity(0.7)) : TextStyles.subtitleText,
                ),

                const SizedBox(height: 30),

                // Weather icon big
                SizedBox(
                  height: 260,
                  child: Image.asset(
                    'assets/icons/${weather.weather[0].icon.replaceAll('n', 'd')}.png',
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 30),

                // Weather description
                Text(
                  weather.weather[0].description.capitalize,
                  style: isLightMode ? TextStyles.lightH2.copyWith(color: AppColors.darkText) : TextStyles.h2,
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Weather info in a row
            WeatherInfo(
              weather: weather,
              isLightMode: isLightMode,
            ),

            const SizedBox(height: 40),

            // Today Daily Forecast
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 20,
                    color: textColor, // This already uses AppColors.darkText in light mode
                  ),
                ),
                InkWell(
                  child: Text(
                    'View full report',
                    style: TextStyle(
                      color: isLightMode ? AppColors.primaryBlue : AppColors.lightBlue,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // hourly forecast
            HourlyForecastView(isLightMode: isLightMode), // isLightMode is already passed
          ],
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text(
            'An error has occurred',
            style: TextStyle(color: textColor),
          ),
        );
      },
      loading: () {
        return Center(
          child: CircularProgressIndicator(
            color: isLightMode ? AppColors.lightBlue : AppColors.white,
          ),
        );
      },
    );
  }
}
