import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/government_scheme_service.dart';
import '../models/government_scheme.dart';

class GovernmentSchemesScreen extends StatefulWidget {
  const GovernmentSchemesScreen({super.key});

  @override
  State<GovernmentSchemesScreen> createState() =>
      _GovernmentSchemesScreenState();
}

class _GovernmentSchemesScreenState extends State<GovernmentSchemesScreen>
    with TickerProviderStateMixin {
  final GovernmentSchemeService _service = GovernmentSchemeService();
  late TabController _tabController;

  List<GovernmentScheme> _allSchemes = [];
  List<GovernmentScheme> _filteredSchemes = [];
  List<SubsidyApplication> _applications = [];
  List<SchemeNotification> _notifications = [];

  bool _isLoading = true;
  String _error = '';
  String _selectedCategory = 'all';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'all',
    'subsidy',
    'loan',
    'insurance',
    'welfare',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final farmerId = 'DEMO_FARMER_001';

      // Load all data in parallel
      final results = await Future.wait([
        _service.getAllSchemes(),
        _service.getFarmerApplications(farmerId),
        _service.getNotifications(),
      ]);

      setState(() {
        _allSchemes = results[0] as List<GovernmentScheme>;
        _filteredSchemes = _allSchemes;
        _applications = results[1] as List<SubsidyApplication>;
        _notifications = results[2] as List<SchemeNotification>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterSchemes() {
    setState(() {
      _filteredSchemes = _allSchemes.where((scheme) {
        final matchesCategory =
            _selectedCategory == 'all' || scheme.category == _selectedCategory;
        final matchesSearch = _searchController.text.isEmpty ||
            scheme.schemeName
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            scheme.schemeNameHindi.contains(_searchController.text) ||
            scheme.description
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('government_schemes'.tr()),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'available_schemes'.tr()),
            Tab(text: 'my_applications'.tr()),
            Tab(text: 'notifications'.tr()),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 64, color: Colors.red.shade300),
                      const SizedBox(height: 16),
                      Text(_error, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: Text('retry'.tr()),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSchemesTab(),
                    _buildApplicationsTab(),
                    _buildNotificationsTab(),
                  ],
                ),
    );
  }

  Widget _buildSchemesTab() {
    return Column(
      children: [
        // Search and Filter Section
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'search_schemes'.tr(),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterSchemes();
                          },
                        )
                      : null,
                ),
                onChanged: (value) => _filterSchemes(),
              ),

              const SizedBox(height: 12),

              // Category Filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories
                      .map((category) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(_getCategoryLabel(category)),
                              selected: _selectedCategory == category,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCategory = category;
                                });
                                _filterSchemes();
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),

        // Schemes List
        Expanded(
          child: _filteredSchemes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off,
                          size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'no_schemes_found'.tr(),
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredSchemes.length,
                  itemBuilder: (context, index) {
                    final scheme = _filteredSchemes[index];
                    return _buildSchemeCard(scheme);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildApplicationsTab() {
    return _applications.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.description, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'no_applications'.tr(),
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _tabController.animateTo(0),
                  child: Text('browse_schemes'.tr()),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _applications.length,
            itemBuilder: (context, index) {
              final application = _applications[index];
              return _buildApplicationCard(application);
            },
          );
  }

  Widget _buildNotificationsTab() {
    return _notifications.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none,
                    size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'no_notifications'.tr(),
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              final notification = _notifications[index];
              return _buildNotificationCard(notification);
            },
          );
  }

  Widget _buildSchemeCard(GovernmentScheme scheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scheme.schemeName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        scheme.schemeNameHindi,
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(scheme.category),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getCategoryLabel(scheme.category),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              scheme.description,
              style: const TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.monetization_on,
                    size: 16, color: Colors.green.shade600),
                const SizedBox(width: 4),
                Text(
                  'Max Benefit: ₹${scheme.maxBenefit.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 12, color: Colors.green.shade600),
                ),
                const Spacer(),
                Text(
                  'State: ${scheme.state}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _checkEligibility(scheme),
                    child: Text('check_eligibility'.tr()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _applyForScheme(scheme),
                    child: Text('apply_now'.tr()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationCard(SubsidyApplication application) {
    final scheme = _allSchemes.firstWhere((s) => s.id == application.schemeId);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    scheme.schemeName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(application.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    application.status.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Application ID: ${application.id}'),
            Text('Submitted: ${_formatDate(application.submissionDate)}'),
            Text('Farmer: ${application.farmerName}'),
            const SizedBox(height: 12),
            if (application.status == 'submitted')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _viewApplicationDetails(application),
                      child: Text('view_details'.tr()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _trackApplication(application),
                      child: Text('track_status'.tr()),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(SchemeNotification notification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getNotificationColor(notification.type),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(notification.title),
        subtitle: Text(notification.message),
        trailing: notification.isImportant
            ? Icon(Icons.priority_high, color: Colors.red.shade600)
            : null,
        onTap: () => _viewNotificationDetails(notification),
      ),
    );
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'all':
        return 'all_categories'.tr();
      case 'subsidy':
        return 'subsidies'.tr();
      case 'loan':
        return 'loans'.tr();
      case 'insurance':
        return 'insurance'.tr();
      case 'welfare':
        return 'welfare'.tr();
      default:
        return category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'subsidy':
        return Colors.green;
      case 'loan':
        return Colors.blue;
      case 'insurance':
        return Colors.orange;
      case 'welfare':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'submitted':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'new_scheme':
        return Colors.green;
      case 'deadline_reminder':
        return Colors.orange;
      case 'status_update':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'new_scheme':
        return Icons.new_releases;
      case 'deadline_reminder':
        return Icons.schedule;
      case 'status_update':
        return Icons.update;
      default:
        return Icons.notifications;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _checkEligibility(GovernmentScheme scheme) async {
    try {
      final farmerData = {
        'hasLand': true,
        'farmSize': 2.5,
        'hasAadhaar': true,
        'annualIncome': 150000.0,
      };

      final eligibility =
          await _service.checkEligibility(scheme.id, farmerData);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Eligibility Check'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Scheme: ${scheme.schemeName}'),
              const SizedBox(height: 8),
              Text('Eligible: ${eligibility.isEligible ? "Yes" : "No"}'),
              Text(
                  'Score: ${eligibility.eligibilityScore.toStringAsFixed(0)}/100'),
              if (eligibility.estimatedBenefit > 0)
                Text(
                    'Estimated Benefit: ₹${eligibility.estimatedBenefit.toStringAsFixed(0)}'),
              const SizedBox(height: 8),
              if (eligibility.recommendations.isNotEmpty) ...[
                const Text('Recommendations:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...eligibility.recommendations.map((rec) => Text('• $rec')),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ok'.tr()),
            ),
            if (eligibility.isEligible)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _applyForScheme(scheme);
                },
                child: Text('apply_now'.tr()),
              ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _applyForScheme(GovernmentScheme scheme) async {
    try {
      final applicationData = {
        'farmerName': 'Demo Farmer',
        'farmerId': 'DEMO_FARMER_001',
        'mobileNumber': '+919876543210',
        'farmSize': 2.5,
        'annualIncome': 150000.0,
      };

      final applicationId = await _service.submitApplication(
        scheme.id,
        applicationData,
        ['document1.pdf', 'document2.pdf'],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Application submitted successfully! ID: $applicationId'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh applications
      _loadData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _viewApplicationDetails(SubsidyApplication application) {
    // Implementation for viewing application details
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Application details feature coming soon!')),
    );
  }

  void _trackApplication(SubsidyApplication application) {
    // Implementation for tracking application
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Application tracking feature coming soon!')),
    );
  }

  void _viewNotificationDetails(SchemeNotification notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: Text(notification.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ok'.tr()),
          ),
        ],
      ),
    );
  }
}
