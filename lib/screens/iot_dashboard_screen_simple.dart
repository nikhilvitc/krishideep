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
  List<String> _sensors = [];
  SoilData? _latestData;
  List<SensorAlert> _alerts = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      // Load sensors and latest data
      final sensors = await _iotService.getRegisteredSensors();
      final latestData = sensors.isNotEmpty
          ? await _iotService.getLatestSoilData(sensors.first)
          : null;
      final alerts = await _iotService.getActiveSensorAlerts(null);

      setState(() {
        _sensors = sensors;
        _latestData = latestData;
        _alerts = alerts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load dashboard data: $e';
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
            onPressed: _loadDashboardData,
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
                onPressed: _loadDashboardData,
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sensors Overview
          _buildSensorsOverview(),
          const SizedBox(height: 16),

          // Latest Soil Data
          if (_latestData != null) ...[
            _buildSoilDataCard(),
            const SizedBox(height: 16),
          ],

          // Alerts Section
          _buildAlertsSection(),
          const SizedBox(height: 16),

          // Quick Actions
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildSensorsOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sensors, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                Text(
                  'registered_sensors'.tr(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_sensors.isEmpty)
              Text('No sensors registered')
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _sensors
                    .map((sensor) => Chip(
                          avatar: Icon(Icons.sensors, size: 16),
                          label: Text(sensor),
                          backgroundColor: Colors.green.shade100,
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoilDataCard() {
    final data = _latestData!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.grass, color: Colors.green.shade600),
                const SizedBox(width: 8),
                Text(
                  'latest_soil_data'.tr(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  DateFormat('MMM dd, HH:mm').format(data.timestamp),
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildMetricCard(
                  'moisture'.tr(),
                  '${data.moistureLevel.toStringAsFixed(1)}%',
                  Icons.water_drop,
                  Colors.blue,
                ),
                _buildMetricCard(
                  'ph_level'.tr(),
                  data.phLevel.toStringAsFixed(1),
                  Icons.science,
                  Colors.purple,
                ),
                _buildMetricCard(
                  'nitrogen'.tr(),
                  '${data.nitrogen.toStringAsFixed(1)}mg/kg',
                  Icons.eco,
                  Colors.green,
                ),
                _buildMetricCard(
                  'temperature'.tr(),
                  '${data.temperature.toStringAsFixed(1)}°C',
                  Icons.thermostat,
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
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
    );
  }

  Widget _buildAlertsSection() {
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
                  'active_alerts'.tr(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_alerts.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade600),
                    const SizedBox(width: 8),
                    Text('No active alerts - All systems normal'),
                  ],
                ),
              )
            else
              ...(_alerts.take(3).map((alert) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getAlertColor(alert.severity).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getAlertColor(alert.severity).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getAlertIcon(alert.severity),
                          color: _getAlertColor(alert.severity),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alert.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              if (alert.message.isNotEmpty)
                                Text(
                                  alert.message,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'quick_actions'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2,
              children: [
                _buildActionButton(
                  'schedule_irrigation'.tr(),
                  Icons.water,
                  Colors.blue,
                  () => _scheduleIrrigation(),
                ),
                _buildActionButton(
                  'generate_report'.tr(),
                  Icons.assignment,
                  Colors.green,
                  () => _generateReport(),
                ),
                _buildActionButton(
                  'view_recommendations'.tr(),
                  Icons.lightbulb,
                  Colors.orange,
                  () => _viewRecommendations(),
                ),
                _buildActionButton(
                  'sensor_statistics'.tr(),
                  Icons.analytics,
                  Colors.purple,
                  () => _viewStatistics(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getAlertColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.yellow.shade700;
      default:
        return Colors.grey;
    }
  }

  IconData _getAlertIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Icons.error;
      case 'medium':
        return Icons.warning;
      case 'low':
        return Icons.info;
      default:
        return Icons.notification_important;
    }
  }

  void _scheduleIrrigation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Irrigation scheduling feature coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _generateReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Generating soil health report...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _viewRecommendations() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Loading AI recommendations...'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _viewStatistics() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Loading sensor statistics...'),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
