import 'package:flutter/material.dart';
import 'package:weather/pages/sidebar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import '../services/weather_service.dart';
import 'models.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _weatherService =
      WeatherService('8f51e5d168b4b9ae22773e2d7218a2d7'); //api key
  Weather? _weather;
  bool _isLoading = true;

  _fetchWeather() async {
    try {
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      final weather = await _weatherService.getWeatherByCoordinates(
          position.latitude, position.longitude);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  String getWeatherBackground(String? mainCondition) {
    if (mainCondition == null) return 'lib/assets/sunny day.jpeg';

    // Get the current hour to determine day or night
    final now = DateTime.now();
    final hour = now.hour;
    final isDaytime = hour >= 6 && hour < 18;

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return isDaytime ? 'lib/assets/clouds day.jpeg' : 'lib/assets/clouds night.jpeg';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return isDaytime ? 'lib/assets/rain day.jpeg' : 'lib/assets/rain night.jpeg';
      case 'thunderstorm':
        return isDaytime ? 'lib/assets/thunder day.jpeg' : 'lib/assets/thunder night.jpeg';
      case 'clear':
        return isDaytime ? 'lib/assets/sunny day.jpeg' : 'lib/assets/clear night.jpeg';
      default:
        return isDaytime ? 'lib/assets/sunny day.jpeg' : 'lib/assets/clear night.jpeg';
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'lib/assets/sunny.json'; //default
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'lib/assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'lib/assets/rain.json';
      case 'thunderstorm':
        return 'lib/assets/thunder.json';
      case 'clear':
        return 'lib/assets/sunny.json';
      default:
        return 'lib/assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Lottie.asset('lib/assets/loading.json'), // loading animation
        ),
      );
    }
    double fahrenheit = (((9 * _weather!.temperature) / 5) + 32);
    double reamur = ((4 * _weather!.temperature) / 5);
    double kelvin = (_weather!.temperature + 273);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
        centerTitle: true,
        title: Text(
          _weather?.cityName.toUpperCase() ?? "Loading City..",
          style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Mondapick'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const Sidebar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(getWeatherBackground(_weather?.mainCondition)),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 110,
              ),
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition),
                  height: 200),
              Text(
                '${_weather?.temperature.round()}°C',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                  fontFamily: 'Mondapick',
                  color: Colors.white,
                ),
              ),
              Text(
                'Feels like : ${_weather?.feelslike.round()}°C',
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Mondapick',
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20,),
              Text(
                _weather?.mainCondition ?? "",
                style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontFamily: 'Mondapick'
                ),
              ),
              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Fahrenheit:',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                              fontFamily: 'Mondapick'),
                        ),
                        Text(
                          '${fahrenheit.toStringAsFixed(2)}°F',
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black45,),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Reamur:',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                              fontFamily: 'Mondapick'),
                        ),
                        Text(
                          '${reamur.toStringAsFixed(2)}°R',
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black45,),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Kelvin:',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                              fontFamily: 'Mondapick'),
                        ),
                        Text(
                          '${kelvin.toStringAsFixed(2)}°K',
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black45,),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 157.5,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin:
                        const EdgeInsets.only(left: 15, bottom: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Wind Speed',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                              fontFamily: 'Mondapick'),
                        ),
                        Text(
                          '${_weather?.windSpeed ?? 0} m/s',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 157.5,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.only(right: 15, bottom: 15, left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Humidity',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                              fontFamily: 'Mondapick'),
                        ),
                        Text(
                          '${_weather?.humidity ?? 0}%',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20)
                ),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Temp. Min',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45,
                                  fontFamily: 'Mondapick'
                              ),
                            ),
                            Text(
                              '${_weather?.tempmin ?? 0}°C',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Temp. Max',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45,
                                  fontFamily: 'Mondapick'
                              ),
                            ),
                            Text(
                              '${_weather?.tempmax ?? 0}°C',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text('Pressure:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                            fontFamily: 'Mondapick'
                          ),
                        ),
                        Text(
                          '${_weather?.pressure ?? 0}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
