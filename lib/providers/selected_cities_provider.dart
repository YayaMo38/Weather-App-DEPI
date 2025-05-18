import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/models/famous_city.dart';

// List of all available cities to select from
List<FamousCity> allAvailableCities = [
  const FamousCity(name: 'Tokyo', lat: 35.6833, lon: 139.7667),
  const FamousCity(name: 'New Delhi', lat: 28.5833, lon: 77.2),
  const FamousCity(name: 'Paris', lat: 48.85, lon: 2.3333),
  const FamousCity(name: 'London', lat: 51.4833, lon: -0.0833),
  const FamousCity(name: 'New York', lat: 40.7167, lon: -74.0167),
  const FamousCity(name: 'Tehran', lat: 35.6833, lon: 51.4167),
  const FamousCity(name: 'Sydney', lat: -33.8667, lon: 151.2),
  const FamousCity(name: 'Cairo', lat: 30.05, lon: 31.25),
  const FamousCity(name: 'Rio de Janeiro', lat: -22.9, lon: -43.2333),
  const FamousCity(name: 'Moscow', lat: 55.75, lon: 37.6167),
  const FamousCity(name: 'Dubai', lat: 25.2697, lon: 55.3094),
  const FamousCity(name: 'Singapore', lat: 1.2833, lon: 103.85),
];

// Default cities to show if no selection has been made
List<String> defaultCities = const [
  'Tokyo', 'New Delhi', 'Paris', 'London'
];

// Maximum number of cities that can be displayed at once to prevent app crashes
const int maxDisplayedCities = 20;

class SelectedCitiesNotifier extends StateNotifier<List<String>> {
  SelectedCitiesNotifier() : super(defaultCities) {
    _loadSelectedCities();
    _loadCustomCities();
  }

  Future<void> _loadSelectedCities() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCities = prefs.getStringList('selectedCities');
    
    if (savedCities != null && savedCities.isNotEmpty) {
      state = savedCities;
    }
  }
  
  Future<void> _loadCustomCities() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCustomCities = prefs.getStringList('customCities');
    
    if (savedCustomCities != null && savedCustomCities.isNotEmpty) {
      // Format is "cityName|lat|lon"
      for (final cityString in savedCustomCities) {
        final parts = cityString.split('|');
        if (parts.length == 3) {
          try {
            final name = parts[0];
            final lat = double.parse(parts[1]);
            final lon = double.parse(parts[2]);
            
            // Check if it's not already in the list
            if (!allAvailableCities.any((city) => city.name == name)) {
              allAvailableCities = [
                ...allAvailableCities,
                FamousCity(name: name, lat: lat, lon: lon)
              ];
            }
          } catch (e) {
            // Ignore invalid entries
          }
        }
      }
    }
  }

  Future<void> updateSelectedCities(List<String> cities) async {
    if (cities.isEmpty) {
      // Don't allow empty selection, use defaults
      state = defaultCities;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('selectedCities', defaultCities);
    } else {
      // Limit the number of cities to prevent app crashes
      final limitedCities = cities.length > maxDisplayedCities 
          ? cities.sublist(0, maxDisplayedCities) 
          : cities;
      
      state = limitedCities;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('selectedCities', limitedCities);
    }
  }

  // Toggle a city's selection status
  Future<void> toggleCity(String cityName) async {
    final updatedSelection = List<String>.from(state);
    
    if (updatedSelection.contains(cityName)) {
      // Don't allow removing if it would result in empty selection
      if (updatedSelection.length > 1) {
        updatedSelection.remove(cityName);
      }
    } else {
      // Don't allow adding if we've reached the maximum
      if (updatedSelection.length < maxDisplayedCities) {
        updatedSelection.add(cityName);
      }
    }
    
    await updateSelectedCities(updatedSelection);
  }
  
  // Add a new custom city to the available cities
  Future<void> addCustomCity(FamousCity newCity) async {
    // Check if the city already exists
    if (allAvailableCities.any((city) => city.name == newCity.name)) {
      // City already exists, just make sure it's selected
      if (!state.contains(newCity.name)) {
        await toggleCity(newCity.name);
      }
      return;
    }
    
    // Add to available cities
    allAvailableCities = [...allAvailableCities, newCity];
    
    // Also add to selected cities
    await toggleCity(newCity.name);
    
    // Save custom cities to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final savedCustomCities = prefs.getStringList('customCities') ?? [];
    final cityString = '${newCity.name}|${newCity.lat}|${newCity.lon}';
    
    if (!savedCustomCities.contains(cityString)) {
      savedCustomCities.add(cityString);
      await prefs.setStringList('customCities', savedCustomCities);
    }
  }
}

// Provider for selected cities
final selectedCitiesProvider = StateNotifierProvider<SelectedCitiesNotifier, List<String>>(
  (ref) => SelectedCitiesNotifier(),
);

// Provider that returns the actual FamousCity objects for the selected cities
final displayedCitiesProvider = Provider<List<FamousCity>>((ref) {
  final selectedCityNames = ref.watch(selectedCitiesProvider);
  
  return allAvailableCities
      .where((city) => selectedCityNames.contains(city.name))
      .toList();
});