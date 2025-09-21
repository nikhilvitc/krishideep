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
  List<IoTSensorData> _sensorData = [];
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

      final data = await _iotService.getSensorData('SENSOR_001');
      setState(() {
        _sensorData = [data];
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
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSensorData,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade700, Colors.blue.shade50],
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : _error.isNotEmpty
                ? _buildErrorWidget()
                : _buildDashboard(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error, size: 48, color: Colors.red.shade400),
              const SizedBox(height: 16),
              Text(_error, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadSensorData,
                child: Text('retry'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    if (_sensorData.isEmpty) {
      return Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sensors_off, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'no_sensor_data'.tr(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Connect IoT sensors to view real-time data'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _simulateData(),
                  child: Text('simulate_data'.tr()),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final latestData = _sensorData.first;

    return RefreshIndicator(
      onRefresh: _loadSensorData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Real-time Status Card
          _buildStatusCard(latestData),
          const SizedBox(height: 16),

          // Sensor Metrics Grid
          _buildMetricsGrid(latestData),
          const SizedBox(height: 16),

          // Charts Section
          _buildChartsSection(),
          const SizedBox(height: 16),

          // Alerts Section
          _buildAlertsSection(latestData),
          const SizedBox(height: 16),

          // Historical Data
          _buildHistoricalData(),
        ],
      ),
    );
  }

  Widget _buildStatusCard(IoTSensorData data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sensors, color: Colors.green.shade600),
                const SizedBox(width: 8),
                Text(
                  'sensor_status'.tr(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: data.isOnline ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    data.isOnline ? 'Online' : 'Offline',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sensor ID: ${data.sensorId}'),
                      Text('Location: ${data.location}'),
                      Text('Last Update: ${_formatDateTime(data.timestamp)}'),
                      Text('Battery: ${data.batteryLevel}%'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(IoTSensorData data) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildMetricCard(
          'Soil Moisture',
          '${data.moistureLevel.toStringAsFixed(1)}%',
          Icons.water_drop,
          Colors.blue,
          data.moistureLevel >= 30 ? Colors.green : Colors.orange,
        ),
        _buildMetricCard(
          'Temperature',
          '${data.temperature.toStringAsFixed(1)}°C',
          Icons.thermostat,
          Colors.red,
          data.temperature >= 20 && data.temperature <= 35
              ? Colors.green
              : Colors.orange,
        ),
        _buildMetricCard(
          'Humidity',
          '${data.humidity.toStringAsFixed(1)}%',
          Icons.opacity,
          Colors.cyan,
          data.humidity >= 40 && data.humidity <= 80
              ? Colors.green
              : Colors.orange,
        ),
        _buildMetricCard(
          'pH Level',
          data.phLevel.toStringAsFixed(1),
          Icons.science,
          Colors.purple,
          data.phLevel >= 6.0 && data.phLevel <= 7.5
              ? Colors.green
              : Colors.orange,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
    Color statusColor,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: iconColor),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'sensor_trends'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString(),
                              style: const TextStyle(fontSize: 12));
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final hours = ['6h', '12h', '18h', '24h'];
                          return Text(
                            value.toInt() < hours.length
                                ? hours[value.toInt()]
                                : '',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateSampleData(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsSection(IoTSensorData data) {
    final alerts = <String>[];

    if (data.moistureLevel < 20) alerts.add('Low soil moisture detected');
    if (data.temperature > 35) alerts.add('High temperature alert');
    if (data.phLevel < 6.0 || data.phLevel > 8.0)
      alerts.add('pH level out of optimal range');
    if (data.batteryLevel < 20) alerts.add('Low battery level');

    if (alerts.isEmpty) alerts.add('All systems normal');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orange.shade600),
                const SizedBox(width: 8),
                Text(
                  'alerts_notifications'.tr(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...alerts.map((alert) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        alerts.length == 1 &&
                                alerts.first == 'All systems normal'
                            ? Icons.check_circle
                            : Icons.info,
                        size: 16,
                        color: alerts.length == 1 &&
                                alerts.first == 'All systems normal'
                            ? Colors.green
                            : Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(alert)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoricalData() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'historical_data'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _sensorData.length.clamp(0, 5),
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final data = _sensorData[index];
                return ListTile(
                  leading: Icon(
                    Icons.sensors,
                    color: data.isOnline ? Colors.green : Colors.grey,
                  ),
                  title: Text(_formatDateTime(data.timestamp)),
                  subtitle: Text(
                    'Temp: ${data.temperature.toStringAsFixed(1)}°C, '
                    'Humidity: ${data.humidity.toStringAsFixed(1)}%, '
                    'Moisture: ${data.moistureLevel.toStringAsFixed(1)}%',
                  ),
                  trailing: Text(
                    '${data.batteryLevel}%',
                    style: TextStyle(
                      color:
                          data.batteryLevel > 50 ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateSampleData() {
    return List.generate(4, (index) {
      return FlSpot(
          index.toDouble(), 20 + (index * 10).toDouble() + (index % 2 * 5));
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, HH:mm').format(dateTime);
  }

  Future<void> _simulateData() async {
    setState(() => _isLoading = true);

    // Generate sample sensor data
    await Future.delayed(const Duration(seconds: 2));

    try {
      final data = await _iotService.getAllSensorData('FARMER_001');
      setState(() {
        _sensorData = data;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sample IoT data generated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to generate sample data: $e';
        _isLoading = false;
      });
    }
  }
}
