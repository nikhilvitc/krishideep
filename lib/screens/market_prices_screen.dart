import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class MarketPricesScreen extends StatefulWidget {
  const MarketPricesScreen({super.key});

  @override
  State<MarketPricesScreen> createState() => _MarketPricesScreenState();
}

class _MarketPricesScreenState extends State<MarketPricesScreen> {
  String _selectedLocation = 'Delhi';
  String _selectedCategory = 'All';

  // Dummy market data
  final List<MarketPrice> _marketPrices = [
    MarketPrice(
      cropName: 'Rice',
      variety: 'Basmati',
      currentPrice: 2800,
      previousPrice: 2750,
      unit: 'Quintal',
      location: 'Delhi',
      trend: PriceTrend.up,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    MarketPrice(
      cropName: 'Wheat',
      variety: 'Durum',
      currentPrice: 2200,
      previousPrice: 2250,
      unit: 'Quintal',
      location: 'Delhi',
      trend: PriceTrend.down,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    MarketPrice(
      cropName: 'Tomato',
      variety: 'Hybrid',
      currentPrice: 45,
      previousPrice: 50,
      unit: 'Kg',
      location: 'Delhi',
      trend: PriceTrend.down,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    MarketPrice(
      cropName: 'Onion',
      variety: 'Red',
      currentPrice: 35,
      previousPrice: 32,
      unit: 'Kg',
      location: 'Delhi',
      trend: PriceTrend.up,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
    MarketPrice(
      cropName: 'Potato',
      variety: 'Kufri',
      currentPrice: 25,
      previousPrice: 28,
      unit: 'Kg',
      location: 'Delhi',
      trend: PriceTrend.down,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    MarketPrice(
      cropName: 'Cotton',
      variety: 'BT',
      currentPrice: 6500,
      previousPrice: 6400,
      unit: 'Quintal',
      location: 'Delhi',
      trend: PriceTrend.up,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    MarketPrice(
      cropName: 'Sugarcane',
      variety: 'Co-86032',
      currentPrice: 320,
      previousPrice: 315,
      unit: 'Quintal',
      location: 'Delhi',
      trend: PriceTrend.up,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 35)),
    ),
    MarketPrice(
      cropName: 'Maize',
      variety: 'Hybrid',
      currentPrice: 1800,
      previousPrice: 1850,
      unit: 'Quintal',
      location: 'Delhi',
      trend: PriceTrend.down,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 40)),
    ),
  ];

  final List<String> _locations = [
    'Delhi',
    'Mumbai',
    'Chennai',
    'Kolkata',
    'Bangalore'
  ];
  final List<String> _categories = [
    'All',
    'Cereals',
    'Vegetables',
    'Cash Crops'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Prices'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade700, Colors.green.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Filters Section
              _buildFiltersSection(),

              // Market Overview
              _buildMarketOverview(),

              // Price List
              Expanded(
                child: _buildPriceList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Location Filter
          Row(
            children: [
              const Text(
                'Location:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedLocation,
                      isExpanded: true,
                      items: _locations.map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLocation = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Category Filter
          Row(
            children: [
              const Text(
                'Category:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarketOverview() {
    final totalCrops = _marketPrices.length;
    final risingPrices =
        _marketPrices.where((p) => p.trend == PriceTrend.up).length;
    final fallingPrices =
        _marketPrices.where((p) => p.trend == PriceTrend.down).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildOverviewItem('Total Crops', totalCrops.toString(),
              Icons.agriculture, Colors.green),
          _buildOverviewItem(
              'Rising', risingPrices.toString(), Icons.trending_up, Colors.red),
          _buildOverviewItem('Falling', fallingPrices.toString(),
              Icons.trending_down, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceList() {
    final filteredPrices = _getFilteredPrices();

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Text('Crop',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 1,
                    child: Text('Price',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 1,
                    child: Text('Trend',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 1,
                    child: Text('Updated',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),

          // Price Items
          Expanded(
            child: ListView.builder(
              itemCount: filteredPrices.length,
              itemBuilder: (context, index) {
                final price = filteredPrices[index];
                return _buildPriceItem(price);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceItem(MarketPrice price) {
    final priceChange = price.currentPrice - price.previousPrice;
    final changePercentage = (priceChange / price.previousPrice * 100).abs();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          // Crop Info
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price.cropName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  price.variety,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  '₹${price.currentPrice}/${price.unit}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          // Price Change
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${priceChange.abs()}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: price.trend == PriceTrend.up
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
                Text(
                  '${changePercentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: price.trend == PriceTrend.up
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ],
            ),
          ),

          // Trend Icon
          Expanded(
            flex: 1,
            child: Icon(
              price.trend == PriceTrend.up
                  ? Icons.trending_up
                  : Icons.trending_down,
              color: price.trend == PriceTrend.up ? Colors.red : Colors.green,
              size: 24,
            ),
          ),

          // Last Updated
          Expanded(
            flex: 1,
            child: Text(
              _getTimeAgo(price.lastUpdated),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<MarketPrice> _getFilteredPrices() {
    return _marketPrices.where((price) {
      if (_selectedLocation != 'All' && price.location != _selectedLocation) {
        return false;
      }
      // Add category filtering logic here if needed
      return true;
    }).toList();
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class MarketPrice {
  final String cropName;
  final String variety;
  final int currentPrice;
  final int previousPrice;
  final String unit;
  final String location;
  final PriceTrend trend;
  final DateTime lastUpdated;

  MarketPrice({
    required this.cropName,
    required this.variety,
    required this.currentPrice,
    required this.previousPrice,
    required this.unit,
    required this.location,
    required this.trend,
    required this.lastUpdated,
  });
}

enum PriceTrend { up, down }
