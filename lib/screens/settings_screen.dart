import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants/app_colors.dart';
import '/providers/theme_provider.dart';
import '/providers/temperature_unit_provider.dart'; // Add this import
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
              subtitle: 'Use current location',
              icon: Icons.location_on_outlined,
              onTap: () {},
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
}
