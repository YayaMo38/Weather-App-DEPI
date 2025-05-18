import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants/app_colors.dart';
import '/constants/text_styles.dart';
import '/extensions/temperature_extensions.dart'; // Add this import
import '/models/famous_city.dart';
import '/providers/get_city_forecast_provider.dart';
import '/providers/temperature_unit_provider.dart'; // Add this import
import '/utils/get_weather_icons.dart';

class CityWeatherTile extends ConsumerWidget {
  const CityWeatherTile({
    super.key,
    required this.city,
    required this.index,
    required this.isLightMode, // Add this
  });

  final FamousCity city;
  final int index;
  final bool isLightMode; // Add this

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(cityForecastProvider(city.name));
    // final isLightMode = ref.watch(themeProvider) == ThemeMode.light; // Remove or comment out if passed as parameter

    return currentWeather.when(
      data: (weather) {
        final tileColor = isLightMode
            ? (index == 0 ? AppColors.skyBlue.withOpacity(0.7) : AppColors.lightSecondaryBg)
            : (index == 0 ? AppColors.lightBlue : AppColors.accentBlue);
        final textColor = isLightMode ? AppColors.darkText : AppColors.white;
        final subtitleColor = isLightMode ? AppColors.darkText.withOpacity(0.7) : AppColors.white.withOpacity(.8);
        final h2Style = isLightMode ? TextStyles.lightH2 : TextStyles.h2;
        final subtitleTextStyle = isLightMode ? TextStyles.lightSubtitleText.copyWith(color: subtitleColor) : TextStyles.subtitleText.copyWith(color: subtitleColor);


        return Padding(
          padding: const EdgeInsets.all(
            0.0,
          ),
          child: Material(
            color: tileColor,
            elevation: index == 0 ? (isLightMode ? 4 : 12) : (isLightMode ? 2 : 0),
            shadowColor: isLightMode ? Colors.grey.withOpacity(0.5) : Colors.black,
            borderRadius: BorderRadius.circular(25.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Row 1
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ref.watch(temperatureUnitProvider) == TemperatureUnit.celsius
                                ? '${weather.main.temp.round()}°'
                                : '${weather.main.temp.toFahrenheit().round()}°',
                              style: h2Style.copyWith(color: textColor),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              weather.weather[0].description,
                              style: subtitleTextStyle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      // Row 2
                      Image.asset(
                        getWeatherIcon(weatherCode: weather.weather[0].id),
                        width: 50,
                        // Removed color filter to restore original colors
                      ),
                    ],
                  ),
                  Text(
                    weather.name,
                    style: TextStyle(
                      fontSize: 18,
                      color: subtitleColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text(error.toString()),
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
