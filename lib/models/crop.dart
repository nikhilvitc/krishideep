class Crop {
  final String id;
  final String name;
  final String nameHindi;
  final String description;
  final double expectedYield; // kg per acre
  final double profitMargin; // percentage
  final double sustainabilityScore; // 0-10 scale
  final List<String> suitableConditions;
  final String imageUrl;

  Crop({
    required this.id,
    required this.name,
    required this.nameHindi,
    required this.description,
    required this.expectedYield,
    required this.profitMargin,
    required this.sustainabilityScore,
    required this.suitableConditions,
    this.imageUrl = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameHindi': nameHindi,
      'description': description,
      'expectedYield': expectedYield,
      'profitMargin': profitMargin,
      'sustainabilityScore': sustainabilityScore,
      'suitableConditions': suitableConditions,
      'imageUrl': imageUrl,
    };
  }

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'],
      name: json['name'],
      nameHindi: json['nameHindi'],
      description: json['description'],
      expectedYield: json['expectedYield'].toDouble(),
      profitMargin: json['profitMargin'].toDouble(),
      sustainabilityScore: json['sustainabilityScore'].toDouble(),
      suitableConditions: List<String>.from(json['suitableConditions']),
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
