import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_model.freezed.dart';
part 'weather_model.g.dart';

@freezed
class WeatherForecast with _$WeatherForecast {
  const factory WeatherForecast({
    required String location,
    required DateTime startDate,
    required DateTime endDate,
    required double avgTemperature, // in Celsius
    required String condition,
    String? icon,
    @Default([]) List<DailyWeather> dailyForecasts,
    @Default([]) List<String> recommendations,
  }) = _WeatherForecast;

  factory WeatherForecast.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecastFromJson(json);
}

@freezed
class DailyWeather with _$DailyWeather {
  const factory DailyWeather({
    required DateTime date,
    required double temperature,
    required String condition,
    String? icon,
    double? precipitation,
    double? humidity,
    double? windSpeed,
  }) = _DailyWeather;

  factory DailyWeather.fromJson(Map<String, dynamic> json) =>
      _$DailyWeatherFromJson(json);
}
