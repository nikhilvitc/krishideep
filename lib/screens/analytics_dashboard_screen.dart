import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/analytics_dashboard_service.dart';
import '../models/analytics_dashboard.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen>
    with TickerProviderStateMixin {
  final AnalyticsDashboardService _service = AnalyticsDashboardService();
  late TabController _tabController;

  AnalyticsDashboardSummary? _dashboardSummary;
  List<YieldPrediction> _yieldPredictions = [];
  List<PerformanceReport> _performanceReports = [];
  List<EnvironmentalTracking> _environmentalRecords = [];

  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadDashboardData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final farmerId = 'DEMO_FARMER_001';

      // Load all dashboard data in parallel
      final results = await Future.wait([
        _service.getDashboardSummary(farmerId),
        _service.getYieldPredictions(farmerId),
        _service.getPerformanceReports(farmerId),
      ]);

      setState(() {
        _dashboardSummary = results[0] as AnalyticsDashboardSummary;
        _yieldPredictions = results[1] as List<YieldPrediction>;
        _performanceReports = results[2] as List<PerformanceReport>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('analytics_dashboard'.tr()),
        backgroundColor: Colors.purple.shade600,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'overview'.tr()),
            Tab(text: 'yield_predictions'.tr()),
            Tab(text: 'performance'.tr()),
            Tab(text: 'environment'.tr()),
          ],
        ),
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
                        onPressed: _loadDashboardData,
                        child: Text('retry'.tr()),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(),
                    _buildYieldPredictionsTab(),
                    _buildPerformanceTab(),
                    _buildEnvironmentTab(),
                  ],
                ),
    );
  }

  Widget _buildOverviewTab() {
    if (_dashboardSummary == null)
      return const Center(child: Text('No data available'));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Farm Health Score Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.health_and_safety,
                          color: Colors.green.shade600),
                      const SizedBox(width: 8),
                      Text(
                        'farm_health_score'.tr(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                            Text(
                              '${_dashboardSummary!.farmHealthScore.toStringAsFixed(1)}/100',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: _getHealthScoreColor(
                                    _dashboardSummary!.farmHealthScore),
                              ),
                            ),
                            Text(
                              _getHealthScoreLabel(
                                  _dashboardSummary!.farmHealthScore),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CircularProgressIndicator(
                        value: _dashboardSummary!.farmHealthScore / 100,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getHealthScoreColor(
                              _dashboardSummary!.farmHealthScore),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Key Metrics Grid
          Text(
            'key_metrics'.tr(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildMetricCard(
                'Expected Yield',
                '${_dashboardSummary!.keyMetrics['expectedYield']?.toStringAsFixed(0) ?? '0'} kg',
                Icons.agriculture,
                Colors.green,
              ),
              _buildMetricCard(
                'Yield Confidence',
                '${_dashboardSummary!.keyMetrics['yieldConfidence']?.toStringAsFixed(0) ?? '0'}%',
                Icons.trending_up,
                Colors.blue,
              ),
              _buildMetricCard(
                'Performance Score',
                '${_dashboardSummary!.keyMetrics['overallPerformance']?.toStringAsFixed(0) ?? '0'}/100',
                Icons.analytics,
                Colors.purple,
              ),
              _buildMetricCard(
                'Environmental Score',
                '${_dashboardSummary!.keyMetrics['environmentalScore']?.toStringAsFixed(0) ?? '0'}/100',
                Icons.eco,
                Colors.teal,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Alerts Section
          if (_dashboardSummary!.alerts.isNotEmpty) ...[
            Text(
              'alerts'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._dashboardSummary!.alerts.map((alert) => Card(
                  color: Colors.orange.shade50,
                  child: ListTile(
                    leading: Icon(Icons.warning, color: Colors.orange.shade600),
                    title: Text(alert),
                    dense: true,
                  ),
                )),
          ],

          const SizedBox(height: 16),

          // Quick Recommendations
          if (_dashboardSummary!.quickRecommendations.isNotEmpty) ...[
            Text(
              'quick_recommendations'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._dashboardSummary!.quickRecommendations
                .map((recommendation) => Card(
                      child: ListTile(
                        leading:
                            Icon(Icons.lightbulb, color: Colors.amber.shade600),
                        title: Text(recommendation),
                        dense: true,
                      ),
                    )),
          ],
        ],
      ),
    );
  }

  Widget _buildYieldPredictionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'yield_predictions'.tr(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _generateNewPrediction(),
                icon: const Icon(Icons.add),
                label: Text('generate_new'.tr()),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_yieldPredictions.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                    'No yield predictions available. Generate one to get started.'),
              ),
            )
          else
            ..._yieldPredictions
                .map((prediction) => _buildYieldPredictionCard(prediction)),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'performance_reports'.tr(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _generateNewReport(),
                icon: const Icon(Icons.assessment),
                label: Text('generate_report'.tr()),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_performanceReports.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                    'No performance reports available. Generate one to get started.'),
              ),
            )
          else
            ..._performanceReports
                .map((report) => _buildPerformanceReportCard(report)),
        ],
      ),
    );
  }

  Widget _buildEnvironmentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'environmental_tracking'.tr(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _generateEnvironmentalTracking(),
                icon: const Icon(Icons.eco),
                label: Text('track_environment'.tr()),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_environmentalRecords.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                    'No environmental records available. Start tracking to get insights.'),
              ),
            )
          else
            ..._environmentalRecords
                .map((record) => _buildEnvironmentalRecordCard(record)),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYieldPredictionCard(YieldPrediction prediction) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  prediction.cropType,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getConfidenceColor(prediction.confidenceLevel),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${prediction.confidenceLevel.toStringAsFixed(0)}%',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
                'Predicted Yield: ${prediction.totalPredictedYield.toStringAsFixed(0)} kg'),
            Text('Farm Size: ${prediction.farmSize.toStringAsFixed(1)} acres'),
            Text(
                'Harvest Date: ${_formatDate(prediction.harvestPredictionDate)}'),
            const SizedBox(height: 8),
            if (prediction.recommendations.isNotEmpty) ...[
              const Divider(),
              Text(
                'Recommendations:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              ...prediction.recommendations
                  .take(2)
                  .map((rec) => Text('• $rec')),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceReportCard(PerformanceReport report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  report.reportType,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPerformanceColor(report.overallPerformanceScore),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${report.overallPerformanceScore.toStringAsFixed(0)}/100',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Grade: ${report.performanceGrade}'),
            Text(
                'Period: ${_formatDate(report.reportPeriodStart)} - ${_formatDate(report.reportPeriodEnd)}'),
            Text(
                'Net Profit: ₹${report.financialData.netProfit.toStringAsFixed(0)}'),
            const SizedBox(height: 8),
            if (report.achievements.isNotEmpty) ...[
              const Divider(),
              Text(
                'Achievements:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              ...report.achievements
                  .take(2)
                  .map((achievement) => Text('• $achievement')),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEnvironmentalRecordCard(EnvironmentalTracking record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Environmental Record',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getEnvironmentalColor(
                        record.overallEnvironmentalScore),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${record.overallEnvironmentalScore.toStringAsFixed(0)}/100',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Date: ${_formatDate(record.recordDate)}'),
            Text(
                'Soil Health: ${record.soilData.biodiversityIndex.toStringAsFixed(0)}'),
            Text(
                'Water Efficiency: ${record.waterData.irrigationEfficiency.toStringAsFixed(0)}%'),
            Text(
                'Air Quality: ${_getAirQualityStatus(record.airQualityData.airQualityIndex)}'),
            const SizedBox(height: 8),
            if (record.environmentalAlerts.isNotEmpty) ...[
              const Divider(),
              Text(
                'Alerts:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              ...record.environmentalAlerts
                  .take(2)
                  .map((alert) => Text('• $alert')),
            ],
          ],
        ),
      ),
    );
  }

  Color _getHealthScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getHealthScoreLabel(double score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs Improvement';
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 80) return Colors.green;
    if (confidence >= 60) return Colors.orange;
    return Colors.red;
  }

  Color _getPerformanceColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Color _getEnvironmentalColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getAirQualityStatus(double aqi) {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy for Sensitive';
    if (aqi <= 200) return 'Unhealthy';
    return 'Very Unhealthy';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _generateNewPrediction() async {
    try {
      final farmerId = 'DEMO_FARMER_001';
      final prediction = await _service.generateYieldPrediction(
        farmerId,
        'FIELD_001',
        'wheat',
        'गेहूं',
        'Rabi',
        2.5,
        null,
      );

      setState(() {
        _yieldPredictions.insert(0, prediction);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New yield prediction generated!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _generateNewReport() async {
    try {
      final farmerId = 'DEMO_FARMER_001';
      final report = await _service.generatePerformanceReport(
        farmerId,
        'comprehensive',
        DateTime.now().subtract(const Duration(days: 90)),
        DateTime.now(),
        null,
      );

      setState(() {
        _performanceReports.insert(0, report);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New performance report generated!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _generateEnvironmentalTracking() async {
    try {
      final farmerId = 'DEMO_FARMER_001';
      final tracking = await _service.generateEnvironmentalTracking(
        farmerId,
        'FIELD_001',
        null,
      );

      setState(() {
        _environmentalRecords.insert(0, tracking);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('New environmental tracking record created!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
