class MarketPrice {
  final String id;
  final String cropName;
  final String cropNameHindi;
  final double currentPrice; // per quintal in INR
  final double previousPrice;
  final double changePercentage;
  final String market;
  final String marketHindi;
  final String state;
  final String stateHindi;
  final DateTime timestamp;
  final String priceUnit;
  final String grade;

  MarketPrice({
    required this.id,
    required this.cropName,
    required this.cropNameHindi,
    required this.currentPrice,
    required this.previousPrice,
    required this.changePercentage,
    required this.market,
    required this.marketHindi,
    required this.state,
    required this.stateHindi,
    required this.timestamp,
    this.priceUnit = 'per quintal',
    this.grade = 'FAQ',
  });

  bool get isPriceIncreased => changePercentage > 0;
  bool get isPriceDecreased => changePercentage < 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cropName': cropName,
      'cropNameHindi': cropNameHindi,
      'currentPrice': currentPrice,
      'previousPrice': previousPrice,
      'changePercentage': changePercentage,
      'market': market,
      'marketHindi': marketHindi,
      'state': state,
      'stateHindi': stateHindi,
      'timestamp': timestamp.toIso8601String(),
      'priceUnit': priceUnit,
      'grade': grade,
    };
  }

  factory MarketPrice.fromJson(Map<String, dynamic> json) {
    return MarketPrice(
      id: json['id'],
      cropName: json['cropName'],
      cropNameHindi: json['cropNameHindi'],
      currentPrice: json['currentPrice'],
      previousPrice: json['previousPrice'],
      changePercentage: json['changePercentage'],
      market: json['market'],
      marketHindi: json['marketHindi'],
      state: json['state'],
      stateHindi: json['stateHindi'],
      timestamp: DateTime.parse(json['timestamp']),
      priceUnit: json['priceUnit'] ?? 'per quintal',
      grade: json['grade'] ?? 'FAQ',
    );
  }
}

class PriceTrend {
  final String cropName;
  final List<PricePoint> priceHistory;
  final double averagePrice;
  final double highestPrice;
  final double lowestPrice;
  final String trend; // increasing, decreasing, stable
  final double volatilityIndex;

  PriceTrend({
    required this.cropName,
    required this.priceHistory,
    required this.averagePrice,
    required this.highestPrice,
    required this.lowestPrice,
    required this.trend,
    required this.volatilityIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'cropName': cropName,
      'priceHistory': priceHistory.map((p) => p.toJson()).toList(),
      'averagePrice': averagePrice,
      'highestPrice': highestPrice,
      'lowestPrice': lowestPrice,
      'trend': trend,
      'volatilityIndex': volatilityIndex,
    };
  }

  factory PriceTrend.fromJson(Map<String, dynamic> json) {
    return PriceTrend(
      cropName: json['cropName'],
      priceHistory: (json['priceHistory'] as List)
          .map((p) => PricePoint.fromJson(p))
          .toList(),
      averagePrice: json['averagePrice'],
      highestPrice: json['highestPrice'],
      lowestPrice: json['lowestPrice'],
      trend: json['trend'],
      volatilityIndex: json['volatilityIndex'],
    );
  }
}

class PricePoint {
  final DateTime date;
  final double price;

  PricePoint({
    required this.date,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'price': price,
    };
  }

  factory PricePoint.fromJson(Map<String, dynamic> json) {
    return PricePoint(
      date: DateTime.parse(json['date']),
      price: json['price'],
    );
  }
}

class MarketAlert {
  final String id;
  final String cropName;
  final String alertType; // price_drop, price_surge, best_time_to_sell
  final String title;
  final String titleHindi;
  final String message;
  final String messageHindi;
  final double targetPrice;
  final double currentPrice;
  final DateTime createdAt;
  final bool isActive;

  MarketAlert({
    required this.id,
    required this.cropName,
    required this.alertType,
    required this.title,
    required this.titleHindi,
    required this.message,
    required this.messageHindi,
    required this.targetPrice,
    required this.currentPrice,
    required this.createdAt,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cropName': cropName,
      'alertType': alertType,
      'title': title,
      'titleHindi': titleHindi,
      'message': message,
      'messageHindi': messageHindi,
      'targetPrice': targetPrice,
      'currentPrice': currentPrice,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory MarketAlert.fromJson(Map<String, dynamic> json) {
    return MarketAlert(
      id: json['id'],
      cropName: json['cropName'],
      alertType: json['alertType'],
      title: json['title'],
      titleHindi: json['titleHindi'],
      message: json['message'],
      messageHindi: json['messageHindi'],
      targetPrice: json['targetPrice'],
      currentPrice: json['currentPrice'],
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isActive'] ?? true,
    );
  }
}

class BestSellingLocation {
  final String marketName;
  final String marketNameHindi;
  final String state;
  final String stateHindi;
  final double price;
  final double distance; // in km
  final String transportCost;
  final double netPrice;
  final String contact;
  final double rating;

  BestSellingLocation({
    required this.marketName,
    required this.marketNameHindi,
    required this.state,
    required this.stateHindi,
    required this.price,
    required this.distance,
    required this.transportCost,
    required this.netPrice,
    required this.contact,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'marketName': marketName,
      'marketNameHindi': marketNameHindi,
      'state': state,
      'stateHindi': stateHindi,
      'price': price,
      'distance': distance,
      'transportCost': transportCost,
      'netPrice': netPrice,
      'contact': contact,
      'rating': rating,
    };
  }

  factory BestSellingLocation.fromJson(Map<String, dynamic> json) {
    return BestSellingLocation(
      marketName: json['marketName'],
      marketNameHindi: json['marketNameHindi'],
      state: json['state'],
      stateHindi: json['stateHindi'],
      price: json['price'],
      distance: json['distance'],
      transportCost: json['transportCost'],
      netPrice: json['netPrice'],
      contact: json['contact'],
      rating: json['rating'],
    );
  }
}
