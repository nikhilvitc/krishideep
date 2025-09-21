import 'crop.dart';

class CropRecommendation {
  final List<Crop> recommendedCrops;
  final String recommendation;
  final String confidenceLevel;
  final DateTime timestamp;
  final Map<String, dynamic> analysisData;

  CropRecommendation({
    required this.recommendedCrops,
    required this.recommendation,
    required this.confidenceLevel,
    required this.timestamp,
    required this.analysisData,
  });

  Map<String, dynamic> toJson() {
    return {
      'recommendedCrops': recommendedCrops
          .map((crop) => crop.toJson())
          .toList(),
      'recommendation': recommendation,
      'confidenceLevel': confidenceLevel,
      'timestamp': timestamp.toIso8601String(),
      'analysisData': analysisData,
    };
  }

  factory CropRecommendation.fromJson(Map<String, dynamic> json) {
    return CropRecommendation(
      recommendedCrops: (json['recommendedCrops'] as List)
          .map((crop) => Crop.fromJson(crop))
          .toList(),
      recommendation: json['recommendation'],
      confidenceLevel: json['confidenceLevel'],
      timestamp: DateTime.parse(json['timestamp']),
      analysisData: json['analysisData'],
    );
  }
}
