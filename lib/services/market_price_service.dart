import 'dart:math' as math;
import '../models/market_price.dart';

class MarketPriceService {
  // Mock crop data with Hindi names
  static final Map<String, String> _cropNames = {
    'Rice': 'चावल',
    'Wheat': 'गेहूं',
    'Maize': 'मक्का',
    'Cotton': 'कपास',
    'Sugarcane': 'गन्ना',
    'Soybean': 'सोयाबीन',
    'Mustard': 'सरसों',
    'Potato': 'आलू',
    'Onion': 'प्याज',
    'Tomato': 'टमाटर',
    'Chili': 'मिर्च',
    'Turmeric': 'हल्दी',
  };

  static final Map<String, String> _marketNames = {
    'Delhi Azadpur Mandi': 'दिल्ली आज़ादपुर मंडी',
    'Mumbai APMC': 'मुंबई APMC',
    'Bangalore KR Market': 'बैंगलोर KR मार्केट',
    'Chennai Koyambedu': 'चेन्नई कोयंबेडू',
    'Kolkata Sealdah': 'कोलकाता सियालदह',
    'Hyderabad Gaddiannaram': 'हैदराबाद गड्डियानारम',
    'Pune Market Yard': 'पुणे मार्केट यार्ड',
    'Indore Krishi Upaj Mandi': 'इंदौर कृषि उपज मंडी',
    'Jaipur Sikar Road': 'जयपुर सीकर रोड',
    'Ahmedabad Jamalpur': 'अहमदाबाद जमालपुर',
  };

  static final Map<String, String> _stateNames = {
    'Delhi': 'दिल्ली',
    'Maharashtra': 'महाराष्ट्र',
    'Karnataka': 'कर्नाटक',
    'Tamil Nadu': 'तमिल नाडु',
    'West Bengal': 'पश्चिम बंगाल',
    'Telangana': 'तेलंगाना',
    'Madhya Pradesh': 'मध्य प्रदेश',
    'Rajasthan': 'राजस्थान',
    'Gujarat': 'गुजरात',
    'Punjab': 'पंजाब',
  };

  // Get current market prices for all crops
  Future<List<MarketPrice>> getCurrentMarketPrices() async {
    await Future.delayed(const Duration(seconds: 1));

    final random = math.Random();
    final prices = <MarketPrice>[];

    _cropNames.forEach((crop, cropHindi) {
      final basePrice = _getBasePriceForCrop(crop);
      final currentPrice = basePrice + (random.nextDouble() - 0.5) * 500;
      final previousPrice = currentPrice + (random.nextDouble() - 0.5) * 200;
      final changePercentage =
          ((currentPrice - previousPrice) / previousPrice) * 100;

      final marketEntries = _marketNames.entries.toList();
      final selectedMarket =
          marketEntries[random.nextInt(marketEntries.length)];

      final stateEntries = _stateNames.entries.toList();
      final selectedState = stateEntries[random.nextInt(stateEntries.length)];

      prices.add(MarketPrice(
        id: '${crop.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}',
        cropName: crop,
        cropNameHindi: cropHindi,
        currentPrice: currentPrice,
        previousPrice: previousPrice,
        changePercentage: changePercentage,
        market: selectedMarket.key,
        marketHindi: selectedMarket.value,
        state: selectedState.key,
        stateHindi: selectedState.value,
        timestamp: DateTime.now(),
      ));
    });

    return prices;
  }

  // Get market prices for specific crop
  Future<List<MarketPrice>> getCropPrices(String cropName) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final random = math.Random();
    final prices = <MarketPrice>[];
    final basePrice = _getBasePriceForCrop(cropName);
    final cropHindi = _cropNames[cropName] ?? cropName;

    // Generate prices for different markets
    _marketNames.forEach((market, marketHindi) {
      final currentPrice = basePrice + (random.nextDouble() - 0.5) * 300;
      final previousPrice = currentPrice + (random.nextDouble() - 0.5) * 150;
      final changePercentage =
          ((currentPrice - previousPrice) / previousPrice) * 100;

      final stateEntries = _stateNames.entries.toList();
      final selectedState = stateEntries[random.nextInt(stateEntries.length)];

      prices.add(MarketPrice(
        id: '${cropName.toLowerCase()}_${market.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}',
        cropName: cropName,
        cropNameHindi: cropHindi,
        currentPrice: currentPrice,
        previousPrice: previousPrice,
        changePercentage: changePercentage,
        market: market,
        marketHindi: marketHindi,
        state: selectedState.key,
        stateHindi: selectedState.value,
        timestamp: DateTime.now(),
      ));
    });

