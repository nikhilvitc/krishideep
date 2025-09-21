import 'dart:math' as math;
import 'dart:io';
import '../models/crop.dart';
import '../models/crop_advice.dart';
import '../models/crop_recommendation.dart';
import '../models/disease_detection.dart';

class CropService {
  // Dummy crop data for demonstration
  static final List<Crop> _dummyCrops = [
    Crop(
      id: '1',
      name: 'Rice',
      nameHindi: 'चावल',
      description:
          'Staple crop suitable for humid regions with good water availability',
      expectedYield: 2500, // kg per acre
      profitMargin: 25.5,
      sustainabilityScore: 7.8,
      suitableConditions: ['High moisture', 'pH 6.0-7.5', 'Fertile soil'],
    ),
    Crop(
      id: '2',
      name: 'Wheat',
      nameHindi: 'गेहूं',
      description:
          'Winter crop suitable for cooler regions with moderate water needs',
      expectedYield: 1800,
      profitMargin: 30.2,
      sustainabilityScore: 8.2,
      suitableConditions: [
        'Moderate moisture',
        'pH 6.5-7.5',
        'Well-drained soil',
      ],
    ),
    Crop(
      id: '3',
      name: 'Maize',
      nameHindi: 'मक्का',
      description: 'Versatile crop suitable for various climatic conditions',
      expectedYield: 3200,
      profitMargin: 35.8,
      sustainabilityScore: 7.5,
      suitableConditions: ['Moderate moisture', 'pH 6.0-7.0', 'Fertile soil'],
    ),
    Crop(
      id: '4',
      name: 'Sugarcane',
      nameHindi: 'गन्ना',
      description: 'Cash crop requiring high water and warm climate',
      expectedYield: 45000,
      profitMargin: 28.5,
      sustainabilityScore: 6.5,
      suitableConditions: ['High moisture', 'pH 6.5-7.5', 'Rich fertile soil'],
    ),
    Crop(
      id: '5',
      name: 'Cotton',
      nameHindi: 'कपास',
      description: 'Fiber crop suitable for black cotton soil regions',
      expectedYield: 800,
      profitMargin: 32.1,
      sustainabilityScore: 6.8,
      suitableConditions: [
        'Moderate moisture',
        'pH 6.0-8.0',
        'Black cotton soil',
      ],
    ),
  ];

  // Simulate AI-based crop recommendation
  Future<CropRecommendation> getCropRecommendation(
    CropAdviceRequest request,
  ) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    // Simple rule-based recommendation logic (replace with actual AI model)
    List<Crop> recommendedCrops = [];

    for (var crop in _dummyCrops) {
      double suitabilityScore = _calculateSuitabilityScore(crop, request);
      if (suitabilityScore > 0.6) {
        // Modify crop data based on request parameters
        recommendedCrops.add(
          Crop(
            id: crop.id,
            name: crop.name,
            nameHindi: crop.nameHindi,
            description: crop.description,
            expectedYield: crop.expectedYield * suitabilityScore,
            profitMargin: crop.profitMargin * suitabilityScore,
            sustainabilityScore: crop.sustainabilityScore,
            suitableConditions: crop.suitableConditions,
          ),
        );
      }
    }

    // Sort by expected yield
    recommendedCrops.sort((a, b) => b.expectedYield.compareTo(a.expectedYield));

    // Take top 3 recommendations
    if (recommendedCrops.length > 3) {
      recommendedCrops = recommendedCrops.take(3).toList();
    }

    String recommendation = _generateRecommendationText(
      request,
      recommendedCrops,
    );
    String confidenceLevel = recommendedCrops.isNotEmpty ? 'High' : 'Low';

