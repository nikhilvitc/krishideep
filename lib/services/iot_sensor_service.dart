import 'dart:math' as math;
import '../models/iot_sensor.dart';

class IoTSensorService {
  // Mock sensor database
  static final List<String> _registeredSensors = [
    'SENSOR_001',
    'SENSOR_002',
    'SENSOR_003',
    'SENSOR_004',
  ];

  static final List<SoilData> _sensorReadings = [];
  static final List<SensorAlert> _alerts = [];
  static final List<IrrigationSchedule> _irrigationSchedules = [];
  static final List<AutomatedRecommendation> _recommendations = [];
  static final List<SoilHealthReport> _healthReports = [];

  // Get all registered sensors
  Future<List<String>> getRegisteredSensors() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_registeredSensors);
  }

  // Get latest soil data for a sensor
  Future<SoilData?> getLatestSoilData(String sensorId) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Generate mock data if not exists
    if (_sensorReadings.isEmpty ||
        !_sensorReadings.any((r) => r.sensorId == sensorId)) {
      _generateMockSensorData(sensorId);
    }

    final sensorReadings =
        _sensorReadings.where((r) => r.sensorId == sensorId).toList();
    if (sensorReadings.isEmpty) return null;

    sensorReadings.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sensorReadings.first;
  }

  // Get historical soil data
  Future<List<SoilData>> getHistoricalSoilData(
    String sensorId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    // Generate mock data if needed
    if (_sensorReadings.where((r) => r.sensorId == sensorId).length < 10) {
      _generateMockHistoricalData(sensorId, startDate, endDate);
    }

    return _sensorReadings
        .where((r) =>
            r.sensorId == sensorId &&
            r.timestamp.isAfter(startDate) &&
            r.timestamp.isBefore(endDate))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // Get active sensor alerts
  Future<List<SensorAlert>> getActiveSensorAlerts(String? sensorId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // Generate mock alerts if needed
    if (_alerts.isEmpty) {
      _generateMockAlerts();
    }

    if (sensorId != null) {
      return _alerts
          .where((alert) => alert.sensorId == sensorId && alert.isActive)
          .toList();
    }

    return _alerts.where((alert) => alert.isActive).toList();
  }

  // Get irrigation schedules
  Future<List<IrrigationSchedule>> getIrrigationSchedules(
      String? sensorId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate mock schedules if needed
    if (_irrigationSchedules.isEmpty) {
      _generateMockIrrigationSchedules();
    }

    if (sensorId != null) {
      return _irrigationSchedules
          .where((schedule) => schedule.sensorId == sensorId)
          .toList();
    }

    return List.from(_irrigationSchedules);
  }

  // Schedule automatic irrigation
  Future<String> scheduleIrrigation(
    String sensorId,
    String fieldName,
    DateTime scheduledTime,
    int durationMinutes,
    double waterAmount,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final scheduleId = 'IRR_${DateTime.now().millisecondsSinceEpoch}';

    final schedule = IrrigationSchedule(
      id: scheduleId,
      sensorId: sensorId,
      fieldName: fieldName,
      fieldNameHindi: _translateFieldName(fieldName),
      scheduledTime: scheduledTime,
      durationMinutes: durationMinutes,
      waterAmount: waterAmount,
      scheduleType: 'sensor_based',
      status: 'pending',
      reason: 'Soil moisture level below optimal threshold',
      reasonHindi: 'मिट्टी की नमी का स्तर इष्टतम सीमा से कम',
      createdAt: DateTime.now(),
      irrigationData: {
        'recommendedBy': 'AI System',
        'moistureLevel': 25.5,
        'targetMoisture': 60.0,
      },
    );

    _irrigationSchedules.add(schedule);
    return scheduleId;
  }

  // Get automated recommendations
  Future<List<AutomatedRecommendation>> getRecommendations(
      String? sensorId) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Generate recommendations if needed
    if (_recommendations.isEmpty ||
        (sensorId != null &&
            !_recommendations.any((r) => r.sensorId == sensorId))) {
      await _generateRecommendations(sensorId ?? 'SENSOR_001');
    }

    if (sensorId != null) {
      return _recommendations.where((rec) => rec.sensorId == sensorId).toList();
    }

    return List.from(_recommendations);
  }

  // Generate soil health report
  Future<SoilHealthReport> generateSoilHealthReport(String sensorId) async {
    await Future.delayed(const Duration(seconds: 2));

    final latestData = await getLatestSoilData(sensorId);
    if (latestData == null) {
      throw Exception('No sensor data available for $sensorId');
    }

    final random = math.Random();
    final reportId = 'REPORT_${DateTime.now().millisecondsSinceEpoch}';

    // Calculate health score based on multiple factors
    double healthScore = _calculateSoilHealthScore(latestData);
    String healthGrade = _calculateHealthGrade(healthScore);

    final strengths = <String>[];
    final strengthsHindi = <String>[];
    final weaknesses = <String>[];
    final weaknessesHindi = <String>[];

    // Analyze soil parameters
    if (latestData.moistureLevel > 40) {
      strengths.add('Adequate soil moisture');
      strengthsHindi.add('पर्याप्त मिट्टी की नमी');
    } else {
      weaknesses.add('Low soil moisture');
      weaknessesHindi.add('मिट्टी की नमी कम');
    }

    if (latestData.phLevel >= 6.0 && latestData.phLevel <= 7.5) {
      strengths.add('Optimal pH level');
      strengthsHindi.add('इष्टतम pH स्तर');
    } else {
      weaknesses.add('pH level needs adjustment');
      weaknessesHindi.add('pH स्तर में समायोजन की आवश्यकता');
    }

    if (latestData.organicMatter > 3.0) {
      strengths.add('Good organic matter content');
      strengthsHindi.add('अच्छी जैविक पदार्थ सामग्री');
    } else {
      weaknesses.add('Low organic matter');
      weaknessesHindi.add('कम जैविक पदार्थ');
    }

    // Generate recommendations for the report
    final recommendations = await getRecommendations(sensorId);

    final report = SoilHealthReport(
      id: reportId,
      sensorId: sensorId,
      fieldName: 'Field ${sensorId.split('_').last}',
      fieldNameHindi: 'खेत ${sensorId.split('_').last}',
      generatedAt: DateTime.now(),
      currentData: latestData,
      historicalComparison: {
        'lastMonth': {
          'moistureChange': random.nextDouble() * 10 - 5,
          'phChange': random.nextDouble() * 0.5 - 0.25,
          'nutrientChange': random.nextDouble() * 20 - 10,
        },
        'lastYear': {
          'moistureChange': random.nextDouble() * 20 - 10,
          'phChange': random.nextDouble() * 1.0 - 0.5,
          'nutrientChange': random.nextDouble() * 40 - 20,
        },
      },
      overallHealthScore: healthScore,
      healthGrade: healthGrade,
      strengths: strengths,
      strengthsHindi: strengthsHindi,
      weaknesses: weaknesses,
      weaknessesHindi: weaknessesHindi,
      recommendations: recommendations,
      trendAnalysis: {
        'moistureTrend': random.nextBool() ? 'improving' : 'declining',
        'nutrientTrend': random.nextBool() ? 'stable' : 'improving',
        'phTrend': 'stable',
      },
      cropSuitability: {
        'wheat': healthScore * 0.9,
        'rice': healthScore * 0.8,
        'maize': healthScore * 0.85,
        'sugarcane': healthScore * 0.7,
        'cotton': healthScore * 0.75,
      },
    );

    _healthReports.add(report);
    return report;
  }

  // Real-time monitoring stream
  Stream<SoilData> getRealTimeData(String sensorId) async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 30)); // Every 30 seconds
      final data = _generateRealTimeSensorData(sensorId);
      _sensorReadings.add(data);
      yield data;

      // Check for alerts
      await _checkForAlerts(data);
    }
  }

  // Mark recommendation as implemented
  Future<void> markRecommendationImplemented(String recommendationId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _recommendations.indexWhere((r) => r.id == recommendationId);
    if (index != -1) {
      _recommendations[index] = AutomatedRecommendation(
        id: _recommendations[index].id,
        sensorId: _recommendations[index].sensorId,
        recommendationType: _recommendations[index].recommendationType,
        priority: _recommendations[index].priority,
        title: _recommendations[index].title,
        titleHindi: _recommendations[index].titleHindi,
        description: _recommendations[index].description,
        descriptionHindi: _recommendations[index].descriptionHindi,
        actionItems: _recommendations[index].actionItems,
        actionItemsHindi: _recommendations[index].actionItemsHindi,
        recommendationData: _recommendations[index].recommendationData,
        generatedAt: _recommendations[index].generatedAt,
        implementedAt: DateTime.now(),
        isImplemented: true,
        confidence: _recommendations[index].confidence,
        benefits: _recommendations[index].benefits,
        benefitsHindi: _recommendations[index].benefitsHindi,
        expectedOutcome: _recommendations[index].expectedOutcome,
      );
    }
  }

  // Get sensor statistics
  Future<Map<String, dynamic>> getSensorStatistics() async {
    await Future.delayed(const Duration(milliseconds: 600));

    final random = math.Random();
    final totalSensors = _registeredSensors.length;

    return {
      'totalSensors': totalSensors,
      'activeSensors': totalSensors,
      'totalReadings': _sensorReadings.length,
      'activeAlerts': _alerts.where((a) => a.isActive).length,
      'totalIrrigationSchedules': _irrigationSchedules.length,
      'completedIrrigations':
          _irrigationSchedules.where((s) => s.status == 'completed').length,
      'totalRecommendations': _recommendations.length,
      'implementedRecommendations':
          _recommendations.where((r) => r.isImplemented).length,
      'averageSoilHealth': 75.5 + random.nextDouble() * 15,
      'waterSaved': random.nextDouble() * 5000 + 1000, // Liters
      'energySaved': random.nextDouble() * 500 + 100, // kWh
      'dataPoints': {
        'today': random.nextInt(100) + 50,
        'thisWeek': random.nextInt(700) + 300,
        'thisMonth': random.nextInt(3000) + 1500,
      },
      'alertCategories': {
        'moisture': _alerts.where((a) => a.alertType == 'moisture').length,
        'nutrient': _alerts.where((a) => a.alertType == 'nutrient').length,
        'ph': _alerts.where((a) => a.alertType == 'ph').length,
        'temperature':
            _alerts.where((a) => a.alertType == 'temperature').length,
      },
    };
  }

  // Private helper methods
  void _generateMockSensorData(String sensorId) {
    final random = math.Random();
    final now = DateTime.now();

    for (int i = 0; i < 5; i++) {
      final data = SoilData(
        sensorId: sensorId,
        timestamp: now.subtract(Duration(hours: i)),
        moistureLevel: 30 + random.nextDouble() * 40,
        temperature: 20 + random.nextDouble() * 15,
        humidity: 40 + random.nextDouble() * 40,
        phLevel: 5.5 + random.nextDouble() * 3,
        nitrogen: 15 + random.nextDouble() * 40,
        phosphorus: 10 + random.nextDouble() * 30,
        potassium: 100 + random.nextDouble() * 150,
        electricalConductivity: 200 + random.nextDouble() * 800,
        organicMatter: 1.5 + random.nextDouble() * 4,
        location: 'Field ${sensorId.split('_').last}',
        locationHindi: 'खेत ${sensorId.split('_').last}',
        additionalParams: {
          'soilType': random.nextBool() ? 'Loamy' : 'Clay',
          'depth': '0-20cm',
        },
      );
      _sensorReadings.add(data);
    }
  }

  void _generateMockHistoricalData(
      String sensorId, DateTime startDate, DateTime endDate) {
    final random = math.Random();
    final days = endDate.difference(startDate).inDays;

    for (int i = 0; i < days; i++) {
      final date = startDate.add(Duration(days: i));
      final data = SoilData(
        sensorId: sensorId,
        timestamp: date,
        moistureLevel: 25 + random.nextDouble() * 50,
        temperature: 18 + random.nextDouble() * 20,
        humidity: 35 + random.nextDouble() * 50,
        phLevel: 5.0 + random.nextDouble() * 4,
        nitrogen: 10 + random.nextDouble() * 50,
        phosphorus: 8 + random.nextDouble() * 35,
        potassium: 80 + random.nextDouble() * 200,
        electricalConductivity: 150 + random.nextDouble() * 900,
        organicMatter: 1.0 + random.nextDouble() * 5,
        location: 'Field ${sensorId.split('_').last}',
        locationHindi: 'खेत ${sensorId.split('_').last}',
      );
      _sensorReadings.add(data);
    }
  }

  void _generateMockAlerts() {
    final random = math.Random();
    final alertTypes = ['moisture', 'ph', 'nutrient', 'temperature'];
    final severities = ['low', 'medium', 'high', 'critical'];

    for (int i = 0; i < 5; i++) {
      final alertType = alertTypes[random.nextInt(alertTypes.length)];
      final severity = severities[random.nextInt(severities.length)];

      String title = '';
      String titleHindi = '';
      String message = '';
      String messageHindi = '';
      String recommendation = '';
      String recommendationHindi = '';

      switch (alertType) {
        case 'moisture':
          title = 'Low Soil Moisture';
          titleHindi = 'मिट्टी की नमी कम';
          message = 'Soil moisture level has dropped below 20%';
          messageHindi = 'मिट्टी की नमी का स्तर 20% से नीचे गिर गया है';
          recommendation = 'Schedule irrigation immediately';
          recommendationHindi = 'तुरंत सिंचाई की व्यवस्था करें';
          break;
        case 'ph':
          title = 'pH Level Alert';
          titleHindi = 'pH स्तर चेतावनी';
          message = 'Soil pH is outside optimal range';
          messageHindi = 'मिट्टी का pH इष्टतम सीमा के बाहर है';
          recommendation = 'Apply lime or sulfur to adjust pH';
          recommendationHindi = 'pH समायोजित करने के लिए चूना या सल्फर डालें';
          break;
        case 'nutrient':
          title = 'Nutrient Deficiency';
          titleHindi = 'पोषक तत्वों की कमी';
          message = 'NPK levels are below recommended values';
          messageHindi = 'NPK का स्तर अनुशंसित मान से कम है';
          recommendation = 'Apply balanced fertilizer';
          recommendationHindi = 'संतुलित उर्वरक डालें';
          break;
        case 'temperature':
          title = 'Temperature Alert';
          titleHindi = 'तापमान चेतावनी';
          message = 'Soil temperature is affecting plant growth';
          messageHindi =
              'मिट्टी का तापमान पौधे की वृद्धि को प्रभावित कर रहा है';
          recommendation = 'Consider mulching or shade protection';
          recommendationHindi = 'मल्चिंग या छाया सुरक्षा पर विचार करें';
          break;
      }

      final alert = SensorAlert(
        id: 'ALERT_$i',
        sensorId: 'SENSOR_00${(i % 4) + 1}',
        alertType: alertType,
        severity: severity,
        title: title,
        titleHindi: titleHindi,
        message: message,
        messageHindi: messageHindi,
        recommendation: recommendation,
        recommendationHindi: recommendationHindi,
        createdAt: DateTime.now().subtract(Duration(hours: random.nextInt(48))),
      );

      _alerts.add(alert);
    }
  }

  void _generateMockIrrigationSchedules() {
    final random = math.Random();
    final statuses = ['pending', 'active', 'completed', 'cancelled'];

    for (int i = 0; i < 8; i++) {
      final schedule = IrrigationSchedule(
        id: 'IRR_SCHEDULE_$i',
        sensorId: 'SENSOR_00${(i % 4) + 1}',
        fieldName: 'Field ${(i % 4) + 1}',
        fieldNameHindi: 'खेत ${(i % 4) + 1}',
        scheduledTime: DateTime.now().add(Duration(hours: random.nextInt(72))),
        durationMinutes: 30 + random.nextInt(90),
        waterAmount: 500 + random.nextDouble() * 1500,
        scheduleType: random.nextBool() ? 'automatic' : 'sensor_based',
        status: statuses[random.nextInt(statuses.length)],
        reason: 'Scheduled irrigation based on soil moisture analysis',
        reasonHindi: 'मिट्टी की नमी विश्लेषण के आधार पर नियोजित सिंचाई',
        createdAt: DateTime.now().subtract(Duration(hours: random.nextInt(24))),
      );

      _irrigationSchedules.add(schedule);
    }
  }

  Future<void> _generateRecommendations(String sensorId) async {
    final random = math.Random();
    final priorities = ['medium', 'high', 'urgent'];

    final recommendations = [
      {
        'type': 'irrigation',
        'title': 'Optimize Irrigation Schedule',
        'titleHindi': 'सिंचाई कार्यक्रम का अनुकूलन करें',
        'description':
            'Based on soil moisture analysis, adjust irrigation timing for better water efficiency',
        'descriptionHindi':
            'मिट्टी की नमी विश्लेषण के आधार पर, बेहतर जल दक्षता के लिए सिंचाई समय समायोजित करें',
        'actions': [
          'Reduce irrigation frequency to every 3 days',
          'Increase water amount per session by 20%',
          'Schedule irrigation during early morning hours',
        ],
        'actionsHindi': [
          'सिंचाई की आवृत्ति को हर 3 दिन में घटाएं',
          'प्रति सत्र पानी की मात्रा 20% बढ़ाएं',
          'सुबह जल्दी सिंचाई का समय निर्धारित करें',
        ],
        'benefits': [
          'Water savings up to 25%',
          'Improved crop growth',
          'Reduced energy costs',
        ],
        'benefitsHindi': [
          '25% तक पानी की बचत',
          'फसल की बेहतर वृद्धि',
          'ऊर्जा लागत में कमी',
        ],
      },
      {
        'type': 'fertilizer',
        'title': 'Apply Nitrogen-Rich Fertilizer',
        'titleHindi': 'नाइट्रोजन युक्त उर्वरक डालें',
        'description':
            'Soil analysis shows nitrogen deficiency. Apply appropriate fertilizer to boost crop growth',
        'descriptionHindi':
            'मिट्टी विश्लेषण में नाइट्रोजन की कमी दिखी है। फसल की वृद्धि बढ़ाने के लिए उपयुक्त उर्वरक डालें',
        'actions': [
          'Apply 50kg/ha of urea fertilizer',
          'Split application into 2 doses',
          'Apply after irrigation for better absorption',
        ],
        'actionsHindi': [
          '50 किलो/हेक्टेयर यूरिया उर्वरक डालें',
          'आवेदन को 2 खुराकों में बांटें',
          'बेहतर अवशोषण के लिए सिंचाई के बाद डालें',
        ],
        'benefits': [
          'Increased crop yield by 15-20%',
          'Better plant growth and health',
          'Higher protein content in grains',
        ],
        'benefitsHindi': [
          'फसल उत्पादन में 15-20% वृद्धि',
          'पौधे की बेहतर वृद्धि और स्वास्थ्य',
          'अनाज में उच्च प्रोटीन सामग्री',
        ],
      },
    ];

    for (int i = 0; i < 2; i++) {
      final rec = recommendations[i];
      final recommendation = AutomatedRecommendation(
        id: 'REC_${DateTime.now().millisecondsSinceEpoch}_$i',
        sensorId: sensorId,
        recommendationType: rec['type'] as String,
        priority: priorities[random.nextInt(priorities.length)],
        title: rec['title'] as String,
        titleHindi: rec['titleHindi'] as String,
        description: rec['description'] as String,
        descriptionHindi: rec['descriptionHindi'] as String,
        actionItems: List<String>.from(rec['actions'] as List),
        actionItemsHindi: List<String>.from(rec['actionsHindi'] as List),
        recommendationData: {
          'basedOnSensor': sensorId,
          'confidenceLevel': 85 + random.nextInt(15),
          'implementationCost': random.nextDouble() * 5000 + 1000,
        },
        generatedAt:
            DateTime.now().subtract(Duration(hours: random.nextInt(24))),
        confidence: 'high',
        benefits: List<String>.from(rec['benefits'] as List),
        benefitsHindi: List<String>.from(rec['benefitsHindi'] as List),
        expectedOutcome: {
          'yieldIncrease': 15 + random.nextDouble() * 20,
          'costSavings': random.nextDouble() * 3000 + 500,
          'implementationTime': '7-14 days',
        },
      );

      _recommendations.add(recommendation);
    }
  }

  SoilData _generateRealTimeSensorData(String sensorId) {
    final random = math.Random();
    return SoilData(
      sensorId: sensorId,
      timestamp: DateTime.now(),
      moistureLevel: 25 + random.nextDouble() * 50,
      temperature: 18 + random.nextDouble() * 20,
      humidity: 40 + random.nextDouble() * 40,
      phLevel: 5.5 + random.nextDouble() * 3,
      nitrogen: 15 + random.nextDouble() * 40,
      phosphorus: 10 + random.nextDouble() * 30,
      potassium: 100 + random.nextDouble() * 150,
      electricalConductivity: 200 + random.nextDouble() * 800,
      organicMatter: 1.5 + random.nextDouble() * 4,
      location: 'Field ${sensorId.split('_').last}',
      locationHindi: 'खेत ${sensorId.split('_').last}',
    );
  }

  Future<void> _checkForAlerts(SoilData data) async {
    // Check moisture level
    if (data.moistureLevel < 25) {
      final alert = SensorAlert(
        id: 'ALERT_${DateTime.now().millisecondsSinceEpoch}',
        sensorId: data.sensorId,
        alertType: 'moisture',
        severity: data.moistureLevel < 15 ? 'critical' : 'high',
        title: 'Low Soil Moisture Detected',
        titleHindi: 'कम मिट्टी की नमी का पता चला',
        message:
            'Soil moisture level is ${data.moistureLevel.toStringAsFixed(1)}%',
        messageHindi:
            'मिट्टी की नमी का स्तर ${data.moistureLevel.toStringAsFixed(1)}% है',
        recommendation: 'Schedule irrigation immediately',
        recommendationHindi: 'तुरंत सिंचाई की व्यवस्था करें',
        createdAt: DateTime.now(),
      );
      _alerts.add(alert);
    }

    // Check pH level
    if (data.phLevel < 5.5 || data.phLevel > 8.0) {
      final alert = SensorAlert(
        id: 'ALERT_${DateTime.now().millisecondsSinceEpoch}_PH',
        sensorId: data.sensorId,
        alertType: 'ph',
        severity: 'medium',
        title: 'pH Level Out of Range',
        titleHindi: 'pH स्तर सीमा से बाहर',
        message: 'Current pH level is ${data.phLevel.toStringAsFixed(2)}',
        messageHindi: 'वर्तमान pH स्तर ${data.phLevel.toStringAsFixed(2)} है',
        recommendation: 'Apply lime or sulfur to adjust pH',
        recommendationHindi: 'pH समायोजित करने के लिए चूना या सल्फर डालें',
        createdAt: DateTime.now(),
      );
      _alerts.add(alert);
    }
  }

  double _calculateSoilHealthScore(SoilData data) {
    double score = 0;

    // Moisture score (25 points)
    if (data.moistureLevel >= 40 && data.moistureLevel <= 70) {
      score += 25;
    } else if (data.moistureLevel >= 30 || data.moistureLevel <= 80) {
      score += 20;
    } else {
      score += 10;
    }

    // pH score (25 points)
    if (data.phLevel >= 6.0 && data.phLevel <= 7.5) {
      score += 25;
    } else if (data.phLevel >= 5.5 && data.phLevel <= 8.0) {
      score += 20;
    } else {
      score += 10;
    }

    // Nutrient score (30 points)
    double nutrientScore = 0;
    if (data.nitrogen > 30)
      nutrientScore += 10;
    else if (data.nitrogen > 20)
      nutrientScore += 8;
    else
      nutrientScore += 5;

    if (data.phosphorus > 20)
      nutrientScore += 10;
    else if (data.phosphorus > 15)
      nutrientScore += 8;
    else
      nutrientScore += 5;

    if (data.potassium > 150)
      nutrientScore += 10;
    else if (data.potassium > 100)
      nutrientScore += 8;
    else
      nutrientScore += 5;

    score += nutrientScore;

    // Organic matter score (20 points)
    if (data.organicMatter > 3.0) {
      score += 20;
    } else if (data.organicMatter > 2.0) {
      score += 15;
    } else if (data.organicMatter > 1.0) {
      score += 10;
    } else {
      score += 5;
    }

    return score;
  }

  String _calculateHealthGrade(double score) {
    if (score >= 95) return 'A+';
    if (score >= 90) return 'A';
    if (score >= 85) return 'B+';
    if (score >= 80) return 'B';
    if (score >= 75) return 'C+';
    if (score >= 70) return 'C';
    return 'D';
  }

  String _translateFieldName(String fieldName) {
    // Simple translation helper
    return fieldName.replaceAll('Field', 'खेत');
  }
}