    // Sort by price (highest first)
    prices.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
    return prices;
  }

  // Get price trend for a specific crop
  Future<PriceTrend> getPriceTrend(String cropName, int days) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final random = math.Random();
    final basePrice = _getBasePriceForCrop(cropName);
    final priceHistory = <PricePoint>[];

    double currentPrice = basePrice;
    double totalPrice = 0;
    double highestPrice = 0;
    double lowestPrice = double.infinity;

    // Generate historical data
    for (int i = days; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      final priceVariation = (random.nextDouble() - 0.5) * 100;
      currentPrice = (currentPrice + priceVariation)
          .clamp(basePrice * 0.7, basePrice * 1.5);

      priceHistory.add(PricePoint(date: date, price: currentPrice));

      totalPrice += currentPrice;
      if (currentPrice > highestPrice) highestPrice = currentPrice;
      if (currentPrice < lowestPrice) lowestPrice = currentPrice;
    }

    final averagePrice = totalPrice / priceHistory.length;
    final firstPrice = priceHistory.first.price;
    final lastPrice = priceHistory.last.price;

    String trend;
    if (lastPrice > firstPrice * 1.05) {
      trend = 'increasing';
    } else if (lastPrice < firstPrice * 0.95) {
      trend = 'decreasing';
    } else {
      trend = 'stable';
    }

    // Calculate volatility index (simplified)
    double volatility = (highestPrice - lowestPrice) / averagePrice * 100;

    return PriceTrend(
      cropName: cropName,
      priceHistory: priceHistory,
      averagePrice: averagePrice,
      highestPrice: highestPrice,
      lowestPrice: lowestPrice,
      trend: trend,
      volatilityIndex: volatility,
    );
  }

  // Get market alerts
  Future<List<MarketAlert>> getMarketAlerts() async {
    await Future.delayed(const Duration(milliseconds: 400));

    final random = math.Random();
    final alerts = <MarketAlert>[];

    // Generate random alerts
    final alertTypes = ['price_drop', 'price_surge', 'best_time_to_sell'];
    final crops = _cropNames.keys.toList();

    for (int i = 0; i < 3 + random.nextInt(3); i++) {
      final crop = crops[random.nextInt(crops.length)];
      final alertType = alertTypes[random.nextInt(alertTypes.length)];
      final currentPrice =
          _getBasePriceForCrop(crop) + (random.nextDouble() - 0.5) * 300;
      final targetPrice = currentPrice + (random.nextDouble() - 0.5) * 200;

      String title, titleHindi, message, messageHindi;

      switch (alertType) {
        case 'price_drop':
          title = '$crop Price Drop Alert';
          titleHindi = '$crop मूल्य गिरावट चेतावनी';
          message =
              '$crop prices have dropped by ${(random.nextDouble() * 15 + 5).toStringAsFixed(1)}%. Consider holding for better rates.';
          messageHindi =
              '$crop की कीमतें ${(random.nextDouble() * 15 + 5).toStringAsFixed(1)}% गिर गई हैं। बेहतर दरों के लिए रोकने पर विचार करें।';
          break;
        case 'price_surge':
          title = '$crop Price Surge';
          titleHindi = '$crop मूल्य वृद्धि';
          message =
              '$crop prices increased by ${(random.nextDouble() * 20 + 5).toStringAsFixed(1)}%. Good time to sell!';
          messageHindi =
              '$crop की कीमतें ${(random.nextDouble() * 20 + 5).toStringAsFixed(1)}% बढ़ गई हैं। बेचने का अच्छा समय!';
          break;
        default:
          title = 'Best Time to Sell $crop';
          titleHindi = '$crop बेचने का सबसे अच्छा समय';
          message =
              'Market analysis suggests this is the optimal time to sell your $crop harvest.';
          messageHindi =
              'बाज़ार विश्लेषण बताता है कि यह आपकी $crop फसल बेचने का इष्टतम समय है।';
      }

      alerts.add(MarketAlert(
        id: 'alert_${i}_${DateTime.now().millisecondsSinceEpoch}',
        cropName: crop,
        alertType: alertType,
        title: title,
        titleHindi: titleHindi,
        message: message,
        messageHindi: messageHindi,
        targetPrice: targetPrice,
        currentPrice: currentPrice,
        createdAt: DateTime.now().subtract(Duration(hours: random.nextInt(24))),
      ));
    }

    return alerts;
  }

  // Get best selling locations for a crop
  Future<List<BestSellingLocation>> getBestSellingLocations(
      String cropName, String currentLocation) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final random = math.Random();
    final locations = <BestSellingLocation>[];
    final basePrice = _getBasePriceForCrop(cropName);

    _marketNames.forEach((market, marketHindi) {
      final price = basePrice + (random.nextDouble() - 0.3) * 400;
      final distance = 50 + random.nextDouble() * 500; // 50-550 km
      final transportCostPerKm =
          2.5 + random.nextDouble() * 1.5; // 2.5-4 INR per km
      final transportCost =
          '₹${(distance * transportCostPerKm).toStringAsFixed(0)}';
      final netPrice = price -
          (distance *
              transportCostPerKm /
              100); // Adjust for transport cost per quintal

      final stateEntries = _stateNames.entries.toList();
      final selectedState = stateEntries[random.nextInt(stateEntries.length)];

      locations.add(BestSellingLocation(
        marketName: market,
        marketNameHindi: marketHindi,
        state: selectedState.key,
        stateHindi: selectedState.value,
        price: price,
        distance: distance,
        transportCost: transportCost,
        netPrice: netPrice,
        contact: '+91-${9000000000 + random.nextInt(1000000000)}',
        rating: 3.5 + random.nextDouble() * 1.5, // 3.5-5.0 rating
      ));
    });

    // Sort by net price (highest first)
    locations.sort((a, b) => b.netPrice.compareTo(a.netPrice));
    return locations.take(8).toList(); // Return top 8 locations
  }

  // Get price comparison between different markets
  Future<Map<String, dynamic>> getPriceComparison(String cropName) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final prices = await getCropPrices(cropName);

    if (prices.isEmpty) {
      return {
        'error': 'No price data available',
        'cropName': cropName,
      };
    }

    final sortedPrices = List<MarketPrice>.from(prices);
    sortedPrices.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));

    final highestPrice = sortedPrices.first;
    final lowestPrice = sortedPrices.last;
    final averagePrice =
        sortedPrices.map((p) => p.currentPrice).reduce((a, b) => a + b) /
            sortedPrices.length;

    return {
      'cropName': cropName,
      'highestPriceMarket': {
        'market': highestPrice.market,
        'marketHindi': highestPrice.marketHindi,
        'price': highestPrice.currentPrice,
        'state': highestPrice.state,
      },
      'lowestPriceMarket': {
        'market': lowestPrice.market,
        'marketHindi': lowestPrice.marketHindi,
        'price': lowestPrice.currentPrice,
        'state': lowestPrice.state,
      },
      'averagePrice': averagePrice,
      'priceDifference': highestPrice.currentPrice - lowestPrice.currentPrice,
      'priceDifferencePercentage':
          ((highestPrice.currentPrice - lowestPrice.currentPrice) /
                  lowestPrice.currentPrice) *
              100,
      'recommendation': _generatePriceRecommendation(
          highestPrice.currentPrice, lowestPrice.currentPrice, averagePrice),
      'allPrices': sortedPrices,
    };
  }

  // Get price prediction (mock ML prediction)
  Future<Map<String, dynamic>> getPricePrediction(
      String cropName, int daysAhead) async {
    await Future.delayed(const Duration(seconds: 1));

    final random = math.Random();
    final currentPrice = _getBasePriceForCrop(cropName);
    final predictions = <Map<String, dynamic>>[];

    double predictedPrice = currentPrice;

    for (int i = 1; i <= daysAhead; i++) {
      final date = DateTime.now().add(Duration(days: i));
      final priceChange = (random.nextDouble() - 0.5) * 50; // ±25 price change
      predictedPrice = (predictedPrice + priceChange)
          .clamp(currentPrice * 0.8, currentPrice * 1.3);

      predictions.add({
        'date': date.toIso8601String(),
        'predictedPrice': predictedPrice,
        'confidence': 70 + random.nextDouble() * 25, // 70-95% confidence
      });
    }

    final trend = predictedPrice > currentPrice ? 'upward' : 'downward';
    final changePercentage =
        ((predictedPrice - currentPrice) / currentPrice) * 100;

    return {
      'cropName': cropName,
      'currentPrice': currentPrice,
      'predictions': predictions,
      'trend': trend,
      'expectedChange': changePercentage,
      'confidence': 75 + random.nextDouble() * 20,
      'recommendation':
          _generatePredictionRecommendation(trend, changePercentage),
    };
  }

  // Helper method to get base price for a crop
  double _getBasePriceForCrop(String crop) {
    final basePrices = {
      'Rice': 1800.0,
      'Wheat': 2000.0,
      'Maize': 1600.0,
      'Cotton': 5500.0,
      'Sugarcane': 350.0,
      'Soybean': 3800.0,
      'Mustard': 4200.0,
      'Potato': 1200.0,
      'Onion': 1500.0,
      'Tomato': 2500.0,
      'Chili': 8000.0,
      'Turmeric': 7500.0,
    };
    return basePrices[crop] ?? 2000.0;
  }

  // Helper method to generate price recommendation
  String _generatePriceRecommendation(
      double highest, double lowest, double average) {
    final difference = ((highest - lowest) / lowest) * 100;

    if (difference > 20) {
      return 'Significant price variation detected. Consider selling in markets with higher prices.';
    } else if (difference > 10) {
      return 'Moderate price variation. Research transport costs before deciding.';
    } else {
      return 'Prices are relatively stable across markets.';
    }
  }

  // Helper method to generate prediction recommendation
  String _generatePredictionRecommendation(
      String trend, double changePercentage) {
    if (trend == 'upward' && changePercentage > 5) {
      return 'Prices expected to rise. Consider holding for better rates.';
    } else if (trend == 'downward' && changePercentage < -5) {
      return 'Prices expected to fall. Consider selling soon.';
    } else {
      return 'Prices expected to remain stable. Sell based on your requirements.';
    }
  }
}
