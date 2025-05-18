import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import '/models/weather.dart';
import '/providers/theme_provider.dart'; // Updated import path
import '/screens/home_screen.dart';
import '/screens/search_screen.dart';
import '/screens/select_cities_screen.dart';
import '/screens/weather_detail_screen.dart';
import 'constants/app_theme.dart'; 

void main() {
  runApp(
    const ProviderScope( 
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget { 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { 
    final themeMode = ref.watch(themeProvider); 

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, 
      darkTheme: AppTheme.darkTheme, 
      themeMode: themeMode, 
      home: const HomeScreen(),
      // Define the named routes
      routes: {
        '/search': (context) => const SearchScreen(),
        '/select_cities': (context) => const SelectCitiesScreen(),
      },
      // Define the route generator for routes with parameters
      onGenerateRoute: (settings) {
        if (settings.name == '/weather_detail') {
          final Weather weather = settings.arguments as Weather;
          return MaterialPageRoute(
            builder: (context) => WeatherDetailScreen(weather: weather),
          );
        }
        // Return null to let Flutter handle routes it doesn't recognize
        return null;
      },
    );
  }
}
