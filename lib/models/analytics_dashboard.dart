// Analytics Dashboard models for yield prediction, performance reports, and environmental tracking
import 'dart:ui';

class YieldPrediction {
  final String id;
  final String farmerId;
  final String fieldId;
  final String cropType;
  final String cropTypeHindi;
  final String season;
  final DateTime predictionDate;
  final double predictedYieldPerAcre; // kg/acre
  final double totalPredictedYield; // kg
  final double farmSize; // acres
  final double confidenceLevel; // 0-100%
  final String accuracyLevel; // 'high', 'medium', 'low'
  final Map<String, double>
      factorsInfluencing; // weather, soil, irrigation, etc.
  final List<String> recommendations;
  final List<String> recommendationsHindi;
  final Map<String, dynamic> historicalComparison;
  final DateTime harvestPredictionDate;
  final Map<String, double> scenarioAnalysis; // best, expected, worst case
  final List<YieldForecastPoint> forecastPoints;
  final Map<String, dynamic> riskFactors;

  const YieldPrediction({
    required this.id,
    required this.farmerId,
    required this.fieldId,
    required this.cropType,
    required this.cropTypeHindi,
    required this.season,
    required this.predictionDate,
    required this.predictedYieldPerAcre,
    required this.totalPredictedYield,
    required this.farmSize,
    required this.confidenceLevel,
    required this.accuracyLevel,
    required this.factorsInfluencing,
    required this.recommendations,
    required this.recommendationsHindi,
    required this.historicalComparison,
    required this.harvestPredictionDate,
    required this.scenarioAnalysis,
    required this.forecastPoints,
    required this.riskFactors,
  });

  String get accuracyDisplayName {
    switch (accuracyLevel) {
      case 'high':
        return 'High Accuracy';
      case 'medium':
        return 'Medium Accuracy';
      case 'low':
        return 'Low Accuracy';
      default:
        return 'Unknown';
    }
  }

  String get accuracyDisplayNameHindi {
    switch (accuracyLevel) {
      case 'high':
        return 'उच्च सटीकता';
      case 'medium':
        return 'मध्यम सटीकता';
      case 'low':
        return 'कम सटीकता';
      default:
        return 'अज्ञात';
    }
  }

  double get yieldEfficiency =>
      (predictedYieldPerAcre / _getStandardYield(cropType)) * 100;

  double _getStandardYield(String cropType) {
    final standardYields = {
      'wheat': 2500.0,
      'rice': 3000.0,
      'cotton': 400.0,
      'maize': 3500.0,
      'sugarcane': 65000.0,
    };
    return standardYields[cropType.toLowerCase()] ?? 2000.0;
  }
}

class YieldForecastPoint {
  final DateTime date;
  final double predictedYield;
  final double confidence;
  final String growthStage;
  final String growthStageHindi;

  const YieldForecastPoint({
    required this.date,
    required this.predictedYield,
    required this.confidence,
    required this.growthStage,
    required this.growthStageHindi,
  });
}

class PerformanceReport {
  final String id;
  final String farmerId;
  final String reportType; // 'monthly', 'seasonal', 'annual', 'crop_specific'
  final DateTime reportPeriodStart;
  final DateTime reportPeriodEnd;
  final DateTime generatedAt;
  final Map<String, CropPerformanceData> cropPerformances;
  final FinancialPerformanceData financialData;
  final EnvironmentalPerformanceData environmentalData;
  final OperationalPerformanceData operationalData;
  final double overallPerformanceScore; // 0-100
  final String performanceGrade; // A+, A, B+, B, C+, C, D
  final List<String> achievements;
  final List<String> achievementsHindi;
  final List<String> improvements;
  final List<String> improvementsHindi;
  final Map<String, dynamic> benchmarkComparison;
  final List<PerformanceRecommendation> recommendations;
  final Map<String, List<double>> trendAnalysis;

  const PerformanceReport({
    required this.id,
    required this.farmerId,
    required this.reportType,
    required this.reportPeriodStart,
    required this.reportPeriodEnd,
    required this.generatedAt,
    required this.cropPerformances,
    required this.financialData,
    required this.environmentalData,
    required this.operationalData,
    required this.overallPerformanceScore,
    required this.performanceGrade,
    required this.achievements,
    required this.achievementsHindi,
    required this.improvements,
    required this.improvementsHindi,
    required this.benchmarkComparison,
    required this.recommendations,
    required this.trendAnalysis,
  });

