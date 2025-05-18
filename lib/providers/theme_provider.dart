import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider to track the current theme mode
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

// Notifier class to manage theme state
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.dark) {
    _loadThemePreference();
  }

  // Load the saved theme preference
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isLightMode = prefs.getBool('isLightMode') ?? false;
    state = isLightMode ? ThemeMode.light : ThemeMode.dark;
  }

  // Toggle between light and dark theme
  Future<void> toggleTheme() async {
    final newTheme = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = newTheme;
    
    // Save the preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLightMode', newTheme == ThemeMode.light);
  }

  // Check if current theme is light
  bool get isLightMode => state == ThemeMode.light;
}
