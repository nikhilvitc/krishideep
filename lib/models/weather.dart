class WeatherData {
  final String location;
  final double temperature;
  final double humidity;
  final String condition;
  final String conditionHindi;
  final double rainfall;
  final double windSpeed;
  final DateTime timestamp;
  final List<WeatherForecast> forecast;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.humidity,
    required this.condition,
    required this.conditionHindi,
    required this.rainfall,
    required this.windSpeed,
    required this.timestamp,
    required this.forecast,
  });

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'temperature': temperature,
      'humidity': humidity,
      'condition': condition,
      'conditionHindi': conditionHindi,
      'rainfall': rainfall,
      'windSpeed': windSpeed,
      'timestamp': timestamp.toIso8601String(),
      'forecast': forecast.map((f) => f.toJson()).toList(),
    };
  }

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      location: json['location'],
      temperature: json['temperature'],
      humidity: json['humidity'],
      condition: json['condition'],
      conditionHindi: json['conditionHindi'],
      rainfall: json['rainfall'],
      windSpeed: json['windSpeed'],
      timestamp: DateTime.parse(json['timestamp']),
      forecast: (json['forecast'] as List)
          .map((f) => WeatherForecast.fromJson(f))
          .toList(),
    );
  }
}

class WeatherForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String conditionHindi;
  final double rainProbability;

  WeatherForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.conditionHindi,
    required this.rainProbability,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'maxTemp': maxTemp,
      'minTemp': minTemp,
      'condition': condition,
      'conditionHindi': conditionHindi,
      'rainProbability': rainProbability,
    };
  }

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: DateTime.parse(json['date']),
      maxTemp: json['maxTemp'],
      minTemp: json['minTemp'],
      condition: json['condition'],
      conditionHindi: json['conditionHindi'],
      rainProbability: json['rainProbability'],
    );
  }
}

class WeatherAlert {
  final String id;
  final String title;
  final String titleHindi;
  final String description;
  final String descriptionHindi;
  final String severity; // low, medium, high, critical
  final DateTime alertTime;
  final DateTime expiryTime;

  WeatherAlert({
    required this.id,
    required this.title,
    required this.titleHindi,
    required this.description,
    required this.descriptionHindi,
    required this.severity,
    required this.alertTime,
    required this.expiryTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'titleHindi': titleHindi,
      'description': description,
      'descriptionHindi': descriptionHindi,
      'severity': severity,
      'alertTime': alertTime.toIso8601String(),
      'expiryTime': expiryTime.toIso8601String(),
    };
  }

  factory WeatherAlert.fromJson(Map<String, dynamic> json) {
    return WeatherAlert(
      id: json['id'],
      title: json['title'],
      titleHindi: json['titleHindi'],
      description: json['description'],
      descriptionHindi: json['descriptionHindi'],
      severity: json['severity'],
      alertTime: DateTime.parse(json['alertTime']),
      expiryTime: DateTime.parse(json['expiryTime']),
    );
  }
}
