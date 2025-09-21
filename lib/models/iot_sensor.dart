// IoT Sensor models for soil monitoring and automated recommendations
class SoilData {
  final String sensorId;
  final DateTime timestamp;
  final double moistureLevel; // Percentage (0-100)
  final double temperature; // Celsius
  final double humidity; // Percentage (0-100)
  final double phLevel; // pH scale (0-14)
  final double nitrogen; // ppm
  final double phosphorus; // ppm
  final double potassium; // ppm
  final double electricalConductivity; // µS/cm
  final double organicMatter; // Percentage
  final String location;
  final String locationHindi;
  final Map<String, dynamic> additionalParams;

  const SoilData({
    required this.sensorId,
    required this.timestamp,
    required this.moistureLevel,
    required this.temperature,
    required this.humidity,
    required this.phLevel,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.electricalConductivity,
    required this.organicMatter,
    required this.location,
    required this.locationHindi,
    this.additionalParams = const {},
  });

  String get moistureStatus {
    if (moistureLevel < 20) return 'Low';
    if (moistureLevel < 40) return 'Moderate';
    if (moistureLevel < 70) return 'Good';
    return 'High';
  }

  String get moistureStatusHindi {
    if (moistureLevel < 20) return 'कम';
    if (moistureLevel < 40) return 'मध्यम';
    if (moistureLevel < 70) return 'अच्छी';
    return 'अधिक';
  }

  String get phStatus {
    if (phLevel < 6.0) return 'Acidic';
    if (phLevel < 7.5) return 'Neutral';
    return 'Alkaline';
  }

  String get phStatusHindi {
    if (phLevel < 6.0) return 'अम्लीय';
    if (phLevel < 7.5) return 'न्यूट्रल';
    return 'क्षारीय';
  }

  String get nutrientStatus {
    final nLevel = nitrogen > 40 ? 2 : (nitrogen > 20 ? 1 : 0);
    final pLevel = phosphorus > 25 ? 2 : (phosphorus > 15 ? 1 : 0);
    final kLevel = potassium > 200 ? 2 : (potassium > 120 ? 1 : 0);

    final avgLevel = (nLevel + pLevel + kLevel) / 3;

    if (avgLevel < 0.5) return 'Deficient';
    if (avgLevel < 1.5) return 'Moderate';
    return 'Adequate';
  }

  String get nutrientStatusHindi {
    final nLevel = nitrogen > 40 ? 2 : (nitrogen > 20 ? 1 : 0);
    final pLevel = phosphorus > 25 ? 2 : (phosphorus > 15 ? 1 : 0);
    final kLevel = potassium > 200 ? 2 : (potassium > 120 ? 1 : 0);

    final avgLevel = (nLevel + pLevel + kLevel) / 3;

    if (avgLevel < 0.5) return 'कमी';
    if (avgLevel < 1.5) return 'मध्यम';
    return 'पर्याप्त';
  }
}

class SensorAlert {
  final String id;
  final String sensorId;
  final String alertType; // 'moisture', 'ph', 'nutrient', 'temperature'
  final String severity; // 'low', 'medium', 'high', 'critical'
  final String title;
  final String titleHindi;
  final String message;
  final String messageHindi;
  final String recommendation;
  final String recommendationHindi;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final bool isRead;
  final bool isActive;
  final Map<String, dynamic> alertData;

  const SensorAlert({
    required this.id,
    required this.sensorId,
    required this.alertType,
    required this.severity,
    required this.title,
    required this.titleHindi,
    required this.message,
    required this.messageHindi,
    required this.recommendation,
    required this.recommendationHindi,
    required this.createdAt,
    this.resolvedAt,
    this.isRead = false,
    this.isActive = true,
    this.alertData = const {},
  });
}

class IrrigationSchedule {
  final String id;
  final String sensorId;
  final String fieldName;
  final String fieldNameHindi;
  final DateTime scheduledTime;
  final int durationMinutes;
  final double waterAmount; // Liters
  final String scheduleType; // 'automatic', 'manual', 'sensor_based'
  final String status; // 'pending', 'active', 'completed', 'cancelled'
  final String reason;
  final String reasonHindi;
  final DateTime createdAt;
  final DateTime? completedAt;
  final Map<String, dynamic> irrigationData;

