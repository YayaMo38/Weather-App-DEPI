// filepath: d:\Weather App\weatherly\lib\screens\select_cities_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants/app_colors.dart';
import '/models/famous_city.dart';
import '/providers/selected_cities_provider.dart';
import '/providers/theme_provider.dart';
import '/views/gradient_container.dart';

class SelectCitiesScreen extends ConsumerStatefulWidget {
  const SelectCitiesScreen({super.key});

  @override
  ConsumerState<SelectCitiesScreen> createState() => _SelectCitiesScreenState();
}

class _SelectCitiesScreenState extends ConsumerState<SelectCitiesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Helper method to build city list tile
  Widget _buildCityListTile(FamousCity city, List<String> selectedCities, Color textColor, bool isLightMode, {bool cannotAdd = false}) {
    final isSelected = selectedCities.contains(city.name);
    
    return CheckboxListTile(
      title: Text(
        city.name,
        style: TextStyle(color: textColor),
      ),
      subtitle: cannotAdd ? const Text(
        'Maximum cities reached',
        style: TextStyle(color: Colors.red, fontSize: 12),
      ) : null,
      value: isSelected,
      activeColor: isLightMode ? AppColors.primaryBlue : AppColors.lightBlue,
      checkColor: Colors.white,
      onChanged: (selectedCities.length <= 1 && isSelected) || cannotAdd
        ? null  // Disable deselection if it's the last selected city or can't add more
        : (_) {
          ref.read(selectedCitiesProvider.notifier).toggleCity(city.name);
        },
    );
  }
  
  void _showResetConfirmationDialog(BuildContext context, bool isLightMode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isLightMode 
              ? Colors.white 
              : AppColors.secondaryBlack,
          title: Text(
            'Reset to Default',
            style: TextStyle(
              color: isLightMode ? AppColors.darkText : AppColors.white,
            ),
          ),
          content: Text(
            'This will reset your selected cities to the default set. Continue?',
            style: TextStyle(
              color: isLightMode ? AppColors.darkText : AppColors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isLightMode ? AppColors.darkText.withOpacity(0.7) : AppColors.white.withOpacity(0.7),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                ref.read(selectedCitiesProvider.notifier).updateSelectedCities(defaultCities);
                
                // Clear search
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
                
                // Show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Cities reset to default'),
                    backgroundColor: isLightMode ? AppColors.primaryBlue : AppColors.lightBlue,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                'Reset',
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
    final selectedCities = ref.watch(selectedCitiesProvider);
    final textColor = isLightMode ? AppColors.darkText : AppColors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Cities', 
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: textColor,
        ),        actions: [
          TextButton(
            onPressed: () {
              _showResetConfirmationDialog(context, isLightMode);
            },
            child: Text(
              'Reset to Default',
              style: TextStyle(
                color: isLightMode ? AppColors.primaryBlue : AppColors.lightBlue,
              ),
            ),
          ),
        ],
      ),      body: GradientContainer(
        children: [          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Choose cities to display on the search screen',
              style: TextStyle(
                fontSize: 16,
                color: textColor,
              ),
            ),
          ),

          // Search bar
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: isLightMode 
                  ? AppColors.lightSecondaryBg 
                  : AppColors.secondaryBlack.withOpacity(0.7),
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Search cities...',
                hintStyle: TextStyle(
                  color: isLightMode ? AppColors.darkText.withOpacity(0.5) : AppColors.white.withOpacity(0.5),
                ),
                prefixIcon: Icon(
                  Icons.search, 
                  color: isLightMode ? AppColors.primaryBlue : AppColors.lightBlue,
                ),
                suffixIcon: _searchQuery.isNotEmpty 
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: isLightMode ? AppColors.darkText.withOpacity(0.5) : AppColors.white.withOpacity(0.5),
                      ),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim().toLowerCase();
                });
              },
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Counter and help text row
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isLightMode ? AppColors.primaryBlue : AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${selectedCities.length}/${allAvailableCities.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(                  child: Text(
                    selectedCities.length >= maxDisplayedCities
                        ? 'Maximum city limit reached (${maxDisplayedCities}). Deselect some to add others.'
                        : 'Select at least 1 city. You can select up to ${maxDisplayedCities} cities.',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: selectedCities.length >= maxDisplayedCities 
                          ? Colors.red 
                          : (isLightMode ? AppColors.darkText.withOpacity(0.7) : AppColors.white.withOpacity(0.7)),
                    ),
                  ),),
              ],
            ),
          ),
          // List of all available cities with checkboxes
          SizedBox(
            height: 400, // Fixed height instead of using Expanded
            child: Container(
              decoration: BoxDecoration(
                color: isLightMode 
                    ? AppColors.lightSecondaryBg 
                    : AppColors.secondaryBlack.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Builder(
                builder: (context) {
                  // Filter cities based on search query
                  final filteredCities = allAvailableCities.where((city) {
                    if (_searchQuery.isEmpty) return true;
                    return city.name.toLowerCase().contains(_searchQuery);
                  }).toList();
                  
                  if (filteredCities.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48.0,
                            color: isLightMode ? AppColors.darkText.withOpacity(0.5) : AppColors.white.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'No cities found',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16.0,
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Try a different search term',
                                style: TextStyle(
                                  color: isLightMode ? AppColors.darkText.withOpacity(0.7) : AppColors.white.withOpacity(0.7),
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }                  // Group cities into default, user-added, and other available
                  final defaultCitiesList = filteredCities.where(
                    (city) => defaultCities.contains(city.name)
                  ).toList();
                  
                  final userAddedCities = filteredCities.where(
                    (city) => !defaultCities.contains(city.name) &&
                              selectedCities.contains(city.name)
                  ).toList();
                  
                  final otherAvailableCities = filteredCities.where(
                    (city) => !defaultCities.contains(city.name) &&
                              !selectedCities.contains(city.name)
                  ).toList();
                  
                  return ListView(
                    children: [
                      // Default cities section
                      if (defaultCitiesList.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 4.0),
                          child: Text(
                            'Default Cities',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      
                      // Default cities list
                      if (defaultCitiesList.isNotEmpty)
                        ...defaultCitiesList.map((city) {
                          final cannotAddCity = selectedCities.length >= maxDisplayedCities &&
                              !selectedCities.contains(city.name);
                          return _buildCityListTile(
                            city, selectedCities, textColor, isLightMode,
                            cannotAdd: cannotAddCity
                          );
                        }).toList(),
                      
                      // User added cities section
                      if (userAddedCities.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 4.0),
                          child: Row(
                            children: [
                              const Text(
                                'Your Added Cities',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.search,
                                size: 14,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      
                      // User added cities list
                      if (userAddedCities.isNotEmpty)
                        ...userAddedCities.map((city) {
                          final cannotAddCity = selectedCities.length >= maxDisplayedCities &&
                              !selectedCities.contains(city.name);
                          return _buildCityListTile(
                            city, selectedCities, textColor, isLightMode,
                            cannotAdd: cannotAddCity
                          );
                        }).toList(),
                      
                      // Other available cities section
                      if (otherAvailableCities.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 4.0),
                          child: Text(
                            'Other Available Cities',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      
                      // Other available cities list
                      if (otherAvailableCities.isNotEmpty)
                        ...otherAvailableCities.map((city) {
                          return _buildCityListTile(
                            city, selectedCities, textColor, isLightMode,
                            cannotAdd: selectedCities.length >= maxDisplayedCities
                          );
                        }).toList(),
                    ],
                  );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}