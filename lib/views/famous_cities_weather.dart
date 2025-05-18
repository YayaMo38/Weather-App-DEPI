import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/famous_city.dart';
import '/providers/selected_cities_provider.dart';
import '/providers/theme_provider.dart';
import '/screens/weather_detail_screen.dart';
import '/widgets/city_weather_tile.dart';

class FamousCitiesWeather extends ConsumerWidget {
  const FamousCitiesWeather({
    super.key,
    this.isLightMode = false,
  });
  
  final bool isLightMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayedCities = ref.watch(displayedCitiesProvider);
    final isLightMode = ref.watch(themeProvider) == ThemeMode.light;
    
    if (displayedCities.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_city,
              size: 48,
              color: isLightMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              child: Text(
                'No cities selected. Use "Manage Cities" to add cities to your collection.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_location_alt, size: 18),
              label: const Text('Add Cities'), 
              onPressed: () => Navigator.pushNamed(context, '/select_cities'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isLightMode ? Colors.blue : Colors.blueGrey,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayedCities.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        final city = displayedCities[index];

        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => WeatherDetailScreen(
                  cityName: city.name,
                ),
              ),
            );
          },
          child: CityWeatherTile(
            index: index,
            city: city,
            isLightMode: isLightMode,
          ),
        );
      },
    );
  }
}