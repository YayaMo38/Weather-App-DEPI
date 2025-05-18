import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/constants/app_theme.dart';
import '/models/weather.dart';
import '/providers/theme_provider.dart';
import '/screens/home_screen.dart';
import '/screens/search_screen.dart';
import '/screens/weather_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    // Watch the theme provider to get the current theme mode
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App Demo',
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const HomeScreen(),
      routes: {
        '/search': (context) => const SearchScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/weather_detail') {
          final Weather weather = settings.arguments as Weather;
          return MaterialPageRoute(
            builder: (context) => WeatherDetailScreen(weather: weather),
          );
        }
        return null;
      },
    );
  }
}
