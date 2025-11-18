import 'dart:math';

/// Mock Weather Service
/// Simulates OpenWeatherMap API responses
class WeatherService {
  static Future<WeatherForecast> getWeatherForecast(
    String destination,
    DateTime startDate,
    DateTime endDate,
  ) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Generate mock forecast data
    final days = endDate.difference(startDate).inDays + 1;
    final forecasts = <DailyForecast>[];

    for (int i = 0; i < min(days, 7); i++) {
      forecasts.add(_generateDailyForecast(startDate.add(Duration(days: i))));
    }

    return WeatherForecast(
      destination: destination,
      forecasts: forecasts,
      summary: _generateSummary(forecasts),
      recommendations: _generateRecommendations(forecasts),
    );
  }

  static DailyForecast _generateDailyForecast(DateTime date) {
    final random = Random(date.millisecondsSinceEpoch);

    // Generate temperature based on month (seasonal variation)
    final month = date.month;
    double baseTemp;
    if (month >= 6 && month <= 8) {
      // Summer
      baseTemp = 25 + random.nextDouble() * 10;
    } else if (month >= 12 || month <= 2) {
      // Winter
      baseTemp = 5 + random.nextDouble() * 10;
    } else {
      // Spring/Fall
      baseTemp = 15 + random.nextDouble() * 10;
    }

    final tempHigh = baseTemp + random.nextDouble() * 5;
    final tempLow = baseTemp - random.nextDouble() * 5;

    // Generate weather condition
    final conditionIndex = random.nextInt(100);
    final WeatherCondition condition;
    final String icon;

    if (conditionIndex < 60) {
      condition = WeatherCondition.sunny;
      icon = '☀️';
    } else if (conditionIndex < 75) {
      condition = WeatherCondition.partlyCloudy;
      icon = '⛅';
    } else if (conditionIndex < 85) {
      condition = WeatherCondition.cloudy;
      icon = '☁️';
    } else if (conditionIndex < 95) {
      condition = WeatherCondition.rainy;
      icon = '🌧️';
    } else {
      condition = WeatherCondition.stormy;
      icon = '⛈️';
    }

    return DailyForecast(
      date: date,
      tempHigh: tempHigh,
      tempLow: tempLow,
      condition: condition,
      icon: icon,
      humidity: 40 + random.nextInt(40),
      windSpeed: 5 + random.nextInt(20),
      precipChance: condition == WeatherCondition.rainy || condition == WeatherCondition.stormy
          ? 60 + random.nextInt(40)
          : random.nextInt(30),
      description: _getWeatherDescription(condition),
    );
  }

  static String _getWeatherDescription(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return 'Clear and sunny';
      case WeatherCondition.partlyCloudy:
        return 'Partly cloudy';
      case WeatherCondition.cloudy:
        return 'Overcast';
      case WeatherCondition.rainy:
        return 'Light rain';
      case WeatherCondition.stormy:
        return 'Thunderstorms';
      case WeatherCondition.snowy:
        return 'Snow expected';
    }
  }

  static String _generateSummary(List<DailyForecast> forecasts) {
    if (forecasts.isEmpty) return 'No forecast available';

    final avgTemp = forecasts.map((f) => (f.tempHigh + f.tempLow) / 2).reduce((a, b) => a + b) / forecasts.length;
    final rainyDays = forecasts.where((f) =>
      f.condition == WeatherCondition.rainy ||
      f.condition == WeatherCondition.stormy
    ).length;

    if (rainyDays > forecasts.length / 2) {
      return 'Expect rainy conditions throughout your trip (avg ${avgTemp.toStringAsFixed(0)}°C)';
    } else if (avgTemp > 25) {
      return 'Warm and pleasant weather expected (avg ${avgTemp.toStringAsFixed(0)}°C)';
    } else if (avgTemp < 10) {
      return 'Cool temperatures expected (avg ${avgTemp.toStringAsFixed(0)}°C)';
    } else {
      return 'Mild weather conditions (avg ${avgTemp.toStringAsFixed(0)}°C)';
    }
  }

  static List<String> _generateRecommendations(List<DailyForecast> forecasts) {
    final recommendations = <String>[];

    final rainyDays = forecasts.where((f) =>
      f.condition == WeatherCondition.rainy ||
      f.condition == WeatherCondition.stormy
    ).length;

    final avgTemp = forecasts.map((f) => (f.tempHigh + f.tempLow) / 2).reduce((a, b) => a + b) / forecasts.length;
    final maxTemp = forecasts.map((f) => f.tempHigh).reduce(max);
    final minTemp = forecasts.map((f) => f.tempLow).reduce(min);

    // Rain recommendations
    if (rainyDays > 0) {
      recommendations.add('☔ Pack an umbrella and rain jacket');
      if (rainyDays > 2) {
        recommendations.add('🧥 Bring waterproof gear');
      }
    }

    // Temperature recommendations
    if (maxTemp > 30) {
      recommendations.add('🕶️ Sunscreen and sunglasses essential');
      recommendations.add('👕 Light, breathable clothing');
    } else if (maxTemp > 20) {
      recommendations.add('👔 Light layers for comfort');
    }

    if (minTemp < 10) {
      recommendations.add('🧥 Pack a warm jacket');
      if (minTemp < 5) {
        recommendations.add('🧣 Bring warm accessories (scarf, gloves)');
      }
    }

    // Variable temperature
    if (maxTemp - minTemp > 15) {
      recommendations.add('🎽 Bring versatile layers');
    }

    // Humidity recommendations
    final avgHumidity = forecasts.map((f) => f.humidity).reduce((a, b) => a + b) / forecasts.length;
    if (avgHumidity > 70) {
      recommendations.add('💧 High humidity - pack moisture-wicking fabrics');
    }

    // Default if no specific recommendations
    if (recommendations.isEmpty) {
      recommendations.add('🌤️ Perfect weather - pack your usual travel essentials');
    }

    return recommendations;
  }
}

// Models
class WeatherForecast {
  final String destination;
  final List<DailyForecast> forecasts;
  final String summary;
  final List<String> recommendations;

  WeatherForecast({
    required this.destination,
    required this.forecasts,
    required this.summary,
    required this.recommendations,
  });
}

class DailyForecast {
  final DateTime date;
  final double tempHigh;
  final double tempLow;
  final WeatherCondition condition;
  final String icon;
  final int humidity; // percentage
  final int windSpeed; // km/h
  final int precipChance; // percentage
  final String description;

  DailyForecast({
    required this.date,
    required this.tempHigh,
    required this.tempLow,
    required this.condition,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.precipChance,
    required this.description,
  });
}

enum WeatherCondition {
  sunny,
  partlyCloudy,
  cloudy,
  rainy,
  stormy,
  snowy,
}
