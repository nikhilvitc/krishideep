import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'iot_dashboard_screen_simple.dart';
import 'analytics_dashboard_screen.dart';
import 'government_schemes_screen.dart';
import 'financial_advisory_screen.dart';
import 'farmer_community_screen.dart';
import '../widgets/image_carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr()),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              // Toggle theme (implement with provider)
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Navigate to profile
            },
          ),
        ],
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimationLimiter(
              child: Column(
                children: [
                  // Image Carousel
                  ImageCarousel(
                    imagePaths: [
                      'assets/images/image1sc.png',
                      'assets/images/image2sc.png',
                      'assets/images/image3sc.png',
                      'assets/images/image4sc.png',
                      'assets/images/image5sc.png',
                    ],
                    autoScrollDuration: const Duration(seconds: 5),
                    height: 250,
                  ),

                  const SizedBox(height: 24),

                  // Feature Cards
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 375),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset: 50.0,
                          child: FadeInAnimation(child: widget),
                        ),
                        children: [
                          _buildFeatureCard(
                            context,
                            Icons.sensors,
                            'iot_dashboard'.tr(),
                            'real_time_monitoring'.tr(),
                            Colors.blue,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const IoTDashboardScreen()),
                            ),
                          ),
                          _buildFeatureCard(
                            context,
                            Icons.analytics,
                            'analytics_dashboard'.tr(),
                            'ai_predictions'.tr(),
                            Colors.purple,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AnalyticsDashboardScreen()),
                            ),
                          ),
                          _buildFeatureCard(
                            context,
                            Icons.account_balance,
                            'government_schemes'.tr(),
                            'subsidies'.tr(),
                            Colors.green,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const GovernmentSchemesScreen()),
                            ),
                          ),
                          _buildFeatureCard(
                            context,
                            Icons.attach_money,
                            'financial_advisory'.tr(),
                            'financial_planning'.tr(),
                            Colors.orange,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FinancialAdvisoryScreen()),
                            ),
                          ),
                          _buildFeatureCard(
                            context,
                            Icons.forum,
                            'farmer_community'.tr(),
                            'community_support'.tr(),
                            Colors.teal,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FarmerCommunityScreen()),
                            ),
                          ),
                          _buildFeatureCard(
                            context,
                            Icons.agriculture,
                            'get_crop_advice'.tr(),
                            'Get AI-powered crop recommendations',
                            Colors.indigo,
                            () => _navigateToTab(context, 1),
                          ),
                          _buildFeatureCard(
                            context,
                            Icons.camera_alt,
                            'crop_disease_detection'.tr(),
                            'Detect crop diseases using camera',
                            Colors.red,
                            () => _navigateToTab(context, 2),
                          ),
                          _buildFeatureCard(
                            context,
                            Icons.book,
                            'knowledge_faqs'.tr(),
                            'Access farming guidelines & FAQs',
                            Colors.brown,
                            () => _navigateToTab(context, 3),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Quick Stats Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('50K+', 'Farmers Helped'),
                        Container(
                          height: 40,
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                        _buildStatItem('95%', 'Accuracy Rate'),
                        Container(
                          height: 40,
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                        _buildStatItem('24/7', 'Support Available'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  void _navigateToTab(BuildContext context, int index) {
    // This would be implemented with a provider or state management
    // For now, we'll just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigate to tab $index'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
