import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants/app_colors.dart';
import '/constants/text_styles.dart';
import '/extensions/int.dart';
import '/extensions/temperature_extensions.dart';
import '/providers/get_hourly_forecast_provider.dart';
import '/providers/theme_provider.dart';
import '/providers/temperature_unit_provider.dart';
import '/utils/get_weather_icons.dart';

class HourlyForecastView extends ConsumerWidget {
  const HourlyForecastView({
    super.key,
    this.isLightMode = false,
  });

  final bool isLightMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hourlyWeather = ref.watch(hourlyForecastProvider);
    final themeMode = ref.watch(themeProvider);
    final isLight = isLightMode || themeMode == ThemeMode.light;
    final temperatureUnit = ref.watch(temperatureUnitProvider);

    return hourlyWeather.when(
      data: (hourlyForecast) {
        return SizedBox(
          height: 100,
          child: ListView.builder(
            itemCount: 12,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final forecast = hourlyForecast.list[index];
              return HourlyForcastTile(
                id: forecast.weather[0].id,
                hour: forecast.dt.time,
                temp: forecast.main.temp.round(),
                temperatureUnit: temperatureUnit,
                isActive: index == 0,
                isLightMode: isLight,
              );
            },
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text(
            error.toString(),
            style: TextStyle(
              color: isLight ? AppColors.darkText : AppColors.white,
            ),
          ),
        );
      },
      loading: () {
        return Center(
          child: CircularProgressIndicator(
            color: isLight ? AppColors.lightBlue : AppColors.white,
          ),
        );
      },
    );
  }
}

class HourlyForcastTile extends StatelessWidget {
  const HourlyForcastTile({
    super.key,
    required this.id,
    required this.hour,
    required this.temp,
    required this.isActive,
    required this.temperatureUnit,
    this.isLightMode = false,
  });

  final int id;
  final String hour;
  final int temp;
  final bool isActive;
  final bool isLightMode;
  final TemperatureUnit temperatureUnit;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isActive
        ? AppColors.primaryBlue
        : (isLightMode ? AppColors.lightAccentBlue : AppColors.accentBlue);

    // Convert temperature if needed
    final displayTemp = temperatureUnit == TemperatureUnit.celsius
        ? temp
        : (temp * 9 / 5 + 32).round();
    final unitSymbol = temperatureUnit == TemperatureUnit.celsius ? '°' : '°F';

    return Padding(
      padding: const EdgeInsets.only(
        right: 16,
        top: 12,
        bottom: 12,
      ),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15.0),
        elevation: isActive ? 4 : 1,
        shadowColor: isLightMode ? Colors.black26 : Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                getWeatherIcon(weatherCode: id),
                width: 50,
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    hour,
                    style: TextStyle(
                      color: isLightMode ? AppColors.darkText : AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$displayTemp$unitSymbol',
                    style: isLightMode 
                      ? TextStyles.lightH3.copyWith(color: AppColors.darkText) 
                      : TextStyles.h3,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