  const IrrigationSchedule({
    required this.id,
    required this.sensorId,
    required this.fieldName,
    required this.fieldNameHindi,
    required this.scheduledTime,
    required this.durationMinutes,
    required this.waterAmount,
    required this.scheduleType,
    required this.status,
    required this.reason,
    required this.reasonHindi,
    required this.createdAt,
    this.completedAt,
    this.irrigationData = const {},
  });

  String get statusDisplayName {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'active':
        return 'Running';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  String get statusDisplayNameHindi {
    switch (status) {
      case 'pending':
        return 'लंबित';
      case 'active':
        return 'चल रहा';
      case 'completed':
        return 'पूर्ण';
      case 'cancelled':
        return 'रद्द';
      default:
        return 'अज्ञात';
    }
  }
}

class AutomatedRecommendation {
  final String id;
  final String sensorId;
  final String
      recommendationType; // 'irrigation', 'fertilizer', 'pest_control', 'planting', 'harvesting'
  final String priority; // 'low', 'medium', 'high', 'urgent'
  final String title;
  final String titleHindi;
  final String description;
  final String descriptionHindi;
  final List<String> actionItems;
  final List<String> actionItemsHindi;
  final Map<String, dynamic> recommendationData;
  final DateTime generatedAt;
  final DateTime? implementedAt;
  final bool isImplemented;
  final String confidence; // 'low', 'medium', 'high'
  final List<String> benefits;
  final List<String> benefitsHindi;
  final Map<String, dynamic> expectedOutcome;

  const AutomatedRecommendation({
    required this.id,
    required this.sensorId,
    required this.recommendationType,
    required this.priority,
    required this.title,
    required this.titleHindi,
    required this.description,
    required this.descriptionHindi,
    required this.actionItems,
    required this.actionItemsHindi,
    required this.recommendationData,
    required this.generatedAt,
    this.implementedAt,
    this.isImplemented = false,
    required this.confidence,
    required this.benefits,
    required this.benefitsHindi,
    required this.expectedOutcome,
  });

  String get priorityDisplayName {
    switch (priority) {
      case 'low':
        return 'Low Priority';
      case 'medium':
        return 'Medium Priority';
      case 'high':
        return 'High Priority';
      case 'urgent':
        return 'Urgent';
      default:
        return 'Unknown';
    }
  }

  String get priorityDisplayNameHindi {
    switch (priority) {
      case 'low':
        return 'कम प्राथमिकता';
      case 'medium':
        return 'मध्यम प्राथमिकता';
      case 'high':
        return 'उच्च प्राथमिकता';
      case 'urgent':
        return 'तत्काल';
      default:
        return 'अज्ञात';
    }
  }
}

class SoilHealthReport {
  final String id;
  final String sensorId;
  final String fieldName;
  final String fieldNameHindi;
  final DateTime generatedAt;
  final SoilData currentData;
  final Map<String, dynamic> historicalComparison;
  final double overallHealthScore; // 0-100
  final String healthGrade; // A+, A, B+, B, C+, C, D
  final List<String> strengths;
  final List<String> strengthsHindi;
  final List<String> weaknesses;
  final List<String> weaknessesHindi;
  final List<AutomatedRecommendation> recommendations;
  final Map<String, dynamic> trendAnalysis;
  final Map<String, dynamic> cropSuitability;

  const SoilHealthReport({
    required this.id,
    required this.sensorId,
    required this.fieldName,
    required this.fieldNameHindi,
    required this.generatedAt,
    required this.currentData,
    required this.historicalComparison,
    required this.overallHealthScore,
    required this.healthGrade,
    required this.strengths,
    required this.strengthsHindi,
    required this.weaknesses,
    required this.weaknessesHindi,
    required this.recommendations,
    required this.trendAnalysis,
    required this.cropSuitability,
  });

  String get healthStatus {
    if (overallHealthScore >= 90) return 'Excellent';
    if (overallHealthScore >= 80) return 'Very Good';
    if (overallHealthScore >= 70) return 'Good';
    if (overallHealthScore >= 60) return 'Average';
    if (overallHealthScore >= 50) return 'Below Average';
    return 'Poor';
  }

  String get healthStatusHindi {
    if (overallHealthScore >= 90) return 'उत्कृष्ट';
    if (overallHealthScore >= 80) return 'बहुत अच्छा';
    if (overallHealthScore >= 70) return 'अच्छा';
    if (overallHealthScore >= 60) return 'औसत';
    if (overallHealthScore >= 50) return 'औसत से कम';
    return 'खराब';
  }
}
