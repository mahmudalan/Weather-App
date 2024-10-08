class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final double feelslike;
  final double tempmin;
  final double tempmax;
  final int pressure;
  final double windSpeed; // Tambahkan properti untuk kecepatan angin
  final int humidity; // Tambahkan properti untuk kelembaban udara

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.feelslike,
    required this.tempmin,
    required this.tempmax,
    required this.pressure,
    required this.windSpeed, // Tambahkan ke konstruktor
    required this.humidity, // Tambahkan ke konstruktor
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      feelslike: json['main']['feels_like'].toDouble(),
      tempmin: json['main']['temp_min'].toDouble(),
      tempmax: json['main']['temp_max'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      pressure: json['main']['pressure'],
      windSpeed: json['wind']['speed'].toDouble(), // Parsing kecepatan angin
      humidity: json['main']['humidity'], // Parsing kelembaban udara
    );
  }
}
