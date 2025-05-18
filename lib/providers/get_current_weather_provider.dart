import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/providers/location_provider.dart';
import '/services/api_helper.dart';

final currentWeatherProvider = FutureProvider.autoDispose((ref) {
  // Watch the location provider to automatically refresh when location changes
  final locationData = ref.watch(locationProvider);
  
  // Use a different approach to get weather for location
  if (locationData.source == LocationSource.manual && locationData.cityName != null) {
    // Get weather by city name
    return ApiHelper.getWeatherByCityName(cityName: locationData.cityName!);
  } else {
    // Get weather by coordinates using the current location
    return ApiHelper.getCurrentWeather();
  }
});