  String get performanceLevel {
    if (overallPerformanceScore >= 90) return 'Excellent';
    if (overallPerformanceScore >= 80) return 'Very Good';
    if (overallPerformanceScore >= 70) return 'Good';
    if (overallPerformanceScore >= 60) return 'Average';
    if (overallPerformanceScore >= 50) return 'Below Average';
    return 'Poor';
  }

  String get performanceLevelHindi {
    if (overallPerformanceScore >= 90) return 'उत्कृष्ट';
    if (overallPerformanceScore >= 80) return 'बहुत अच्छा';
    if (overallPerformanceScore >= 70) return 'अच्छा';
    if (overallPerformanceScore >= 60) return 'औसत';
    if (overallPerformanceScore >= 50) return 'औसत से कम';
    return 'खराब';
  }
}

class CropPerformanceData {
  final String cropType;
  final String cropTypeHindi;
  final double areaUnderCultivation;
  final double actualYield;
  final double expectedYield;
  final double yieldEfficiency;
  final double productionCost;
  final double revenue;
  final double profit;
  final double profitPerAcre;
  final int daysToMaturity;
  final String qualityGrade;
  final double wastagePercentage;
  final Map<String, dynamic>
      inputUsage; // seeds, fertilizers, pesticides, water
  final List<String> challenges;
  final List<String> challengesHindi;
  final List<String> successes;
  final List<String> successesHindi;

  const CropPerformanceData({
    required this.cropType,
    required this.cropTypeHindi,
    required this.areaUnderCultivation,
    required this.actualYield,
    required this.expectedYield,
    required this.yieldEfficiency,
    required this.productionCost,
    required this.revenue,
    required this.profit,
    required this.profitPerAcre,
    required this.daysToMaturity,
    required this.qualityGrade,
    required this.wastagePercentage,
    required this.inputUsage,
    required this.challenges,
    required this.challengesHindi,
    required this.successes,
    required this.successesHindi,
  });

  double get roi => (profit / productionCost) * 100;
  double get yieldVariance =>
      ((actualYield - expectedYield) / expectedYield) * 100;
}

class FinancialPerformanceData {
  final double totalRevenue;
  final double totalCosts;
  final double netProfit;
  final double profitMargin;
  final double roi; // Return on Investment
  final double costPerAcre;
  final double revenuePerAcre;
  final Map<String, double> costBreakdown;
  final Map<String, double> revenueBreakdown;
  final double subsidiesReceived;
  final double loansUtilized;
  final double savingsGenerated;
  final Map<String, double> monthlyTrends;

  const FinancialPerformanceData({
    required this.totalRevenue,
    required this.totalCosts,
    required this.netProfit,
    required this.profitMargin,
    required this.roi,
    required this.costPerAcre,
    required this.revenuePerAcre,
    required this.costBreakdown,
    required this.revenueBreakdown,
    required this.subsidiesReceived,
    required this.loansUtilized,
    required this.savingsGenerated,
    required this.monthlyTrends,
  });
}

class EnvironmentalPerformanceData {
  final double waterUsageEfficiency;
  final double soilHealthScore;
  final double carbonFootprint; // kg CO2 equivalent
  final double organicMatterImprovement;
  final double biodiversityIndex;
  final Map<String, double> resourceUtilization;
  final double sustainabilityScore; // 0-100
  final List<String> environmentalBenefits;
  final List<String> environmentalBenefitsHindi;
  final Map<String, double> pollutionMetrics;
  final double renewableEnergyUsage;
  final double wasteReduction;

  const EnvironmentalPerformanceData({
    required this.waterUsageEfficiency,
    required this.soilHealthScore,
    required this.carbonFootprint,
    required this.organicMatterImprovement,
    required this.biodiversityIndex,
    required this.resourceUtilization,
    required this.sustainabilityScore,
    required this.environmentalBenefits,
    required this.environmentalBenefitsHindi,
    required this.pollutionMetrics,
    required this.renewableEnergyUsage,
    required this.wasteReduction,
  });

  String get sustainabilityLevel {
    if (sustainabilityScore >= 80) return 'Highly Sustainable';
    if (sustainabilityScore >= 60) return 'Sustainable';
    if (sustainabilityScore >= 40) return 'Moderately Sustainable';
    return 'Needs Improvement';
  }

  String get sustainabilityLevelHindi {
    if (sustainabilityScore >= 80) return 'अत्यधिक टिकाऊ';
    if (sustainabilityScore >= 60) return 'टिकाऊ';
    if (sustainabilityScore >= 40) return 'मध्यम टिकाऊ';
    return 'सुधार की आवश्यकता';
  }
}

