import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/constants/text_styles.dart';
import '/extensions/datetime.dart';
import '/extensions/strings.dart';
import '/models/weather.dart';
import '/providers/get_city_forecast_provider.dart';
import '/providers/theme_provider.dart';
import '/screens/weather_screen/weather_info.dart';
import '/views/gradient_container.dart';
import '/constants/app_colors.dart';

class WeatherDetailScreen extends ConsumerWidget {
  const WeatherDetailScreen({
    super.key,
    this.cityName,
    this.weather,
  }) : assert(cityName != null || weather != null, 'Either cityName or weather must be provided');

  final String? cityName;
  final Weather? weather;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If weather is provided directly, use it, otherwise fetch it using the provider
    final weatherData = weather != null
        ? AsyncValue.data(weather!)
        : ref.watch(cityForecastProvider(cityName!));
    
    final isLightMode = ref.watch(themeProvider) == ThemeMode.light;

    return Scaffold(
      body: weatherData.when(
        data: (weather) {
          return GradientContainer(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
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

                  const SizedBox(height: 50),

                  // Weather icon big
                  SizedBox(
                    height: 300,
                    child: Image.asset(
                      'assets/icons/${weather.weather[0].icon.replaceAll('n', 'd')}.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Weather description
                  Text(
                    weather.weather[0].description.capitalize,
                    style: isLightMode ? TextStyles.lightH2.copyWith(color: AppColors.darkText) : TextStyles.h2,
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Weather info in a row
              WeatherInfo(weather: weather, isLightMode: isLightMode),

              const SizedBox(height: 15),
            ],
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(
              'An error has occurred',
              style: TextStyle(color: isLightMode ? AppColors.darkText : Colors.white),
            ),
          );
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(isLightMode ? AppColors.primaryBlue : Colors.white),
            ),
          );
        },
      ),
    );
  }
}
