class WeatherData {
  final double temperature;      // Celsius
  final String condition;        // "Sunny", "Cloudy", "Rainy", dll
  final int humidity;            // 0-100
  final double windSpeed;        // m/s
  final String iconUrl;          // URL ke weather icon
  final String description;      // Deskripsi panjang cuaca

  WeatherData({
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.iconUrl,
    required this.description,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['main'] as String,
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      iconUrl: 'https://openweathermap.org/img/wn/${json['weather'][0]['icon']}@2x.png',
      description: json['weather'][0]['description'] as String,
    );
  }
}
