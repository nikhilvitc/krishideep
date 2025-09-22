import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/financial_advisory_service.dart';
import '../models/financial_advisory.dart';

class FinancialAdvisoryScreen extends StatefulWidget {
  const FinancialAdvisoryScreen({super.key});

  @override
  State<FinancialAdvisoryScreen> createState() =>
      _FinancialAdvisoryScreenState();
}

class _FinancialAdvisoryScreenState extends State<FinancialAdvisoryScreen>
    with TickerProviderStateMixin {
  final FinancialAdvisoryService _service = FinancialAdvisoryService();
  late TabController _tabController;

  List<FinancialAdvisory> _advisories = [];
  List<LoanApplication> _loanApplications = [];
  List<InsurancePlan> _insurancePlans = [];
  List<FinancialGoal> _financialGoals = [];
  Map<String, dynamic>? _dashboardData;

  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final farmerId = 'DEMO_FARMER_001';
      final farmerProfile = {
        'name': 'Demo Farmer',
        'nameHindi': 'डेमो किसान',
        'farmSize': 2.5,
        'annualIncome': 150000.0,
        'creditScore': 'good',
        'collaterals': ['Land Documents'],
        'collateralsHindi': ['भूमि दस्तावेज'],
        'existingLoans': 50000.0,
        'assets': {'land': 500000.0, 'machinery': 100000.0},
        'expenses': {'monthly': 12000.0, 'seasonal': 50000.0},
      };

      // Load all data in parallel
      final results = await Future.wait([
        _service.getPersonalizedAdvisory(farmerId, farmerProfile),
        _service.getLoanApplications(farmerId),
        _service.getInsurancePlans(),
        _service.getFinancialGoals(farmerId),
        _service.getFinancialDashboard(farmerId),
      ]);

      setState(() {
        _advisories = results[0] as List<FinancialAdvisory>;
        _loanApplications = results[1] as List<LoanApplication>;
        _insurancePlans = results[2] as List<InsurancePlan>;
        _financialGoals = results[3] as List<FinancialGoal>;
        _dashboardData = results[4] as Map<String, dynamic>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('financial_advisory'.tr()),
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: [
            Tab(text: 'dashboard'.tr()),
            Tab(text: 'advisory'.tr()),
            Tab(text: 'loans'.tr()),
            Tab(text: 'insurance'.tr()),
            Tab(text: 'goals'.tr()),
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
                    _buildDashboardTab(),
                    _buildAdvisoryTab(),
                    _buildLoansTab(),
                    _buildInsuranceTab(),
                    _buildGoalsTab(),
                  ],
                ),
    );
  }

  Widget _buildDashboardTab() {
    if (_dashboardData == null)
      return const Center(child: Text('No data available'));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Financial Health Score
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_balance_wallet,
                          color: Colors.green.shade600),
                      const SizedBox(width: 8),
                      Text(
                        'financial_health_score'.tr(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_dashboardData!['financialHealthScore']?.toStringAsFixed(0) ?? '0'}/100',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: _getHealthScoreColor(
                                    _dashboardData!['financialHealthScore'] ??
                                        0),
                              ),
                            ),
                            Text(
                              _getHealthScoreLabel(
                                  _dashboardData!['financialHealthScore'] ?? 0),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CircularProgressIndicator(
                        value: (_dashboardData!['financialHealthScore'] ?? 0) /
                            100,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getHealthScoreColor(
                              _dashboardData!['financialHealthScore'] ?? 0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Financial Overview Grid
          Text(
            'financial_overview'.tr(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              _buildFinancialMetricCard(
                'Net Worth',
                '₹${(_dashboardData!['netWorth'] ?? 0).toStringAsFixed(0)}',
                Icons.trending_up,
                Colors.green,
              ),
              _buildFinancialMetricCard(
                'Monthly Income',
                '₹${(_dashboardData!['monthlyIncome'] ?? 0).toStringAsFixed(0)}',
                Icons.account_balance,
                Colors.blue,
              ),
              _buildFinancialMetricCard(
                'Monthly Savings',
                '₹${(_dashboardData!['savings'] ?? 0).toStringAsFixed(0)}',
                Icons.savings,
                Colors.purple,
              ),
              _buildFinancialMetricCard(
                'Active Loans',
                '${_dashboardData!['activeLoans'] ?? 0}',
                Icons.credit_card,
                Colors.orange,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Upcoming Payments
          if (_dashboardData!['upcomingPayments'] != null &&
              (_dashboardData!['upcomingPayments'] as List?)?.isNotEmpty ==
                  true) ...[
            Text(
              'upcoming_payments'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...((_dashboardData!['upcomingPayments'] as List?) ?? [])
                .map((payment) => Card(
                      child: ListTile(
                        leading:
                            Icon(Icons.schedule, color: Colors.orange.shade600),
                        title: Text(payment['type']),
                        subtitle: Text('Due: ${_formatDate(payment['date'])}'),
                        trailing: Text(
                          '₹${payment['amount'].toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
          ],

          const SizedBox(height: 16),

          // Recommendations
          if (_dashboardData!['recommendations'] != null &&
              (_dashboardData!['recommendations'] as List?)?.isNotEmpty ==
                  true) ...[
            Text(
              'recommendations'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...((_dashboardData!['recommendations'] as List?) ?? [])
                .map((recommendation) => Card(
                      child: ListTile(
                        leading:
                            Icon(Icons.lightbulb, color: Colors.amber.shade600),
                        title: Text(recommendation),
                        dense: true,
                      ),
                    )),
          ],
        ],
      ),
    );
  }

  Widget _buildAdvisoryTab() {
    return _advisories.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.psychology, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'no_advisory_available'.tr(),
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _advisories.length,
            itemBuilder: (context, index) {
              final advisory = _advisories[index];
              return _buildAdvisoryCard(advisory);
            },
          );
  }

  Widget _buildLoansTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'loan_applications'.tr(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _applyForLoan(),
                icon: const Icon(Icons.add),
                label: Text('apply_loan'.tr()),
              ),
            ],
          ),
        ),
        Expanded(
          child: _loanApplications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.credit_card,
                          size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'no_loan_applications'.tr(),
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _loanApplications.length,
                  itemBuilder: (context, index) {
                    final application = _loanApplications[index];
                    return _buildLoanApplicationCard(application);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildInsuranceTab() {
    return _insurancePlans.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _insurancePlans.length,
            itemBuilder: (context, index) {
              final plan = _insurancePlans[index];
              return _buildInsurancePlanCard(plan);
            },
          );
  }

  Widget _buildGoalsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'financial_goals'.tr(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _createFinancialGoal(),
                icon: const Icon(Icons.add),
                label: Text('create_goal'.tr()),
              ),
            ],
          ),
        ),
        Expanded(
          child: _financialGoals.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.flag, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'no_financial_goals'.tr(),
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _financialGoals.length,
                  itemBuilder: (context, index) {
                    final goal = _financialGoals[index];
                    return _buildFinancialGoalCard(goal);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFinancialMetricCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvisoryCard(FinancialAdvisory advisory) {
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
                    advisory.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(advisory.priority),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    advisory.priority.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              advisory.advice,
              style: const TextStyle(fontSize: 14),
            ),
            if ((advisory.estimatedSavings ?? 0) > 0) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.savings, size: 16, color: Colors.green.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'Potential Savings: ₹${(advisory.estimatedSavings ?? 0).toStringAsFixed(0)}',
                    style:
                        TextStyle(fontSize: 12, color: Colors.green.shade600),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            if (advisory.actionItems.isNotEmpty) ...[
              const Text(
                'Action Items:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              ...advisory.actionItems.take(3).map((item) => Text('• $item')),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoanApplicationCard(LoanApplication application) {
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
                Text(
                  application.loanType.replaceAll('_', ' ').toUpperCase(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
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
            Text('Amount: ₹${application.requestedAmount.toStringAsFixed(0)}'),
            Text('Purpose: ${application.purpose}'),
            Text('Applied: ${_formatDate(application.applicationDate)}'),
            const SizedBox(height: 12),
            if (application.status == 'pending')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _viewLoanDetails(application),
                      child: Text('view_details'.tr()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _trackLoanApplication(application),
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

  Widget _buildInsurancePlanCard(InsurancePlan plan) {
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
                    plan.planName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                if (plan.isGovernmentScheme)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'GOVERNMENT',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              plan.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.monetization_on,
                    size: 16, color: Colors.green.shade600),
                const SizedBox(width: 4),
                Text(
                  'Premium: ₹${plan.premiumAmount.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 12, color: Colors.green.shade600),
                ),
                const Spacer(),
                Text(
                  'Coverage: ₹${plan.coverageAmount.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade600),
                ),
              ],
            ),
            if (plan.subsidyPercentage > 0) ...[
              const SizedBox(height: 4),
              Text(
                'Subsidy: ${plan.subsidyPercentage.toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 12, color: Colors.orange.shade600),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _viewInsuranceDetails(plan),
                    child: Text('view_details'.tr()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _applyForInsurance(plan),
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

  Widget _buildFinancialGoalCard(FinancialGoal goal) {
    final progress = 0.3; // Mock progress
    final monthsRemaining =
        goal.targetDate.difference(DateTime.now()).inDays / 30;

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
                    goal.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getGoalStatusColor(goal.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    goal.status.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              goal.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Target: ₹${goal.targetAmount.toStringAsFixed(0)}'),
                const Spacer(),
                Text('Due: ${_formatDate(goal.targetDate)}'),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              'Progress: ${(progress * 100).toStringAsFixed(0)}% • ${monthsRemaining.toStringAsFixed(0)} months remaining',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Color _getHealthScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getHealthScoreLabel(double score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs Improvement';
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.blue;
      case 'low':
        return Colors.grey;
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
      case 'disbursed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getGoalStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'paused':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _applyForLoan() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('apply_for_loan'.tr()),
        content:
            const Text('Loan application feature will be implemented soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ok'.tr()),
          ),
        ],
      ),
    );
  }

  void _viewLoanDetails(LoanApplication application) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Loan details feature coming soon!')),
    );
  }

  void _trackLoanApplication(LoanApplication application) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Loan tracking feature coming soon!')),
    );
  }

  void _viewInsuranceDetails(InsurancePlan plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(plan.planName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Provider: ${plan.provider}'),
            Text('Category: ${plan.category}'),
            Text('Coverage Period: ${plan.coveragePeriod}'),
            const SizedBox(height: 8),
            const Text('Coverage Details:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...plan.coverageDetails.map((detail) => Text('• $detail')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ok'.tr()),
          ),
        ],
      ),
    );
  }

  void _applyForInsurance(InsurancePlan plan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Insurance application for ${plan.planName} coming soon!')),
    );
  }

  void _createFinancialGoal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('create_financial_goal'.tr()),
        content: const Text(
            'Financial goal creation feature will be implemented soon!'),
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
