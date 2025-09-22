import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreenSimple extends StatefulWidget {
  const HomeScreenSimple({super.key});

  @override
  State<HomeScreenSimple> createState() => _HomeScreenSimpleState();
}

class _HomeScreenSimpleState extends State<HomeScreenSimple> {
  String _getLocalizedAppName() {
    final locale = context.locale;
    switch (locale.languageCode) {
      case 'hi':
        return 'कृषि दीप';
      case 'ta':
        return 'கிருஷி தீப்';
      default:
        return 'Krisi Deep';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green.shade600, Colors.green.shade800],
                ),
              ),
              child: Row(
                children: [
                  // Profile Avatar with Logo
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/krisi_deep_logo.png',
                        fit: BoxFit.contain,
                        width: 32,
                        height: 32,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // App Name with Icon
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.agriculture,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _getLocalizedAppName(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search and Notifications
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search, color: Colors.white),
                      ),
                      Stack(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.notifications,
                                color: Colors.white),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick Actions
                      Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionCard(
                                'Crop Advice', Icons.agriculture, Colors.green),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionCard('Disease Detection',
                                Icons.bug_report, Colors.red),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionCard(
                                'Weather', Icons.wb_sunny, Colors.orange),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionCard('Market Prices',
                                Icons.trending_up, Colors.blue),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Services
                      Text(
                        'All Services',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          _buildServiceCard(
                              'IoT Dashboard', Icons.dashboard, Colors.blue),
                          _buildServiceCard(
                              'Analytics', Icons.analytics, Colors.purple),
                          _buildServiceCard('Govt Schemes',
                              Icons.account_balance, Colors.green),
                          _buildServiceCard('Financial Advisory',
                              Icons.attach_money, Colors.orange),
                          _buildServiceCard(
                              'Farmer Community', Icons.forum, Colors.teal),
                          _buildServiceCard(
                              'Knowledge Base', Icons.school, Colors.indigo),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