    return CropRecommendation(
      recommendedCrops: recommendedCrops,
      recommendation: recommendation,
      confidenceLevel: confidenceLevel,
      timestamp: DateTime.now(),
      analysisData: {
        'soilPH': request.soilPH,
        'soilMoisture': request.soilMoisture,
        'farmSize': request.farmSize,
        'location': request.location,
      },
    );
  }

  // Calculate suitability score based on soil conditions
  double _calculateSuitabilityScore(Crop crop, CropAdviceRequest request) {
    double score = 0.5; // Base score

    // pH suitability
    if (crop.name == 'Rice' && request.soilPH >= 6.0 && request.soilPH <= 7.5) {
      score += 0.2;
    } else if (crop.name == 'Wheat' &&
        request.soilPH >= 6.5 &&
        request.soilPH <= 7.5) {
      score += 0.2;
    } else if (crop.name == 'Maize' &&
        request.soilPH >= 6.0 &&
        request.soilPH <= 7.0) {
      score += 0.2;
    } else if (crop.name == 'Sugarcane' &&
        request.soilPH >= 6.5 &&
        request.soilPH <= 7.5) {
      score += 0.2;
    } else if (crop.name == 'Cotton' &&
        request.soilPH >= 6.0 &&
        request.soilPH <= 8.0) {
      score += 0.2;
    }

    // Moisture suitability
    if ((crop.name == 'Rice' || crop.name == 'Sugarcane') &&
        request.soilMoisture > 60) {
      score += 0.2;
    } else if ((crop.name == 'Wheat' ||
            crop.name == 'Maize' ||
            crop.name == 'Cotton') &&
        request.soilMoisture >= 30 &&
        request.soilMoisture <= 70) {
      score += 0.2;
    }

    // Farm size consideration
    if (request.farmSize > 5) {
      score += 0.1;
    }

    return math.min(score, 1.0);
  }

  // Generate recommendation text
  String _generateRecommendationText(
    CropAdviceRequest request,
    List<Crop> crops,
  ) {
    if (crops.isEmpty) {
      return 'Based on your soil conditions (pH: ${request.soilPH}, Moisture: ${request.soilMoisture}%), '
          'we recommend consulting with local agricultural experts for personalized advice.';
    }

    String topCrop = crops.first.name;
    return 'Based on your soil analysis (pH: ${request.soilPH}, Moisture: ${request.soilMoisture}%), '
        '$topCrop appears to be the most suitable crop for your ${request.farmSize}-acre farm. '
        'The recommended crops are well-suited for your soil conditions and climate.';
  }

  // Simulate disease detection using ML model
  Future<DiseaseDetectionResult> detectDisease(File imageFile) async {
    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 3));

    // Dummy disease detection results
    final List<DiseaseDetectionResult> possibleDiseases = [
      DiseaseDetectionResult(
        diseaseName: 'Leaf Blight',
        diseaseNameHindi: 'पत्ती झुलसा',
        description:
            'A common fungal disease affecting crop leaves, causing brown spots and eventual leaf death.',
        confidence: 87.5,
        severity: 'Moderate',
        treatments: [
          'Apply fungicide spray',
          'Remove affected leaves',
          'Improve air circulation',
          'Reduce humidity around plants',
        ],
        prevention: [
          'Use resistant varieties',
          'Proper spacing between plants',
          'Avoid overhead watering',
          'Regular field inspection',
        ],
      ),
      DiseaseDetectionResult(
        diseaseName: 'Powdery Mildew',
        diseaseNameHindi: 'चूर्णी फफूंदी',
        description:
            'White powdery growth on leaves and stems, reducing photosynthesis.',
        confidence: 82.3,
        severity: 'Mild',
        treatments: [
          'Sulfur-based fungicides',
          'Neem oil application',
          'Baking soda spray',
          'Remove infected parts',
        ],
        prevention: [
          'Good air circulation',
          'Avoid overcrowding',
          'Water at soil level',
          'Regular monitoring',
        ],
      ),
      DiseaseDetectionResult(
        diseaseName: 'Healthy Plant',
        diseaseNameHindi: 'स्वस्थ पौधा',
        description:
            'The plant appears healthy with no visible signs of disease.',
        confidence: 92.8,
        severity: 'None',
        treatments: [
          'Continue regular care',
          'Maintain proper nutrition',
          'Monitor regularly',
        ],
        prevention: [
          'Regular inspection',
          'Proper watering',
          'Balanced fertilization',
          'Good field hygiene',
        ],
      ),
    ];

    // Randomly select a result for demonstration
    final random = math.Random();
    return possibleDiseases[random.nextInt(possibleDiseases.length)];
  }

  // Get all available crops
  List<Crop> getAllCrops() {
    return _dummyCrops;
  }

  // Search crops by name
  List<Crop> searchCrops(String query) {
    return _dummyCrops
        .where(
          (crop) =>
              crop.name.toLowerCase().contains(query.toLowerCase()) ||
              crop.nameHindi.contains(query),
        )
        .toList();
  }
}
