import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'iot_dashboard_screen_simple.dart';
import 'analytics_dashboard_screen.dart';
import 'government_schemes_screen.dart';
import 'financial_advisory_screen.dart';
import 'farmer_community_screen.dart';
import 'crop_advice_screen.dart';
import 'disease_detection_screen.dart';
import 'knowledge_screen.dart';
import 'weather_screen.dart';
import 'market_prices_screen.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import '../widgets/image_carousel.dart';
import '../widgets/voice_command_button.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({super.key});

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading time
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _getLocalizedAppName() {
    return 'app_name'.tr();
  }

  void _handleVoiceCommand(String command) {
    // Handle voice commands
    switch (command.toLowerCase()) {
      case 'crop advice':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CropAdviceScreen()),
        );
        break;
      case 'weather forecast':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WeatherScreen()),
        );
        break;
      case 'government schemes':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const GovernmentSchemesScreen()),
        );
        break;
      case 'financial help':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const FinancialAdvisoryScreen()),
        );
        break;
      case 'disease detection':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const DiseaseDetectionScreen()),
        );
        break;
      case 'market prices':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MarketPricesScreen()),
        );
        break;
      default:
        _showSnackBar('Voice command: $command');
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

  void _showLanguageSelection() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'select_language'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('English'),
                onTap: () {
                  context.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('हिंदी'),
                onTap: () {
                  context.setLocale(const Locale('hi'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('தமிழ்'),
                onTap: () {
                  context.setLocale(const Locale('ta'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleTheme() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme();
  }

  void _showProfileSection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Profile Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Profile Avatar
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.asset(
                              'assets/images/krisi_deep_logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.green.shade700,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // User Info
                        Text(
                          'John Doe', // This should come from user data
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '+91 9876543210', // This should come from user data
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Chennai, Tamil Nadu', // This should come from user data
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                  ),
                        ),
                      ],
                    ),
                  ),

                  // Profile Options
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _buildProfileOption(
                          Icons.language,
                          'language_selection'.tr(),
                          'Select your preferred language',
                          () {
                            Navigator.pop(context);
                            _showLanguageSelection();
                          },
                        ),
                        _buildProfileOption(
                          Icons.person,
                          'edit_profile'.tr(),
                          'Update your personal information',
                          () {
                            Navigator.pop(context);
                            _showSnackBar('Edit profile feature coming soon');
                          },
                        ),
                        _buildProfileOption(
                          Icons.location_on,
                          'update_location'.tr(),
                          'Change your current location',
                          () {
                            Navigator.pop(context);
                            _showSnackBar(
                                'Location update feature coming soon');
                          },
                        ),
                        _buildProfileOption(
                          Icons.settings,
                          'settings'.tr(),
                          'App settings and preferences',
                          () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ),
                            );
                          },
                        ),
                        _buildProfileOption(
                          Icons.help,
                          'help_support'.tr(),
                          'Get help and contact support',
                          () {
                            Navigator.pop(context);
                            _showSnackBar('Help & support feature coming soon');
                          },
                        ),
                        _buildProfileOption(
                          Icons.logout,
                          'logout'.tr(),
                          'Sign out of your account',
                          () {
                            Navigator.pop(context);
                            _showLogoutDialog();
                          },
                          textColor: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProfileOption(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: textColor ?? Colors.green.shade600,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodySmall?.color,
          fontSize: 12,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('logout'.tr()),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Implement logout logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logged out successfully')),
                );
              },
              child: Text('logout'.tr()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingScreen()
            : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // Header Section
                    _buildHeader(),

                    // Image Carousel
                    _buildImageCarousel(),

                    // Quick Actions Section
                    _buildQuickActionsSection(),

                    // Categories Section
                    _buildCategoriesSection(),

                    // Recent Activity
                    _buildRecentActivity(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
      floatingActionButton: VoiceCommandButton(
        onVoiceResult: _handleVoiceCommand,
        onStartListening: () => _showSnackBar('listening'.tr()),
        onStopListening: () => _showSnackBar('processing'.tr()),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green.shade600, Colors.green.shade800],
        ),
      ),
      child: Column(
        children: [
          // Top Row
          Row(
            children: [
              // Profile Avatar with Logo (Clickable)
              GestureDetector(
                onTap: _showProfileSection,
                child: Container(
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
              ),

              const SizedBox(width: 12),

              // App Name
              Expanded(
                child: Text(
                  _getLocalizedAppName(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              // Theme Toggle, Search and Notifications
              Row(
                children: [
                  // Theme Toggle
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return IconButton(
                        onPressed: _toggleTheme,
                        icon: Icon(
                          themeProvider.isDarkMode
                              ? Icons.light_mode
                              : Icons.dark_mode,
                          color: Colors.white,
                        ),
                        tooltip: themeProvider.isDarkMode
                            ? 'light_mode'.tr()
                            : 'dark_mode'.tr(),
                      );
                    },
                  ),
                  // Search
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchScreen()),
                    ),
                    icon: const Icon(Icons.search, color: Colors.white),
                  ),
                  // Notifications
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () => _showSnackBar('notifications'.tr()),
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
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ImageCarousel(
        imagePaths: [
          'assets/images/image1sc.png',
          'assets/images/image2sc.png',
          'assets/images/image3sc.png',
          'assets/images/image4sc.png',
          'assets/images/image5sc.png',
        ],
        autoScrollDuration: const Duration(seconds: 5),
        height: 180,
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'quick_actions'.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  'crop_advice'.tr(),
                  Icons.agriculture,
                  Colors.green,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CropAdviceScreen()),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  'disease_detection'.tr(),
                  Icons.bug_report,
                  Colors.red,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DiseaseDetectionScreen()),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  'weather'.tr(),
                  Icons.wb_sunny,
                  Colors.orange,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WeatherScreen()),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  'market_prices'.tr(),
                  Icons.trending_up,
                  Colors.blue,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MarketPricesScreen()),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
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
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'all_services'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              TextButton(
                onPressed: () => _showSnackBar('View all services'),
                child: Text(
                  'view_more'.tr(),
                  style: TextStyle(color: Colors.green.shade600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Analytics & Monitoring
          _buildCategorySection(
            'analytics_monitoring'.tr(),
            [
              _buildServiceItem(
                  'iot_dashboard'.tr(),
                  Icons.dashboard,
                  Colors.blue,
                  () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const IoTDashboardScreen()),
                      )),
              _buildServiceItem(
                  'analytics'.tr(),
                  Icons.analytics,
                  Colors.purple,
                  () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AnalyticsDashboardScreen()),
                      )),
            ],
          ),

          const SizedBox(height: 16),

          // Government & Finance
          _buildCategorySection(
            'government_finance'.tr(),
            [
              _buildServiceItem(
                  'govt_schemes'.tr(),
                  Icons.account_balance,
                  Colors.green,
                  () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const GovernmentSchemesScreen()),
                      )),
              _buildServiceItem(
                  'financial_advisory'.tr(),
                  Icons.attach_money,
                  Colors.orange,
                  () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const FinancialAdvisoryScreen()),
                      )),
            ],
          ),

          const SizedBox(height: 16),

          // Community & Support
          _buildCategorySection(
            'community_support'.tr(),
            [
              _buildServiceItem(
                  'farmer_community'.tr(),
                  Icons.forum,
                  Colors.teal,
                  () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const FarmerCommunityScreen()),
                      )),
              _buildServiceItem(
                  'knowledge_base'.tr(),
                  Icons.school,
                  Colors.indigo,
                  () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const KnowledgeScreen()),
                      )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: items,
        ),
      ],
    );
  }

  Widget _buildServiceItem(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
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
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'recent_activity'.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
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
                _buildActivityItem(
                  'crop_recommendation'.tr(),
                  'rice_cultivation_advice'.tr(),
                  Icons.agriculture,
                  Colors.green,
                  '2 ${'hours_ago'.tr()}',
                ),
                const Divider(),
                _buildActivityItem(
                  'weather_alert'.tr(),
                  'rain_expected'.tr(),
                  Icons.wb_cloudy,
                  Colors.blue,
                  '5 ${'hours_ago'.tr()}',
                ),
                const Divider(),
                _buildActivityItem(
                  'government_scheme'.tr(),
                  'pm_kisan_approved'.tr(),
                  Icons.account_balance,
                  Colors.orange,
                  '1 ${'day_ago'.tr()}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
      String title, String subtitle, IconData icon, Color color, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading...',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
