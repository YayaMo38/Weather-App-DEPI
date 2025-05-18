import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants/app_colors.dart';
import '/providers/get_current_weather_provider.dart';
import '/providers/theme_provider.dart';
import '/screens/weather_screen/weather_screen.dart';
import '/screens/search_screen.dart';
import '/screens/forecast_report_screen.dart';
import '/screens/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const WeatherScreen(), 
    const SearchScreen(),
    const ForecastReportScreen(),
    const SettingsScreen(),
  ];
  
  @override
  void initState() {
    super.initState();
    // Invalidate the provider to refresh weather data when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(currentWeatherProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = ref.watch(themeProvider) == ThemeMode.light;
    
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          
          // Refresh weather data when returning to the home screen
          if (index == 0) {
            ref.invalidate(currentWeatherProvider);
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: isLightMode ? AppColors.primaryBlue : AppColors.lightBlue,
        unselectedItemColor: isLightMode ? AppColors.lightGrey : AppColors.grey,
        backgroundColor: isLightMode ? AppColors.lightSecondaryBg : AppColors.secondaryBlack,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Forecast',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
