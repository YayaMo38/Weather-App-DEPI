import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TemperatureUnit {
  celsius,
  fahrenheit,
}

// Provider for temperature unit preference
final temperatureUnitProvider = StateNotifierProvider<TemperatureUnitNotifier, TemperatureUnit>(
  (ref) => TemperatureUnitNotifier(),
);

class TemperatureUnitNotifier extends StateNotifier<TemperatureUnit> {
  TemperatureUnitNotifier() : super(TemperatureUnit.celsius) {
    _loadPreference();
  }

  // Load saved preference from SharedPreferences
  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isFahrenheit = prefs.getBool('use_fahrenheit') ?? false;
    state = isFahrenheit ? TemperatureUnit.fahrenheit : TemperatureUnit.celsius;
  }

  // Toggle temperature unit and save preference
  Future<void> toggleTemperatureUnit() async {
    final prefs = await SharedPreferences.getInstance();
    if (state == TemperatureUnit.celsius) {
      state = TemperatureUnit.fahrenheit;
      await prefs.setBool('use_fahrenheit', true);
    } else {
      state = TemperatureUnit.celsius;
      await prefs.setBool('use_fahrenheit', false);
    }
  }

  // Set specific temperature unit
  Future<void> setTemperatureUnit(TemperatureUnit unit) async {
    final prefs = await SharedPreferences.getInstance();
    state = unit;
    await prefs.setBool('use_fahrenheit', unit == TemperatureUnit.fahrenheit);
  }
}
