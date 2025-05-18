import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants/app_colors.dart';
import '/constants/text_styles.dart';
import '/models/weather.dart';
import '/services/api_helper.dart';
import '/views/famous_cities_weather.dart';
import '/views/gradient_container.dart';
import '/widgets/round_text_field.dart';
import '/providers/theme_provider.dart';

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
      final Weather weather = await ApiHelper.getWeatherByCityName(cityName: query);
      if (!mounted) return;
      
      Navigator.pushNamed(
        context,
        '/weather_detail',
        arguments: weather,
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not find weather for "$query". Please try another location.'),
          backgroundColor: Colors.red,
        ),
      );
    }
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

        // Custom Textfield with a round border
        RoundTextField(
          controller: _searchController,
          onSubmitted: _searchLocation,
        ),

        const SizedBox(height: 35),

        Row(
          children: [
            Text(
              'Famous Cities',
              style: TextStyle(
                fontSize: 16,
                color: isLightMode ? AppColors.darkText.withOpacity(0.7) : AppColors.white, // Ensure dark gray in light mode
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        // Famous cities
        FamousCitiesWeather(isLightMode: isLightMode),
      ],
    );
  }
}
