class DiseaseDetectionResult {
  final String diseaseName;
  final String diseaseNameHindi;
  final String description;
  final double confidence; // percentage
  final String severity;
  final List<String> treatments;
  final List<String> prevention;
  final String imageUrl;

  DiseaseDetectionResult({
    required this.diseaseName,
    required this.diseaseNameHindi,
    required this.description,
    required this.confidence,
    required this.severity,
    required this.treatments,
    required this.prevention,
    this.imageUrl = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'diseaseName': diseaseName,
      'diseaseNameHindi': diseaseNameHindi,
      'description': description,
      'confidence': confidence,
      'severity': severity,
      'treatments': treatments,
      'prevention': prevention,
      'imageUrl': imageUrl,
    };
  }

  factory DiseaseDetectionResult.fromJson(Map<String, dynamic> json) {
    return DiseaseDetectionResult(
      diseaseName: json['diseaseName'],
      diseaseNameHindi: json['diseaseNameHindi'],
      description: json['description'],
      confidence: json['confidence'].toDouble(),
      severity: json['severity'],
      treatments: List<String>.from(json['treatments']),
      prevention: List<String>.from(json['prevention']),
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
