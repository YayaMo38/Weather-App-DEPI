import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LocationSource {
  gps,
  manual,
}

class LocationData {
  final LocationSource source;
  final String? cityName; // Only used when source is manual
  final double? latitude;  // Can be used for both sources
  final double? longitude; // Can be used for both sources

  const LocationData({
    required this.source,
    this.cityName,
    this.latitude,
    this.longitude,
  });

  LocationData copyWith({
    LocationSource? source,
    String? cityName,
    double? latitude,
    double? longitude,
  }) {
    return LocationData(
      source: source ?? this.source,
      cityName: cityName ?? this.cityName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  // Add a method to check if we have sufficient location data
  bool get isLocationAvailable {
    return (source == LocationSource.gps && latitude != null && longitude != null) ||
           (source == LocationSource.manual && cityName != null);
  }

  // Add a formatted display name for the location
  String get displayName {
    if (source == LocationSource.manual && cityName != null) {
      return cityName!;
    } else if (latitude != null && longitude != null) {
      return 'Lat: ${latitude!.toStringAsFixed(2)}, Long: ${longitude!.toStringAsFixed(2)}';
    }
    return 'Location not available';
  }
}

// Provider for location preference
final locationProvider = StateNotifierProvider<LocationNotifier, LocationData>(
  (ref) => LocationNotifier(),
);

class LocationNotifier extends StateNotifier<LocationData> {
  LocationNotifier() 
    : super(const LocationData(source: LocationSource.gps)) {
    _loadPreference();
  }

  // Load saved preference from SharedPreferences
  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isManualLocation = prefs.getBool('use_manual_location') ?? false;
    final cityName = prefs.getString('manual_city_name');
    final latitude = prefs.getDouble('manual_latitude');
    final longitude = prefs.getDouble('manual_longitude');
    
    if (isManualLocation && cityName != null) {
      state = LocationData(
        source: LocationSource.manual,
        cityName: cityName,
        latitude: latitude,
        longitude: longitude,
      );
    } else {
      state = const LocationData(source: LocationSource.gps);
    }
  }

  // Set location source to GPS
  Future<void> useGpsLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('use_manual_location', false);
    state = const LocationData(source: LocationSource.gps);
  }

  // Set location source to manual with city name and coordinates
  Future<void> useManualLocation({
    required String cityName,
    double? latitude,
    double? longitude,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('use_manual_location', true);
    await prefs.setString('manual_city_name', cityName);
    
    if (latitude != null) {
      await prefs.setDouble('manual_latitude', latitude);
    }
    
    if (longitude != null) {
      await prefs.setDouble('manual_longitude', longitude);
    }
    
    state = LocationData(
      source: LocationSource.manual,
      cityName: cityName,
      latitude: latitude,
      longitude: longitude,
    );
  }

  // Update location coordinates (for GPS source)
  void updateGpsCoordinates(double latitude, double longitude) {
    if (state.source == LocationSource.gps) {
      state = state.copyWith(
        latitude: latitude,
        longitude: longitude,
      );
    }
  }

  // Check if location is properly set
  bool get isLocationSet => state.isLocationAvailable;
  
  // Get current location source
  LocationSource get currentSource => state.source;
}