import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // Dummy weather data
  final List<WeatherData> _weatherData = [
    WeatherData(
      date: DateTime.now(),
      temperature: 28,
      humidity: 65,
      rainfall: 0,
      windSpeed: 12,
      condition: 'Sunny',
      icon: Icons.wb_sunny,
      color: Colors.orange,
    ),
    WeatherData(
      date: DateTime.now().add(const Duration(days: 1)),
      temperature: 26,
      humidity: 70,
      rainfall: 5,
      windSpeed: 15,
      condition: 'Partly Cloudy',
      icon: Icons.wb_cloudy,
      color: Colors.blue,
    ),
    WeatherData(
      date: DateTime.now().add(const Duration(days: 2)),
      temperature: 24,
      humidity: 80,
      rainfall: 15,
      windSpeed: 18,
      condition: 'Rainy',
      icon: Icons.grain,
      color: Colors.indigo,
    ),
    WeatherData(
      date: DateTime.now().add(const Duration(days: 3)),
      temperature: 25,
      humidity: 75,
      rainfall: 8,
      windSpeed: 14,
      condition: 'Cloudy',
      icon: Icons.cloud,
      color: Colors.grey,
    ),
    WeatherData(
      date: DateTime.now().add(const Duration(days: 4)),
      temperature: 27,
      humidity: 68,
      rainfall: 2,
      windSpeed: 10,
      condition: 'Sunny',
      icon: Icons.wb_sunny,
      color: Colors.orange,
    ),
  ];

  final List<WeatherAlert> _alerts = [
    WeatherAlert(
      title: 'Rain Alert',
      message:
          'Heavy rainfall expected in next 24 hours. Prepare for irrigation.',
      type: AlertType.warning,
      time: DateTime.now().add(const Duration(hours: 2)),
    ),
    WeatherAlert(
      title: 'Temperature Drop',
      message:
          'Temperature will drop to 20°C tonight. Protect sensitive crops.',
      type: AlertType.info,
      time: DateTime.now().add(const Duration(hours: 6)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade700, Colors.blue.shade50],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Weather Card
                _buildCurrentWeatherCard(),
                const SizedBox(height: 20),

                // Weather Alerts
                if (_alerts.isNotEmpty) ...[
                  _buildAlertsSection(),
                  const SizedBox(height: 20),
                ],

                // 5-Day Forecast
                _buildForecastSection(),
                const SizedBox(height: 20),

                // Weather Tips
                _buildWeatherTips(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentWeatherCard() {
    final currentWeather = _weatherData.first;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Weather',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${currentWeather.temperature}°C',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    currentWeather.condition,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              Icon(
                currentWeather.icon,
                size: 80,
                color: currentWeather.color,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherDetail(
                  'Humidity', '${currentWeather.humidity}%', Icons.water_drop),
              _buildWeatherDetail(
                  'Wind', '${currentWeather.windSpeed} km/h', Icons.air),
              _buildWeatherDetail(
                  'Rainfall', '${currentWeather.rainfall}mm', Icons.grain),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue.shade600, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildAlertsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weather Alerts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ..._alerts.map((alert) => _buildAlertCard(alert)),
      ],
    );
  }

  Widget _buildAlertCard(WeatherAlert alert) {
    Color alertColor;
    switch (alert.type) {
      case AlertType.warning:
        alertColor = Colors.orange;
        break;
      case AlertType.info:
        alertColor = Colors.blue;
        break;
      case AlertType.danger:
        alertColor = Colors.red;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: alertColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: alertColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: alertColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'In ${_getTimeUntil(alert.time)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '5-Day Forecast',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: _weatherData
                .map((weather) => _buildForecastItem(weather))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildForecastItem(WeatherData weather) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              _getDayName(weather.date),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Icon(
              weather.icon,
              color: weather.color,
              size: 24,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              weather.condition,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${weather.temperature}°C',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Farming Tips',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildTipItem(
                'Irrigation',
                'Reduce irrigation frequency due to expected rainfall',
                Icons.water_drop,
                Colors.blue,
              ),
              const Divider(),
              _buildTipItem(
                'Crop Protection',
                'Monitor for fungal diseases after rainfall',
                Icons.eco,
                Colors.green,
              ),
              const Divider(),
              _buildTipItem(
                'Harvesting',
                'Ideal conditions for harvesting in 2-3 days',
                Icons.agriculture,
                Colors.orange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipItem(
      String title, String description, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(DateTime date) {
    if (date.day == DateTime.now().day) return 'Today';
    if (date.day == DateTime.now().add(const Duration(days: 1)).day)
      return 'Tomorrow';
    return _getWeekdayName(date.weekday);
  }

  String _getWeekdayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _getTimeUntil(DateTime time) {
    final difference = time.difference(DateTime.now());
    if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Now';
    }
  }
}

class WeatherData {
  final DateTime date;
  final int temperature;
  final int humidity;
  final int rainfall;
  final int windSpeed;
  final String condition;
  final IconData icon;
  final Color color;

  WeatherData({
    required this.date,
    required this.temperature,
    required this.humidity,
    required this.rainfall,
    required this.windSpeed,
    required this.condition,
    required this.icon,
    required this.color,
  });
}

class WeatherAlert {
  final String title;
  final String message;
  final AlertType type;
  final DateTime time;

  WeatherAlert({
    required this.title,
    required this.message,
    required this.type,
    required this.time,
  });
}

enum AlertType { info, warning, danger }
