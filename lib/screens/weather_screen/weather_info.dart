import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants/app_colors.dart';
import '/constants/text_styles.dart';
import '/extensions/double.dart';
import '/extensions/temperature_extensions.dart';
import '/models/weather.dart';
import '/providers/temperature_unit_provider.dart';

class WeatherInfo extends ConsumerWidget {
  const WeatherInfo({
    super.key,
    required this.weather,
    this.isLightMode = false,
  });

  final Weather weather;
  final bool isLightMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final temperatureUnit = ref.watch(temperatureUnitProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WeatherInfoTile(
            title: 'Temp',
            value: weather.main.temp.formatTemperature(temperatureUnit),
            isLightMode: isLightMode,
          ),
          WeatherInfoTile(
            title: 'Wind',
            value: '${weather.wind.speed.kmh} km/h',
            isLightMode: isLightMode,
          ),
          WeatherInfoTile(
            title: 'Humidity',
            value: '${weather.main.humidity}%',
            isLightMode: isLightMode,
          ),
        ],
      ),
    );
  }
}

class WeatherInfoTile extends StatelessWidget {
  const WeatherInfoTile({
    super.key,
    required this.title,
    required this.value,
    this.isLightMode = false,
  }) : super();

  final String title;
  final String value;
  final bool isLightMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title
        Text(
          title,
          style: isLightMode ? TextStyles.lightSubtitleText.copyWith(color: AppColors.darkText.withOpacity(0.7)) : TextStyles.subtitleText,
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: isLightMode ? TextStyles.lightH3.copyWith(color: AppColors.darkText) : TextStyles.h3,
        )
      ],
    );
  }
}