class OperationalPerformanceData {
  final double farmingEfficiency;
  final double technologyAdoption;
  final double laborProductivity;
  final double equipmentUtilization;
  final int automationLevel; // 0-100%
  final Map<String, double> taskCompletionTimes;
  final double downtime; // in hours
  final double maintenanceCosts;
  final List<String> processImprovements;
  final List<String> processImprovementsHindi;
  final Map<String, dynamic> digitalizationMetrics;

  const OperationalPerformanceData({
    required this.farmingEfficiency,
    required this.technologyAdoption,
    required this.laborProductivity,
    required this.equipmentUtilization,
    required this.automationLevel,
    required this.taskCompletionTimes,
    required this.downtime,
    required this.maintenanceCosts,
    required this.processImprovements,
    required this.processImprovementsHindi,
    required this.digitalizationMetrics,
  });
}

class PerformanceRecommendation {
  final String id;
  final String category; // 'financial', 'operational', 'environmental', 'crop'
  final String priority; // 'high', 'medium', 'low'
  final String title;
  final String titleHindi;
  final String description;
  final String descriptionHindi;
  final List<String> actionSteps;
  final List<String> actionStepsHindi;
  final double expectedImprovement;
  final double implementationCost;
  final int timeToImplement; // days
  final Map<String, dynamic> resources;

  const PerformanceRecommendation({
    required this.id,
    required this.category,
    required this.priority,
    required this.title,
    required this.titleHindi,
    required this.description,
    required this.descriptionHindi,
    required this.actionSteps,
    required this.actionStepsHindi,
    required this.expectedImprovement,
    required this.implementationCost,
    required this.timeToImplement,
    required this.resources,
  });
}

class EnvironmentalTracking {
  final String id;
  final String farmerId;
  final String fieldId;
  final DateTime recordDate;
  final WeatherImpactData weatherData;
  final SoilEnvironmentData soilData;
  final WaterManagementData waterData;
  final AirQualityData airQualityData;
  final BiodiversityData biodiversityData;
  final Map<String, double> pollutionLevels;
  final double overallEnvironmentalScore; // 0-100
  final List<String> environmentalAlerts;
  final List<String> environmentalAlertsHindi;
  final Map<String, dynamic> sustainabilityMetrics;
  final List<EnvironmentalRecommendation> recommendations;

  const EnvironmentalTracking({
    required this.id,
    required this.farmerId,
    required this.fieldId,
    required this.recordDate,
    required this.weatherData,
    required this.soilData,
    required this.waterData,
    required this.airQualityData,
    required this.biodiversityData,
    required this.pollutionLevels,
    required this.overallEnvironmentalScore,
    required this.environmentalAlerts,
    required this.environmentalAlertsHindi,
    required this.sustainabilityMetrics,
    required this.recommendations,
  });

  String get environmentalGrade {
    if (overallEnvironmentalScore >= 90) return 'A+';
    if (overallEnvironmentalScore >= 85) return 'A';
    if (overallEnvironmentalScore >= 80) return 'B+';
    if (overallEnvironmentalScore >= 75) return 'B';
    if (overallEnvironmentalScore >= 70) return 'C+';
    if (overallEnvironmentalScore >= 65) return 'C';
    return 'D';
  }
}

class WeatherImpactData {
  final double temperature; // °C
  final double humidity; // %
  final double rainfall; // mm
  final double windSpeed; // km/h
  final double solarRadiation; // MJ/m²
  final int growingDegreeDays;
  final double evapotranspiration;
  final String weatherStress; // 'none', 'low', 'medium', 'high'
  final List<String> weatherEvents; // drought, flood, storm, etc.

  const WeatherImpactData({
    required this.temperature,
    required this.humidity,
    required this.rainfall,
    required this.windSpeed,
    required this.solarRadiation,
    required this.growingDegreeDays,
    required this.evapotranspiration,
    required this.weatherStress,
    required this.weatherEvents,
  });
}

class SoilEnvironmentData {
  final double organicCarbon; // %
  final double nitrogenContent; // ppm
  final double phosphorusContent; // ppm
  final double potassiumContent; // ppm
  final double microbialActivity;
  final double erosionRate; // tons/hectare/year
  final double compactionLevel;
  final double biodiversityIndex;
  final List<String> beneficialOrganisms;

