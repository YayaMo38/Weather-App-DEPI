import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants/app_colors.dart';
import '/providers/theme_provider.dart';
import '/screens/forecast_report_screen.dart';
import '/screens/search_screen.dart';
import '/screens/settings_screen.dart';
import 'weather_screen/weather_screen.dart';
import '/services/api_helper.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentPageIndex = 0;

  final _screens = const [
    WeatherScreen(),
    SearchScreen(),
    ForecastReportScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    ApiHelper.getCurrentWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = ref.watch(themeProvider) == ThemeMode.light;
    final iconColor = isLightMode ? AppColors.darkText : AppColors.white;
    
    return Scaffold(
      body: _screens[_currentPageIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: isLightMode 
              ? AppColors.lightSecondaryBg 
              : AppColors.secondaryBlack,
        ),
        child: NavigationBar(
          selectedIndex: _currentPageIndex,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          indicatorColor: Colors.transparent,
          onDestinationSelected: (index) =>
              setState(() => _currentPageIndex = index),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: iconColor),
              selectedIcon: Icon(Icons.home, color: iconColor),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.search, color: iconColor),
              selectedIcon: Icon(Icons.search, color: iconColor),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined, color: iconColor),
              selectedIcon: Icon(Icons.calendar_today, color: iconColor),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined, color: iconColor),
              selectedIcon: Icon(Icons.settings, color: iconColor),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
