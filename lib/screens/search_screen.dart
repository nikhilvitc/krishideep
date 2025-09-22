import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  // Dummy search data
  final List<SearchResult> _allResults = [
    SearchResult(
      title: 'Rice Cultivation Guide',
      description:
          'Complete guide for rice farming including soil preparation, planting, and harvesting',
      category: 'Knowledge',
      type: SearchType.article,
      icon: Icons.article,
      color: Colors.blue,
    ),
    SearchResult(
      title: 'Weather Forecast',
      description:
          'Current weather conditions and 5-day forecast for your area',
      category: 'Weather',
      type: SearchType.feature,
      icon: Icons.wb_sunny,
      color: Colors.orange,
    ),
    SearchResult(
      title: 'Market Prices - Rice',
      description: 'Current market prices for rice varieties in Delhi',
      category: 'Market',
      type: SearchType.feature,
      icon: Icons.trending_up,
      color: Colors.green,
    ),
    SearchResult(
      title: 'Crop Disease Detection',
      description: 'AI-powered tool to identify crop diseases from photos',
      category: 'Tools',
      type: SearchType.feature,
      icon: Icons.camera_alt,
      color: Colors.red,
    ),
    SearchResult(
      title: 'Government Schemes',
      description: 'Available government schemes and subsidies for farmers',
      category: 'Government',
      type: SearchType.feature,
      icon: Icons.account_balance,
      color: Colors.purple,
    ),
    SearchResult(
      title: 'Financial Advisory',
      description: 'Expert financial guidance and loan information',
      category: 'Finance',
      type: SearchType.feature,
      icon: Icons.attach_money,
      color: Colors.teal,
    ),
    SearchResult(
      title: 'IoT Dashboard',
      description: 'Monitor your farm sensors and get real-time data',
      category: 'Technology',
      type: SearchType.feature,
      icon: Icons.dashboard,
      color: Colors.indigo,
    ),
    SearchResult(
      title: 'Farmer Community',
      description: 'Connect with other farmers and share experiences',
      category: 'Community',
      type: SearchType.feature,
      icon: Icons.forum,
      color: Colors.brown,
    ),
    SearchResult(
      title: 'Wheat Farming Tips',
      description:
          'Best practices for wheat cultivation and yield optimization',
      category: 'Knowledge',
      type: SearchType.article,
      icon: Icons.article,
      color: Colors.blue,
    ),
    SearchResult(
      title: 'Soil Testing Services',
      description: 'Professional soil testing and analysis services',
      category: 'Services',
      type: SearchType.service,
      icon: Icons.science,
      color: Colors.amber,
    ),
  ];

  final List<String> _categories = [
    'All',
    'Knowledge',
    'Weather',
    'Market',
    'Tools',
    'Government',
    'Finance',
    'Technology',
    'Community',
    'Services'
  ];

  @override
  Widget build(BuildContext context) {
    final filteredResults = _getFilteredResults();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
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
              // Search Bar
              _buildSearchBar(),

              // Category Filter
              _buildCategoryFilter(),

              // Results
              Expanded(
                child: _buildResults(filteredResults),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search for crops, features, or information...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              selectedColor: Colors.white,
              checkmarkColor: Colors.green.shade700,
              backgroundColor: Colors.white.withOpacity(0.8),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResults(List<SearchResult> results) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty
                  ? 'Start typing to search...'
                  : 'No results found for "$_searchQuery"',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          return _buildResultCard(result);
        },
      ),
    );
  }

  Widget _buildResultCard(SearchResult result) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: result.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            result.icon,
            color: result.color,
            size: 24,
          ),
        ),
        title: Text(
          result.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              result.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: result.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    result.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: result.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getTypeLabel(result.type),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _handleResultTap(result),
      ),
    );
  }

  List<SearchResult> _getFilteredResults() {
    return _allResults.where((result) {
      // Category filter
      if (_selectedCategory != 'All' && result.category != _selectedCategory) {
        return false;
      }

      // Search query filter
      if (_searchQuery.isNotEmpty) {
        return result.title.toLowerCase().contains(_searchQuery) ||
            result.description.toLowerCase().contains(_searchQuery) ||
            result.category.toLowerCase().contains(_searchQuery);
      }

      return true;
    }).toList();
  }

  String _getTypeLabel(SearchType type) {
    switch (type) {
      case SearchType.article:
        return 'Article';
      case SearchType.feature:
        return 'Feature';
      case SearchType.service:
        return 'Service';
    }
  }

  void _handleResultTap(SearchResult result) {
    // Handle navigation based on result type
    switch (result.type) {
      case SearchType.feature:
        _navigateToFeature(result.title);
        break;
      case SearchType.article:
        _showSnackBar('Opening article: ${result.title}');
        break;
      case SearchType.service:
        _showSnackBar('Contacting service: ${result.title}');
        break;
    }
  }

  void _navigateToFeature(String title) {
    // Navigate to appropriate feature based on title
    if (title.contains('Weather')) {
      Navigator.pushNamed(context, '/weather');
    } else if (title.contains('Market')) {
      Navigator.pushNamed(context, '/market-prices');
    } else if (title.contains('Disease')) {
      Navigator.pushNamed(context, '/disease-detection');
    } else if (title.contains('Government')) {
      Navigator.pushNamed(context, '/government-schemes');
    } else if (title.contains('Financial')) {
      Navigator.pushNamed(context, '/financial-advisory');
    } else if (title.contains('IoT')) {
      Navigator.pushNamed(context, '/iot-dashboard');
    } else if (title.contains('Community')) {
      Navigator.pushNamed(context, '/farmer-community');
    } else {
      _showSnackBar('Opening: $title');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class SearchResult {
  final String title;
  final String description;
  final String category;
  final SearchType type;
  final IconData icon;
  final Color color;

  SearchResult({
    required this.title,
    required this.description,
    required this.category,
    required this.type,
    required this.icon,
    required this.color,
  });
}

enum SearchType { article, feature, service }
