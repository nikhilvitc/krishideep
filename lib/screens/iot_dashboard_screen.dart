import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/iot_sensor_service.dart';
import '../models/iot_sensor.dart';

class IoTDashboardScreen extends StatefulWidget {
  const IoTDashboardScreen({super.key});

  @override
  State<IoTDashboardScreen> createState() => _IoTDashboardScreenState();
}

class _IoTDashboardScreenState extends State<IoTDashboardScreen> {
  final IoTSensorService _iotService = IoTSensorService();
  List<SoilData> _sensorData = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadSensorData();
  }

  Future<void> _loadSensorData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final sensors = await _iotService.getRegisteredSensors();
      final data = <SoilData>[];
      for (String sensorId in sensors) {
        final sensorData = await _iotService.getLatestSoilData(sensorId);
        if (sensorData != null) {
          data.add(sensorData);
        }
      }

      setState(() {
        _sensorData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load sensor data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('iot_dashboard'.tr()),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 64, color: Colors.red.shade300),
                      const SizedBox(height: 16),
                      Text(_error, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadSensorData,
                        child: Text('retry'.tr()),
                      ),
                    ],
                  ),
                )
              : _sensorData.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sensors_off,
                              size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            'no_sensor_data'.tr(),
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Summary Cards
                          _buildSummaryCards(),
                          const SizedBox(height: 24),

                          // Sensor Data List
                          Text(
                            'sensor_data'.tr(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),

                          ..._sensorData.map((data) => _buildSensorCard(data)),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildSummaryCards() {
    if (_sensorData.isEmpty) return const SizedBox.shrink();

    final latestData = _sensorData.first;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'moisture'.tr(),
            '${latestData.moistureLevel.toStringAsFixed(1)}%',
            Icons.water_drop,
            Colors.blue,
            latestData.moistureStatus,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'temperature'.tr(),
            '${latestData.temperature.toStringAsFixed(1)}°C',
            Icons.thermostat,
            Colors.orange,
            _getTemperatureStatus(latestData.temperature),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color, String status) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(fontSize: 12, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorCard(SoilData data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sensor ${data.sensorId}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  _formatTime(data.timestamp),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Sensor readings grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                _buildReadingItem('moisture'.tr(),
                    '${data.moistureLevel.toStringAsFixed(1)}%', Colors.blue),
                _buildReadingItem('temperature'.tr(),
                    '${data.temperature.toStringAsFixed(1)}°C', Colors.orange),
                _buildReadingItem('humidity'.tr(),
                    '${data.humidity.toStringAsFixed(1)}%', Colors.green),
                _buildReadingItem('ph_level'.tr(),
                    data.phLevel.toStringAsFixed(1), Colors.purple),
                _buildReadingItem('nitrogen'.tr(),
                    '${data.nitrogen.toStringAsFixed(0)} ppm', Colors.red),
                _buildReadingItem('phosphorus'.tr(),
                    '${data.phosphorus.toStringAsFixed(0)} ppm', Colors.teal),
              ],
            ),

            const SizedBox(height: 16),

            // Location
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  data.location,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 10, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  String _getTemperatureStatus(double temperature) {
    if (temperature < 15) return 'Cold';
    if (temperature < 25) return 'Optimal';
    if (temperature < 35) return 'Warm';
    return 'Hot';
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
