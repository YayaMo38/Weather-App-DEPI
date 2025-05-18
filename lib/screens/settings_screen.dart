import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/providers/location_provider.dart';

import '/constants/app_colors.dart';
import '/providers/theme_provider.dart';
import '/providers/temperature_unit_provider.dart';
import '/views/gradient_container.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isLightMode = themeMode == ThemeMode.light;
    final textColor = isLightMode ? AppColors.darkText : AppColors.white;
    final temperatureUnit = ref.watch(temperatureUnitProvider);
    final isCelsius = temperatureUnit == TemperatureUnit.celsius;
    final locationData = ref.watch(locationProvider);

    return GradientContainer(
      children: [
        const SizedBox(height: 16),
        Text(
          'Settings',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 32),
        
        // Theme Settings Section
        _buildSettingsSection(
          context,
          title: 'Appearance',
          children: [
            _buildThemeSelector(context, ref, isLightMode, textColor),
          ],
          isLightMode: isLightMode,
        ),
        
        const SizedBox(height: 24),
        
        // General settings section
        _buildSettingsSection(
          context,
          title: 'General',
          children: [
            _buildTemperatureUnitSelector(context, ref, isCelsius, isLightMode, textColor),
            _buildSettingsTile(
              title: 'Location',
              subtitle: 'Current: ${locationData.displayName}',
              icon: Icons.location_on_outlined,
              onTap: () {
                _showLocationSettings(context, ref);
              },
              isLightMode: isLightMode,
            ),
          ],
          isLightMode: isLightMode,
        ),
      ],
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
    required bool isLightMode,
  }) {
    final textColor = isLightMode ? AppColors.darkText : AppColors.white;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isLightMode 
                ? AppColors.lightSecondaryBg 
                : AppColors.secondaryBlack.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSelector(
    BuildContext context, 
    WidgetRef ref, 
    bool isLightMode,
    Color textColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isLightMode ? Icons.light_mode : Icons.dark_mode,
                color: textColor,
              ),
              const SizedBox(width: 16),
              Text(
                'Theme',
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ],
          ),
          Switch(
            value: isLightMode,
            activeColor: AppColors.lightBlue,
            onChanged: (value) {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureUnitSelector(
    BuildContext context, 
    WidgetRef ref, 
    bool isCelsius,
    bool isLightMode,
    Color textColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.thermostat_outlined,
                color: textColor,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Temperature Unit',
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                  Text(
                    isCelsius ? 'Celsius (°C)' : 'Fahrenheit (°F)',
                    style: TextStyle(
                      fontSize: 14,
                      color: isLightMode ? AppColors.lightGrey : AppColors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: !isCelsius, // Switch is ON for Fahrenheit
            activeColor: AppColors.lightBlue,
            onChanged: (value) {
              ref.read(temperatureUnitProvider.notifier).toggleTemperatureUnit();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Function() onTap,
    required bool isLightMode,
  }) {
    final textColor = isLightMode ? AppColors.darkText : AppColors.white;
    final subtitleColor = isLightMode ? AppColors.lightGrey : AppColors.grey;
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationSettings(BuildContext context, WidgetRef ref) {
    final locationData = ref.read(locationProvider);
    final locationNotifier = ref.read(locationProvider.notifier);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Location Settings'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current location display
                Card(
                  margin: const EdgeInsets.only(bottom: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              locationData.source == LocationSource.gps 
                                ? Icons.my_location 
                                : Icons.location_on,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Current Location',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          locationData.displayName,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Source: ${locationData.source == LocationSource.gps ? 'GPS' : 'Manual Entry'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (locationData.latitude != null && locationData.longitude != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              'Coordinates: ${locationData.latitude!.toStringAsFixed(4)}, ${locationData.longitude!.toStringAsFixed(4)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                
                // Location source selection
                const Text(
                  'Choose Location Source',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                
                // GPS Option
                RadioListTile<LocationSource>(
                  title: const Text('Use Device GPS'),
                  subtitle: const Text('Automatically detect your current location'),
                  value: LocationSource.gps,
                  groupValue: locationData.source,
                  onChanged: (value) {
                    if (value != null) {
                      locationNotifier.useGpsLocation();
                      // Go back to refresh the weather display
                      Navigator.of(context).pop();
                    }
                  },
                ),
                
                // Manual Option
                RadioListTile<LocationSource>(
                  title: const Text('Manual Selection'),
                  subtitle: const Text('Enter a city name or coordinates'),
                  value: LocationSource.manual,
                  groupValue: locationData.source,
                  onChanged: (value) {
                    if (value != null) {
                      _showManualLocationInput(context, ref);
                    }
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Quick city selection section
                const Text(
                  'Quick Select Cities',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                
                // City chips
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildCityChip('London', ref, context),
                    _buildCityChip('New York', ref, context),
                    _buildCityChip('Tokyo', ref, context),
                    _buildCityChip('Sydney', ref, context),
                    _buildCityChip('Paris', ref, context),
                    _buildCityChip('Cairo', ref, context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCityChip(String cityName, WidgetRef ref, BuildContext context) {
    return ActionChip(
      label: Text(cityName),
      onPressed: () {
        ref.read(locationProvider.notifier).useManualLocation(
          cityName: cityName,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location set to $cityName')),
        );
        // Go back to refresh the weather display
        Navigator.of(context).pop();
      },
    );
  }

  void _showManualLocationInput(BuildContext context, WidgetRef ref) {
    final locationNotifier = ref.read(locationProvider.notifier);
    final TextEditingController cityController = TextEditingController();
    final TextEditingController latController = TextEditingController();
    final TextEditingController longController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter Location Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'City Name*'),
              ),
              const SizedBox(height: 10),
              const Text(
                'Optional: Add coordinates for more precise weather data',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              TextField(
                controller: latController,
                decoration: const InputDecoration(labelText: 'Latitude (optional)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: longController,
                decoration: const InputDecoration(labelText: 'Longitude (optional)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (cityController.text.isNotEmpty) {
                double? lat = double.tryParse(latController.text);
                double? long = double.tryParse(longController.text);
                
                locationNotifier.useManualLocation(
                  cityName: cityController.text,
                  latitude: lat,
                  longitude: long,
                );
                
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to main settings screen
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
