import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants/app_colors.dart';
import '/constants/text_styles.dart';
import '/models/weather.dart';
import '/models/famous_city.dart';
import '/screens/select_cities_screen.dart';
import '/services/api_helper.dart';
import '/views/famous_cities_weather.dart';
import '/views/gradient_container.dart';
import '/widgets/round_text_field.dart';
import '/providers/theme_provider.dart';
import '/providers/selected_cities_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  void _searchLocation(String query) async {
    if (query.isEmpty) return;
    
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Searching...'),
          duration: Duration(seconds: 1),
        ),
      );
      
      final Weather weather = await ApiHelper.getWeatherByCityName(cityName: query);
      if (!mounted) return;
      
      // Show the weather detail screen
      Navigator.pushNamed(
        context,
        '/weather_detail',
        arguments: weather,
      ).then((_) {
        // After returning from the weather detail screen, show dialog to add to famous cities
        _showAddToFamousCitiesDialog(weather);
      });
    } catch (e) {
      if (!mounted) return;
      
      // Show user-friendly error message
      String errorMessage = 'Could not find weather for "$query".\n';
      errorMessage += 'Please check the spelling or try a different city name.';
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
    
  

  
  void _showAddToFamousCitiesDialog(Weather weather) {
    final isLightMode = ref.read(themeProvider) == ThemeMode.light;
    final selectedCities = ref.read(selectedCitiesProvider);
    final cityExists = allAvailableCities.any((city) => city.name == weather.name);
    final citySelected = selectedCities.contains(weather.name);
    final maxReached = selectedCities.length >= maxDisplayedCities && !citySelected;
    
    // Don't show dialog if city is already selected or max is reached
    if (citySelected || (cityExists && maxReached)) return;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isLightMode ? Colors.white : AppColors.secondaryBlack,
          title: Text(
            'Add to Famous Cities',
            style: TextStyle(
              color: isLightMode ? AppColors.darkText : AppColors.white,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cityExists 
                  ? 'Would you like to add ${weather.name} to your displayed Famous Cities?'
                  : 'Would you like to add ${weather.name} to your Famous Cities collection?',
                style: TextStyle(
                  color: isLightMode ? AppColors.darkText : AppColors.white,
                ),
              ),
              if (maxReached)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Note: You have reached the maximum limit of $maxDisplayedCities cities. You need to remove some cities first.',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text(
                'Not now',
                style: TextStyle(
                  color: isLightMode ? AppColors.darkText.withOpacity(0.7) : AppColors.white.withOpacity(0.7),
                ),
              ),
            ),
            TextButton(
              onPressed: maxReached 
                ? () {
                    // Navigate to select cities screen to manage cities
                    Navigator.pop(context); // Close dialog
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const SelectCitiesScreen()),
                    );
                  }
                : () {
                    Navigator.pop(context); // Close dialog
                    
                    if (cityExists) {
                      // Toggle existing city (add to selected)
                      ref.read(selectedCitiesProvider.notifier).toggleCity(weather.name);
                    } else {
                      // Add as a new custom city
                      ref.read(selectedCitiesProvider.notifier).addCustomCity(
                        FamousCity(
                          name: weather.name,
                          lat: weather.coord.lat,
                          lon: weather.coord.lon,
                        ),
                      );
                    }
                    
                    // Show confirmation
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${weather.name} added to Famous Cities'),
                        backgroundColor: isLightMode ? AppColors.primaryBlue : AppColors.lightBlue,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
              child: Text(
                maxReached ? 'Manage Cities' : 'Add',
                style: TextStyle(
                  color: isLightMode ? AppColors.primaryBlue : AppColors.lightBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = ref.watch(themeProvider) == ThemeMode.light;
    
    return GradientContainer(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            'Search',
            style: isLightMode ? TextStyles.lightH1 : TextStyles.h1,
          ),
        ),

        const SizedBox(height: 35),

        // Custom Textfield with a round border and search button
        Row(
          children: [
            Expanded(
              child: RoundTextField(
                controller: _searchController,
                onSubmitted: _searchLocation,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: isLightMode ? AppColors.primaryBlue : AppColors.lightBlue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () => _searchLocation(_searchController.text),
                tooltip: 'Search',
              ),
            ),
          ],
        ),

        const SizedBox(height: 35),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Famous Cities',
              style: TextStyle(
                fontSize: 16,
                color: isLightMode ? AppColors.darkText.withOpacity(0.7) : AppColors.white,
              ),
            ),
            Row(
              children: [
                // Add count indicator
                Consumer(
                  builder: (context, ref, _) {
                    final selectedCities = ref.watch(selectedCitiesProvider);
                    return Tooltip(
                      message: selectedCities.length >= maxDisplayedCities
                          ? 'Maximum limit reached ($maxDisplayedCities cities)'
                          : selectedCities.length >= maxDisplayedCities - 3
                              ? 'Approaching maximum limit'
                              : '${selectedCities.length} of $maxDisplayedCities cities selected',
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: selectedCities.length >= maxDisplayedCities
                              ? Colors.orange // At max limit
                              : selectedCities.length >= maxDisplayedCities - 3
                                  ? Colors.amber // Near limit warning
                                  : (isLightMode ? AppColors.primaryBlue : AppColors.lightBlue),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${selectedCities.length}/$maxDisplayedCities',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Manage Cities button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const SelectCitiesScreen()),
                    );
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Manage Cities'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLightMode ? AppColors.primaryBlue : AppColors.lightBlue,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 15),

        // Famous cities
        const FamousCitiesWeather(),
      ],
    );
  }
}
