import 'dart:convert';
import 'package:http/http.dart' as http;
import '../pages/models.dart';

class WeatherService {
  static const base_url = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;
  WeatherService(this.apiKey);

  Future<Weather> getWeatherByCoordinates(double latitude, double longitude) async {
    final response = await http.get(Uri.parse('$base_url?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}