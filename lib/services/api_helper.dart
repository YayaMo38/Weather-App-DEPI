import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants/constants.dart';
import '/models/hourly_weather.dart';
import '/models/weather.dart';
import '/models/weekly_weather.dart';
import '/providers/location_provider.dart';
import '/services/getlocator.dart';
import '/utils/logging.dart';

@immutable
class ApiHelper {
  static const baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const weeklyWeatherUrl =
      'https://api.open-meteo.com/v1/forecast?current=&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto';

  static double lat = 0.0;
  static double lon = 0.0;
  static final dio = Dio();

  //! Get lat and lon
  static Future<void> fetchLocation([dynamic ref]) async {
    if (ref != null) {
      final locationData = ref.read(locationProvider);
      if (locationData.source == LocationSource.manual && 
          locationData.latitude != null && 
          locationData.longitude != null) {
        lat = locationData.latitude!;
        lon = locationData.longitude!;
        return;
      } else if (locationData.source == LocationSource.manual && 
                locationData.cityName != null) {
        try {
          // Get coordinates by city name
          final weather = await getWeatherByCityName(cityName: locationData.cityName!);
          lat = weather.coord.lat;
          lon = weather.coord.lon;
          // Update the provider with coordinates
          ref.read(locationProvider.notifier).useManualLocation(
            cityName: locationData.cityName!,
            latitude: lat,
            longitude: lon,
          );
          return;
        } catch (e) {
          printWarning('Error getting coordinates for city: ${locationData.cityName}. Falling back to GPS.');
          // Fall back to GPS if city name doesn't work
        }
      }
    }
    
    // Default to GPS if no ref provided or manual location not available/valid
    final location = await getLocation();
    lat = location.latitude;
    lon = location.longitude;
    
    // Update the provider with GPS coordinates if ref is available
    if (ref != null && ref.read(locationProvider).source == LocationSource.gps) {
      ref.read(locationProvider.notifier).updateGpsCoordinates(lat, lon);
    }
  }

  //* Current Weather
  static Future<Weather> getCurrentWeather() async {
    await fetchLocation();
    final url = _constructWeatherUrl();
    final response = await _fetchData(url);
    return Weather.fromJson(response);
  }
  
  //* Current Weather for a specific location from the provider
  static Future<Weather> getCurrentWeatherForLocation(Ref ref) async {
    await fetchLocation(ref);
    final locationData = ref.read(locationProvider);
    
    if (locationData.source == LocationSource.manual && locationData.cityName != null) {
      // Get weather by city name
      return getWeatherByCityName(cityName: locationData.cityName!);
    } else {
      // Get weather by coordinates
      final url = _constructWeatherUrl();
      final response = await _fetchData(url);
      return Weather.fromJson(response);
    }
  }

  //* Hourly Weather
  static Future<HourlyWeather> getHourlyForecast() async {
    await fetchLocation();
    final url = _constructForecastUrl();
    final response = await _fetchData(url);
    return HourlyWeather.fromJson(response);
  }

  //* Weekly weather
  static Future<WeeklyWeather> getWeeklyForecast() async {
    await fetchLocation();
    final url = _constructWeeklyForecastUrl();
    final response = await _fetchData(url);
    return WeeklyWeather.fromJson(response);
  }

  //* Weather by City Name
  static Future<Weather> getWeatherByCityName({
    required String cityName,
  }) async {
    final url = _constructWeatherByCityUrl(cityName);
    // Log the URL to check if it's correctly formatted
    printInfo('Fetching weather for city: $cityName using URL: $url');
    final response = await _fetchData(url);
    return Weather.fromJson(response);
  }

  //! Build urls
  static String _constructWeatherUrl() =>
      '$baseUrl/weather?lat=$lat&lon=$lon&units=metric&appid=${Constants.apiKey}';

  static String _constructForecastUrl() =>
      '$baseUrl/forecast?lat=$lat&lon=$lon&units=metric&appid=${Constants.apiKey}';

  static String _constructWeatherByCityUrl(String cityName) =>
      '$baseUrl/weather?q=$cityName&units=metric&appid=${Constants.apiKey}'; // Ensure API key is here

  static String _constructWeeklyForecastUrl() =>
      '$weeklyWeatherUrl&latitude=$lat&longitude=$lon';

  //* Fetch Data for a url
  static Future<Map<String, dynamic>> _fetchData(String url) async {
    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        // Log detailed error for non-200 status codes
        printWarning('Failed to load data from $url. Status Code: ${response.statusCode}, Response: ${response.data}');
        throw Exception('Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Log the full error object, including DioError details if available
      if (e is DioError) {
        printWarning('DioError fetching data from $url: ${e.message}, Response: ${e.response?.data}, Type: ${e.type}');
      } else {
        printWarning('Error fetching data from $url: $e');
      }
      throw Exception('Error fetching data: $e');
    }
  }
}
