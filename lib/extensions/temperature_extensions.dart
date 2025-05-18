import '/providers/temperature_unit_provider.dart';

extension TemperatureConversion on num {
  // Convert Celsius to Fahrenheit
  double toFahrenheit() {
    return (this * 9/5) + 32;
  }
  
  // Convert Fahrenheit to Celsius
  double toCelsius() {
    return (this - 32) * 5/9;
  }
  
  // Format temperature based on unit with degree symbol
  String formatTemperature(TemperatureUnit unit) {
    final temp = unit == TemperatureUnit.celsius ? this : toFahrenheit();
    return '${temp.round()}°${unit == TemperatureUnit.celsius ? 'C' : 'F'}';
  }
  
  // Format temperature without unit symbol
  String formatTemperatureValue(TemperatureUnit unit) {
    final temp = unit == TemperatureUnit.celsius ? this : toFahrenheit();
    return '${temp.round()}°';
  }
}
