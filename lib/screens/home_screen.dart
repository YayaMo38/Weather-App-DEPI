import 'package:flutter/material.dart';
import 'package:weatherly/constants/app_colors.dart';
import '/screens/forecast_report_screen.dart';
import '/screens/search_screen.dart';
import '/screens/settings_screen.dart';
import 'weather_screen/weather_screen.dart';
import '/services/api_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return Scaffold(
      body: _screens[_currentPageIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedIndex: _currentPageIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        indicatorColor: Colors.transparent,
        onDestinationSelected: (index) =>
            setState(() => _currentPageIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.wb_sunny_outlined),
            selectedIcon: Icon(Icons.wb_sunny),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: '',
          ),
        ],
      ),
    );
  }
}
