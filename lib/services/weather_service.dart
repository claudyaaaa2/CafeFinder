import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static final WeatherService _instance = WeatherService._internal();
  final String apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';
  final Map<String, WeatherData> _cache = {};
  final Map<String, DateTime> _cacheTime = {};
  static const int _cacheExpireMinutes = 10; // Cache durasi 10 menit

  factory WeatherService() {
    return _instance;
  }

  WeatherService._internal();

  /// Cek apakah cache masih valid (belum lebih dari 10 menit)
  bool _isCacheValid(String key) {
    if (!_cacheTime.containsKey(key)) return false;
    final duration = DateTime.now().difference(_cacheTime[key]!);
    return duration.inMinutes < _cacheExpireMinutes;
  }

  /// Request permission dan dapatkan lokasi user
  Future<Position> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah GPS service aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Cek permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    // Ambil lokasi user
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Fetch cuaca dari OpenWeatherMap API
  Future<WeatherData> getWeather() async {
    try {
      // Dapatkan lokasi user
      final position = await _getUserLocation();
      final cacheKey = '${position.latitude},${position.longitude}';

      // Return dari cache jika masih valid
      if (_cache.containsKey(cacheKey) && _isCacheValid(cacheKey)) {
        print('WeatherService: Returning cached weather data');
        return _cache[cacheKey]!;
      }

      // Fetch dari API
      if (apiKey.isEmpty) {
        throw Exception('WEATHER_API_KEY tidak tersetting di .env');
      }

      final response = await http
          .get(
            Uri.parse(
              'https://api.openweathermap.org/data/2.5/weather?'
              'lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric',
            ),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final weather = WeatherData.fromJson(data);

        // Simpan ke cache
        _cache[cacheKey] = weather;
        _cacheTime[cacheKey] = DateTime.now();

        return weather;
      } else {
        throw Exception('Gagal fetch cuaca: ${response.statusCode}');
      }
    } catch (e) {
      print('WeatherService Error: $e');
      rethrow;
    }
  }
}