  const SoilEnvironmentData({
    required this.organicCarbon,
    required this.nitrogenContent,
    required this.phosphorusContent,
    required this.potassiumContent,
    required this.microbialActivity,
    required this.erosionRate,
    required this.compactionLevel,
    required this.biodiversityIndex,
    required this.beneficialOrganisms,
  });
}

class WaterManagementData {
  final double waterConsumption; // liters
  final double irrigationEfficiency; // %
  final double waterWastage; // liters
  final double groundwaterLevel; // meters
  final double waterQualityIndex; // 0-100
  final double runoffReduction; // %
  final List<String> conservationMethods;
  final List<String> conservationMethodsHindi;

  const WaterManagementData({
    required this.waterConsumption,
    required this.irrigationEfficiency,
    required this.waterWastage,
    required this.groundwaterLevel,
    required this.waterQualityIndex,
    required this.runoffReduction,
    required this.conservationMethods,
    required this.conservationMethodsHindi,
  });
}

class AirQualityData {
  final double pm25Level; // μg/m³
  final double pm10Level; // μg/m³
  final double coLevel; // ppm
  final double no2Level; // ppm
  final double so2Level; // ppm
  final double airQualityIndex; // 0-500
  final String airQualityStatus; // 'good', 'moderate', 'unhealthy'

  const AirQualityData({
    required this.pm25Level,
    required this.pm10Level,
    required this.coLevel,
    required this.no2Level,
    required this.so2Level,
    required this.airQualityIndex,
    required this.airQualityStatus,
  });
}

class BiodiversityData {
  final int plantSpeciesCount;
  final int animalSpeciesCount;
  final int beneficialInsectCount;
  final double ecosystemHealth; // 0-100
  final List<String> threatenedSpecies;
  final List<String> conservationEfforts;
  final List<String> conservationEffortsHindi;

  const BiodiversityData({
    required this.plantSpeciesCount,
    required this.animalSpeciesCount,
    required this.beneficialInsectCount,
    required this.ecosystemHealth,
    required this.threatenedSpecies,
    required this.conservationEfforts,
    required this.conservationEffortsHindi,
  });
}

class EnvironmentalRecommendation {
  final String id;
  final String type; // 'soil', 'water', 'air', 'biodiversity'
  final String urgency; // 'immediate', 'short_term', 'long_term'
  final String title;
  final String titleHindi;
  final String description;
  final String descriptionHindi;
  final List<String> benefits;
  final List<String> benefitsHindi;
  final double implementationCost;
  final double environmentalImpact; // positive impact score 0-100
  final int timeframe; // days to implement

  const EnvironmentalRecommendation({
    required this.id,
    required this.type,
    required this.urgency,
    required this.title,
    required this.titleHindi,
    required this.description,
    required this.descriptionHindi,
    required this.benefits,
    required this.benefitsHindi,
    required this.implementationCost,
    required this.environmentalImpact,
    required this.timeframe,
  });
}

class AnalyticsDashboardSummary {
  final String farmerId;
  final DateTime lastUpdated;
  final Map<String, dynamic> keyMetrics;
  final List<String> alerts;
  final List<String> alertsHindi;
  final Map<String, double> performanceIndicators;
  final List<String> quickRecommendations;
  final List<String> quickRecommendationsHindi;
  final Map<String, dynamic> trends;
  final double farmHealthScore; // Overall farm health 0-100

  const AnalyticsDashboardSummary({
    required this.farmerId,
    required this.lastUpdated,
    required this.keyMetrics,
    required this.alerts,
    required this.alertsHindi,
    required this.performanceIndicators,
    required this.quickRecommendations,
    required this.quickRecommendationsHindi,
    required this.trends,
    required this.farmHealthScore,
  });

  String get farmHealthGrade {
    if (farmHealthScore >= 90) return 'A+';
    if (farmHealthScore >= 85) return 'A';
    if (farmHealthScore >= 80) return 'B+';
    if (farmHealthScore >= 75) return 'B';
    if (farmHealthScore >= 70) return 'C+';
    if (farmHealthScore >= 65) return 'C';
    return 'D';
  }

  Color get farmHealthColor {
    if (farmHealthScore >= 80) return const Color(0xFF4CAF50); // Green
    if (farmHealthScore >= 60) return const Color(0xFF2196F3); // Blue
    if (farmHealthScore >= 40) return const Color(0xFFFF9800); // Orange
    return const Color(0xFFF44336); // Red
  }
}
