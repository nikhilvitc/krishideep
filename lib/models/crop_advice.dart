class CropAdviceRequest {
  final double soilPH;
  final double soilMoisture; // percentage
  final double farmSize; // in acres
  final String location;
  final double? latitude;
  final double? longitude;
  final String? season;

  CropAdviceRequest({
    required this.soilPH,
    required this.soilMoisture,
    required this.farmSize,
    required this.location,
    this.latitude,
    this.longitude,
    this.season,
  });

  Map<String, dynamic> toJson() {
    return {
      'soilPH': soilPH,
      'soilMoisture': soilMoisture,
      'farmSize': farmSize,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'season': season,
    };
  }

  factory CropAdviceRequest.fromJson(Map<String, dynamic> json) {
    return CropAdviceRequest(
      soilPH: json['soilPH'].toDouble(),
      soilMoisture: json['soilMoisture'].toDouble(),
      farmSize: json['farmSize'].toDouble(),
      location: json['location'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      season: json['season'],
    );
  }
}
