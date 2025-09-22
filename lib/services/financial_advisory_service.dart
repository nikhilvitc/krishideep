import 'dart:math' as math;
import '../models/financial_advisory.dart';

class FinancialAdvisoryService {
  // Mock database
  static final List<LoanApplication> _loanApplications = [];
  static final List<InsurancePlan> _insurancePlans = [];
  static final List<CostBenefitAnalysis> _analyses = [];
  static final List<FinancialAdvisory> _advisories = [];
  static final List<FinancialGoal> _financialGoals = [];

  // Loan Services
  Future<LoanEligibility> checkLoanEligibility(
    String farmerId,
    String loanType,
    double requestedAmount,
    Map<String, dynamic> farmerProfile,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    final random = math.Random();

    // Calculate eligibility score based on farmer profile
    double score = 50; // Base score

    // Farm size factor
    final farmSize = farmerProfile['farmSize'] ?? 1.0;
    if (farmSize > 5)
      score += 15;
    else if (farmSize > 2)
      score += 10;
    else if (farmSize > 1) score += 5;

    // Annual income factor
    final annualIncome = farmerProfile['annualIncome'] ?? 100000.0;
    if (annualIncome > 500000)
      score += 15;
    else if (annualIncome > 200000)
      score += 10;
    else if (annualIncome > 100000) score += 5;

    // Credit history factor
    final creditScore = farmerProfile['creditScore'] ?? 'fair';
    switch (creditScore) {
      case 'excellent':
        score += 20;
        break;
      case 'good':
        score += 15;
        break;
      case 'fair':
        score += 8;
        break;
      case 'poor':
        score -= 10;
        break;
    }

    // Add some randomness
    score += random.nextDouble() * 10 - 5;
    score = math.max(0, math.min(100, score));

    final isEligible = score > 60;
    final maxAmount = _calculateMaxLoanAmount(loanType, farmSize, annualIncome);

    return LoanEligibility(
      farmerId: farmerId,
      loanType: loanType,
      isEligible: isEligible,
      eligibilityScore: score,
      maxEligibleAmount: maxAmount,
      recommendedAmount: math.min(requestedAmount, maxAmount * 0.8),
      suggestedInterestRate: _getSuggestedInterestRate(loanType, score),
      recommendedTenureMonths: _getRecommendedTenure(loanType, requestedAmount),
      eligibleCriteria: _getEligibleCriteria(farmerProfile, score),
      eligibleCriteriaHindi: _getEligibleCriteriaHindi(farmerProfile, score),
      ineligibleCriteria: _getIneligibleCriteria(farmerProfile, score),
      ineligibleCriteriaHindi:
          _getIneligibleCriteriaHindi(farmerProfile, score),
      improvementSuggestions: _getImprovementSuggestions(farmerProfile, score),
      improvementSuggestionsHindi:
          _getImprovementSuggestionsHindi(farmerProfile, score),
      assessmentDetails: {
        'farmSizeScore': farmSize > 2 ? 'Good' : 'Average',
        'incomeScore': annualIncome > 200000 ? 'Good' : 'Average',
        'creditScore': creditScore,
        'repaymentCapacity':
            '${((annualIncome * 0.3) / 12).toStringAsFixed(0)} per month',
      },
      requiredDocuments: _getRequiredDocuments(loanType),
      requiredDocumentsHindi: _getRequiredDocumentsHindi(loanType),
      bankRecommendations: {
        'HDFC Bank': 'Good agricultural loan rates',
        'SBI': 'Government schemes available',
        'ICICI Bank': 'Quick processing',
      },
    );
  }

  Future<String> submitLoanApplication(
    String farmerId,
    String loanType,
    double requestedAmount,
    String purpose,
    String purposeHindi,
    Map<String, dynamic> farmerProfile,
    List<String> documents,
  ) async {
    await Future.delayed(const Duration(seconds: 3));

    final applicationId = 'LOAN_${DateTime.now().millisecondsSinceEpoch}';

    final application = LoanApplication(
      id: applicationId,
      farmerId: farmerId,
      farmerName: farmerProfile['name'] ?? 'Demo Farmer',
      farmerNameHindi: farmerProfile['nameHindi'] ?? 'डेमो किसान',
      loanType: loanType,
      requestedAmount: requestedAmount,
      purpose: purpose,
      purposeHindi: purposeHindi,
      applicationDate: DateTime.now(),
      status: 'pending',
      farmSize: farmerProfile['farmSize'] ?? 1.0,
      annualIncome: farmerProfile['annualIncome'] ?? 100000.0,
      creditScore: farmerProfile['creditScore'] ?? 'fair',
      collaterals: farmerProfile['collaterals'] ?? ['Land Documents'],
      collateralsHindi: farmerProfile['collateralsHindi'] ?? ['भूमि दस्तावेज'],
      financialDetails: {
        'monthlyIncome': (farmerProfile['annualIncome'] ?? 100000.0) / 12,
        'existingLoans': farmerProfile['existingLoans'] ?? 0,
        'assets': farmerProfile['assets'] ?? {},
        'expenses': farmerProfile['expenses'] ?? {},
      },
    );

    _loanApplications.add(application);
    return applicationId;
  }

  Future<List<LoanApplication>> getLoanApplications(String farmerId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    return _loanApplications.where((app) => app.farmerId == farmerId).toList()
      ..sort((a, b) => b.applicationDate.compareTo(a.applicationDate));
  }

  // Insurance Services
  Future<List<InsurancePlan>> getInsurancePlans({
    String? category,
    double? farmSize,
    String? cropType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (_insurancePlans.isEmpty) {
      _generateMockInsurancePlans();
    }

    var plans = List<InsurancePlan>.from(_insurancePlans);

    // Apply filters
    if (category != null) {
      plans = plans.where((plan) => plan.category == category).toList();
    }

    // Sort by premium amount and government schemes
    plans.sort((a, b) {
      if (a.isGovernmentScheme && !b.isGovernmentScheme) return -1;
      if (!a.isGovernmentScheme && b.isGovernmentScheme) return 1;
      return a.subsidizedPremium.compareTo(b.subsidizedPremium);
    });

    return plans;
  }

  Future<Map<String, dynamic>> calculateInsurancePremium(
    String planId,
    double farmSize,
    String cropType,
    double expectedYield,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final plan = _insurancePlans.firstWhere((p) => p.id == planId);
    final random = math.Random();

    final basePremium = plan.premiumAmount * farmSize;
    final riskMultiplier = 0.8 + random.nextDouble() * 0.4; // 0.8 to 1.2
    final calculatedPremium = basePremium * riskMultiplier;
    final subsidizedPremium =
        calculatedPremium * (1 - plan.subsidyPercentage / 100);

    return {
      'planId': planId,
      'planName': plan.planName,
      'basePremium': basePremium,
      'riskMultiplier': riskMultiplier,
      'calculatedPremium': calculatedPremium,
      'subsidyAmount': calculatedPremium - subsidizedPremium,
      'finalPremium': subsidizedPremium,
      'coverageAmount': plan.coverageAmount * farmSize,
      'coveragePeriod': plan.coveragePeriod,
      'paymentSchedule': {
        'annual': subsidizedPremium,
        'semiAnnual': subsidizedPremium / 2 * 1.02,
        'quarterly': subsidizedPremium / 4 * 1.05,
      },
    };
  }

  // Cost-Benefit Analysis
  Future<CostBenefitAnalysis> generateCostBenefitAnalysis(
    String farmerId,
    String cropType,
    String cropTypeHindi,
    double farmSize,
    String season,
    Map<String, double>? customInputCosts,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    final random = math.Random();
    final analysisId = 'CBA_${DateTime.now().millisecondsSinceEpoch}';

    // Default input costs per acre (can be customized)
    final defaultCosts = _getDefaultInputCosts(cropType);
    final inputCosts = customInputCosts ?? defaultCosts;

    final totalCost =
        inputCosts.values.fold(0.0, (sum, cost) => sum + cost) * farmSize;
    final costPerAcre = inputCosts.map((key, value) => MapEntry(key, value));

    // Market analysis
    final expectedYield = _getExpectedYield(cropType, farmSize) *
        (0.8 + random.nextDouble() * 0.4);
    final marketPrice =
        _getCurrentMarketPrice(cropType) * (0.9 + random.nextDouble() * 0.2);

    final expectedRevenue = expectedYield * marketPrice * farmSize;
    final expectedProfit = expectedRevenue - totalCost;
    final profitMargin = (expectedProfit / expectedRevenue) * 100;
    final breakEvenPrice = totalCost / (expectedYield * farmSize);

    final analysis = CostBenefitAnalysis(
      id: analysisId,
      farmerId: farmerId,
      cropType: cropType,
      cropTypeHindi: cropTypeHindi,
      farmSize: farmSize,
      season: season,
      analysisDate: DateTime.now(),
      inputCosts:
          inputCosts.map((key, value) => MapEntry(key, value * farmSize)),
      inputCostsPerAcre: costPerAcre,
      totalInputCost: totalCost,
      expectedYield: expectedYield,
      expectedMarketPrice: marketPrice,
      expectedRevenue: expectedRevenue,
      expectedProfit: expectedProfit,
      profitMarginPercentage: profitMargin,
      breakEvenPrice: breakEvenPrice,
      riskFactors: {
        'weatherRisk': 'Medium',
        'marketPriceVolatility': 'High',
        'pestDiseaseRisk': 'Low',
        'inputCostInflation': 'Medium',
      },
      recommendations: _generateCostRecommendations(profitMargin, cropType),
      recommendationsHindi:
          _generateCostRecommendationsHindi(profitMargin, cropType),
      scenarioAnalysis: {
        'optimistic': expectedProfit * 1.3,
        'realistic': expectedProfit,
        'pessimistic': expectedProfit * 0.7,
      },
      subsidyBenefits: {
        'fertilizerSubsidy': inputCosts['fertilizer'] != null
            ? inputCosts['fertilizer']! * 0.15
            : 0,
        'seedSubsidy':
            inputCosts['seeds'] != null ? inputCosts['seeds']! * 0.1 : 0,
        'equipmentSubsidy': 5000.0,
      },
    );

    _analyses.add(analysis);
    return analysis;
  }

  // Financial Advisory
  Future<List<FinancialAdvisory>> getPersonalizedAdvisory(
    String farmerId,
    Map<String, dynamic> farmerProfile,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    if (_advisories.where((a) => a.farmerId == farmerId).isEmpty) {
      await _generatePersonalizedAdvisory(farmerId, farmerProfile);
    }

    return _advisories
        .where((advisory) => advisory.farmerId == farmerId)
        .toList()
      ..sort((a, b) => _getPriorityOrder(a.priority)
          .compareTo(_getPriorityOrder(b.priority)));
  }

  Future<Map<String, dynamic>> generateInvestmentPlan(
    String farmerId,
    double availableBudget,
    String investmentGoal,
    int timeHorizonMonths,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    final investmentOptions = [
      {
        'type': 'Drip Irrigation System',
        'typeHindi': 'ड्रिप सिंचाई प्रणाली',
        'cost': 80000.0,
        'expectedROI': 25.0,
        'paybackPeriod': 36.0,
        'description':
            'Reduces water consumption by 40% and increases crop yield',
        'descriptionHindi':
            'पानी की खपत 40% कम करता है और फसल की उपज बढ़ाता है',
      },
      {
        'type': 'Solar Water Pump',
        'typeHindi': 'सोलर वाटर पंप',
        'cost': 120000.0,
        'expectedROI': 30.0,
        'paybackPeriod': 48.0,
        'description':
            'Eliminates electricity bills and provides reliable water supply',
        'descriptionHindi':
            'बिजली के बिल को समाप्त करता है और विश्वसनीय पानी आपूर्ति प्रदान करता है',
      },
      {
        'type': 'Farm Mechanization',
        'typeHindi': 'कृषि यंत्रीकरण',
        'cost': 200000.0,
        'expectedROI': 20.0,
        'paybackPeriod': 60.0,
        'description': 'Reduces labor costs and increases farming efficiency',
        'descriptionHindi': 'श्रम लागत कम करता है और कृषि दक्षता बढ़ाता है',
      },
    ];

    // Filter options within budget
    final affordableOptions = investmentOptions
        .where((option) => option['cost'] as double <= availableBudget)
        .toList();

    // Calculate financing requirements
    final totalInvestmentCost = affordableOptions.isNotEmpty
        ? (affordableOptions.first['cost'] as double)
        : investmentOptions.first['cost'] as double;

    final gapFunding = totalInvestmentCost > availableBudget
        ? totalInvestmentCost - availableBudget
        : 0.0;

    return {
      'investmentOptions': affordableOptions.isNotEmpty
          ? affordableOptions
          : [investmentOptions.first],
      'recommendedInvestment': affordableOptions.isNotEmpty
          ? affordableOptions.first
          : investmentOptions.first,
      'totalBudgetRequired': totalInvestmentCost,
      'availableBudget': availableBudget,
      'gapFunding': gapFunding,
      'financingOptions': gapFunding > 0
          ? {
              'bankLoan': {
                'amount': gapFunding * 0.8,
                'interestRate': 8.5,
                'tenure': 60.0,
                'monthlyEMI': _calculateEMI(gapFunding * 0.8, 8.5, 60),
              },
              'governmentSubsidy': {
                'amount': gapFunding * 0.2,
                'schemes': ['PMKSY', 'Solar Pump Scheme'],
              },
            }
          : {},
      'expectedReturns': {
        'annualSavings': totalInvestmentCost * 0.15,
        'totalROI': totalInvestmentCost *
            (affordableOptions.isNotEmpty
                ? (affordableOptions.first['expectedROI'] as double) / 100
                : (investmentOptions.first['expectedROI'] as double) / 100),
        'paybackPeriod': affordableOptions.isNotEmpty
            ? affordableOptions.first['paybackPeriod']
            : investmentOptions.first['paybackPeriod'],
      },
      'riskAssessment': {
        'level': 'Low',
        'factors': [
          'Government support available',
          'Proven technology',
          'High demand'
        ],
      },
    };
  }

  // Financial Goals
  Future<String> createFinancialGoal(
    String farmerId,
    String goalType,
    String title,
    String titleHindi,
    String description,
    String descriptionHindi,
    double targetAmount,
    DateTime targetDate,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final goalId = 'GOAL_${DateTime.now().millisecondsSinceEpoch}';
    final monthsToTarget = targetDate.difference(DateTime.now()).inDays / 30;
    final monthlySaving = targetAmount / monthsToTarget;

    final goal = FinancialGoal(
      id: goalId,
      farmerId: farmerId,
      goalType: goalType,
      title: title,
      titleHindi: titleHindi,
      description: description,
      descriptionHindi: descriptionHindi,
      targetAmount: targetAmount,
      targetDate: targetDate,
      createdAt: DateTime.now(),
      status: 'active',
      milestones: _generateMilestones(targetAmount),
      milestonesHindi: _generateMilestonesHindi(targetAmount),
      actionPlan: {
        'monthlyTarget': monthlySaving,
        'savingsStrategies': [
          'Reduce input costs',
          'Diversify income',
          'Use subsidies'
        ],
        'trackingMethod': 'Monthly review',
      },
      monthlySavingRequired: monthlySaving,
      strategies: _getGoalStrategies(goalType),
      strategiesHindi: _getGoalStrategiesHindi(goalType),
    );

    _financialGoals.add(goal);
    return goalId;
  }

  Future<List<FinancialGoal>> getFinancialGoals(String farmerId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return _financialGoals.where((goal) => goal.farmerId == farmerId).toList()
      ..sort((a, b) => a.targetDate.compareTo(b.targetDate));
  }

  // Financial Statistics and Reports
  Future<Map<String, dynamic>> getFinancialDashboard(String farmerId) async {
    await Future.delayed(const Duration(seconds: 1));

    final random = math.Random();

    return {
      'totalAssets': 500000 + random.nextDouble() * 1000000,
      'totalLiabilities': 50000 + random.nextDouble() * 200000,
      'netWorth': 450000 + random.nextDouble() * 800000,
      'monthlyIncome': 25000 + random.nextDouble() * 50000,
      'monthlyExpenses': 18000 + random.nextDouble() * 30000,
      'savings': 7000 + random.nextDouble() * 20000,
      'activeLoans': _loanApplications
          .where((l) => l.farmerId == farmerId && l.status == 'disbursed')
          .length,
      'insuranceCoverage': 200000 + random.nextDouble() * 500000,
      'creditScore': 650 + random.nextInt(200),
      'financialHealthScore': 70 + random.nextInt(25),
      'monthlyTrends': {
        'income':
            List.generate(6, (index) => 20000 + random.nextDouble() * 30000),
        'expenses':
            List.generate(6, (index) => 15000 + random.nextDouble() * 25000),
        'savings':
            List.generate(6, (index) => 5000 + random.nextDouble() * 15000),
      },
      'upcomingPayments': [
        {
          'type': 'Loan EMI',
          'amount': 8500.0,
          'date': DateTime.now().add(Duration(days: 5))
        },
        {
          'type': 'Insurance Premium',
          'amount': 12000.0,
          'date': DateTime.now().add(Duration(days: 15))
        },
      ],
      'recommendations': [
        'Consider increasing your emergency fund to 6 months of expenses',
        'You can save ₹3,000 monthly by optimizing input costs',
        'Eligible for crop insurance subsidy - can save 50% on premium',
      ],
      'recommendationsHindi': [
        '6 महीने के खर्च के लिए अपना आपातकालीन फंड बढ़ाने पर विचार करें',
        'इनपुट लागत को अनुकूलित करके आप मासिक ₹3,000 बचा सकते हैं',
        'फसल बीमा सब्सिडी के लिए पात्र - प्रीमियम पर 50% बचा सकते हैं',
      ],
    };
  }

  // Private helper methods
  double _calculateMaxLoanAmount(
      String loanType, double farmSize, double annualIncome) {
    final baseMultiplier = {
          'crop_loan': 2.0,
          'farm_equipment': 5.0,
          'infrastructure': 10.0,
          'kisan_credit_card': 1.5,
        }[loanType] ??
        2.0;

    return math.min(
      annualIncome * baseMultiplier,
      farmSize * 100000, // ₹1 lakh per acre max
    );
  }

  double _getSuggestedInterestRate(String loanType, double eligibilityScore) {
    double baseRate = {
          'crop_loan': 7.0,
          'farm_equipment': 8.5,
          'infrastructure': 9.0,
          'kisan_credit_card': 7.5,
        }[loanType] ??
        8.0;

    // Adjust based on eligibility score
    if (eligibilityScore > 80)
      baseRate -= 0.5;
    else if (eligibilityScore < 60) baseRate += 1.0;

    return baseRate;
  }

  int _getRecommendedTenure(String loanType, double amount) {
    if (amount < 100000) return 24;
    if (amount < 500000) return 48;
    return 60;
  }

  List<String> _getEligibleCriteria(
      Map<String, dynamic> profile, double score) {
    final criteria = <String>[];
    if (profile['farmSize'] > 1) criteria.add('Owns agricultural land');
    if (profile['annualIncome'] > 100000)
      criteria.add('Adequate annual income');
    if (profile['creditScore'] != 'poor') criteria.add('Good credit history');
    return criteria;
  }

  List<String> _getEligibleCriteriaHindi(
      Map<String, dynamic> profile, double score) {
    final criteria = <String>[];
    if (profile['farmSize'] > 1) criteria.add('कृषि भूमि का स्वामित्व');
    if (profile['annualIncome'] > 100000) criteria.add('पर्याप्त वार्षिक आय');
    if (profile['creditScore'] != 'poor') criteria.add('अच्छा क्रेडिट इतिहास');
    return criteria;
  }

  List<String> _getIneligibleCriteria(
      Map<String, dynamic> profile, double score) {
    final criteria = <String>[];
    if (profile['farmSize'] <= 1) criteria.add('Insufficient farm size');
    if (profile['annualIncome'] <= 100000) criteria.add('Low annual income');
    if (profile['creditScore'] == 'poor') criteria.add('Poor credit history');
    return criteria;
  }

  List<String> _getIneligibleCriteriaHindi(
      Map<String, dynamic> profile, double score) {
    final criteria = <String>[];
    if (profile['farmSize'] <= 1) criteria.add('अपर्याप्त खेत का आकार');
    if (profile['annualIncome'] <= 100000) criteria.add('कम वार्षिक आय');
    if (profile['creditScore'] == 'poor') criteria.add('खराब क्रेडिट इतिहास');
    return criteria;
  }

  List<String> _getImprovementSuggestions(
      Map<String, dynamic> profile, double score) {
    final suggestions = <String>[];
    if (score < 70) {
      suggestions.add('Maintain regular income records');
      suggestions.add('Clear any pending loan dues');
      suggestions.add('Consider a co-applicant');
    }
    return suggestions;
  }

  List<String> _getImprovementSuggestionsHindi(
      Map<String, dynamic> profile, double score) {
    final suggestions = <String>[];
    if (score < 70) {
      suggestions.add('नियमित आय रिकॉर्ड बनाए रखें');
      suggestions.add('कोई भी लंबित ऋण की बकाया चुकता करें');
      suggestions.add('सह-आवेदक पर विचार करें');
    }
    return suggestions;
  }

  List<String> _getRequiredDocuments(String loanType) {
    return [
      'Aadhaar Card',
      'PAN Card',
      'Land Documents',
      'Bank Statements (6 months)',
      'Income Certificate',
      'Crop Insurance Papers',
    ];
  }

  List<String> _getRequiredDocumentsHindi(String loanType) {
    return [
      'आधार कार्ड',
      'पैन कार्ड',
      'भूमि दस्तावेज',
      'बैंक स्टेटमेंट (6 महीने)',
      'आय प्रमाण पत्र',
      'फसल बीमा पत्र',
    ];
  }

  void _generateMockInsurancePlans() {
    _insurancePlans.addAll([
      InsurancePlan(
        id: 'PMFBY_CROP',
        planName: 'PM Fasal Bima Yojana',
        planNameHindi: 'प्रधानमंत्री फसल बीमा योजना',
        category: 'crop_insurance',
        provider: 'Government of India',
        providerHindi: 'भारत सरकार',
        description: 'Comprehensive crop insurance covering yield losses',
        descriptionHindi: 'उत्पादन हानि को कवर करने वाला व्यापक फसल बीमा',
        premiumAmount: 2000.0,
        coverageAmount: 100000.0,
        coveragePeriod: '1_year',
        coverageDetails: [
          'Natural calamities coverage',
          'Pest and disease coverage',
          'Post-harvest losses',
        ],
        coverageDetailsHindi: [
          'प्राकृतिक आपदा कवरेज',
          'कीट और रोग कवरेज',
          'फसल कटाई के बाद की हानि',
        ],
        exclusions: ['War', 'Nuclear risks'],
        exclusionsHindi: ['युद्ध', 'परमाणु जोखिम'],
        subsidyPercentage: 50.0,
        claimProcess: 'Automatic settlement through satellites and drones',
        claimProcessHindi: 'उपग्रह और ड्रोन के माध्यम से स्वचालित निपटान',
        isGovernmentScheme: true,
        eligibilityCriteria: {'minFarmSize': 0.5, 'cropType': 'notified'},
        requiredDocuments: ['Land records', 'Bank account', 'Aadhaar'],
        requiredDocumentsHindi: ['भूमि अभिलेख', 'बैंक खाता', 'आधार'],
      ),
      InsurancePlan(
        id: 'LIVESTOCK_INSURANCE',
        planName: 'Livestock Insurance Scheme',
        planNameHindi: 'पशुधन बीमा योजना',
        category: 'livestock_insurance',
        provider: 'NABARD',
        providerHindi: 'नाबार्ड',
        description: 'Insurance coverage for cattle, buffalo, and poultry',
        descriptionHindi: 'गाय, भैंस और मुर्गी पालन के लिए बीमा कवरेज',
        premiumAmount: 1500.0,
        coverageAmount: 50000.0,
        coveragePeriod: '1_year',
        coverageDetails: [
          'Death due to accident',
          'Disease coverage',
          'Natural calamity losses',
        ],
        coverageDetailsHindi: [
          'दुर्घटना के कारण मृत्यु',
          'रोग कवरेज',
          'प्राकृतिक आपदा हानि',
        ],
        exclusions: ['Pre-existing diseases', 'Old age deaths'],
        exclusionsHindi: ['पूर्व-मौजूदा रोग', 'बुढ़ापे की मौत'],
        subsidyPercentage: 75.0,
        claimProcess: 'Veterinary certificate required for claims',
        claimProcessHindi: 'दावों के लिए पशु चिकित्सक प्रमाणपत्र आवश्यक',
        isGovernmentScheme: true,
        eligibilityCriteria: {'livestock': true, 'healthCertificate': true},
        requiredDocuments: ['Livestock registration', 'Health certificate'],
        requiredDocumentsHindi: ['पशुधन पंजीकरण', 'स्वास्थ्य प्रमाणपत्र'],
      ),
    ]);
  }

  Map<String, double> _getDefaultInputCosts(String cropType) {
    final costMaps = {
      'wheat': {
        'seeds': 3000.0,
        'fertilizer': 8000.0,
        'pesticide': 2000.0,
        'labor': 12000.0,
        'irrigation': 3000.0,
        'machinery': 4000.0,
      },
      'rice': {
        'seeds': 2500.0,
        'fertilizer': 9000.0,
        'pesticide': 3000.0,
        'labor': 15000.0,
        'irrigation': 5000.0,
        'machinery': 4500.0,
      },
      'cotton': {
        'seeds': 4000.0,
        'fertilizer': 10000.0,
        'pesticide': 8000.0,
        'labor': 18000.0,
        'irrigation': 6000.0,
        'machinery': 5000.0,
      },
    };

    return costMaps[cropType.toLowerCase()] ?? costMaps['wheat']!;
  }

  double _getExpectedYield(String cropType, double farmSize) {
    final yieldPerAcre = {
      'wheat': 2500.0, // kg per acre
      'rice': 3000.0,
      'cotton': 400.0, // kg per acre
    };

    return yieldPerAcre[cropType.toLowerCase()] ?? yieldPerAcre['wheat']!;
  }

  double _getCurrentMarketPrice(String cropType) {
    final pricePerKg = {
      'wheat': 25.0,
      'rice': 32.0,
      'cotton': 55.0,
    };

    return pricePerKg[cropType.toLowerCase()] ?? pricePerKg['wheat']!;
  }

  List<String> _generateCostRecommendations(
      double profitMargin, String cropType) {
    final recommendations = <String>[];

    if (profitMargin < 10) {
      recommendations
          .add('Consider reducing input costs through bulk purchasing');
      recommendations
          .add('Explore government subsidies for fertilizers and seeds');
      recommendations.add('Look into contract farming for assured price');
    } else if (profitMargin < 20) {
      recommendations.add('Good profit margin. Consider crop diversification');
      recommendations
          .add('Invest in better storage facilities to get better prices');
    } else {
      recommendations
          .add('Excellent profitability! Consider expanding farm area');
      recommendations
          .add('Invest in modern farming techniques for higher yields');
    }

    return recommendations;
  }

  List<String> _generateCostRecommendationsHindi(
      double profitMargin, String cropType) {
    final recommendations = <String>[];

    if (profitMargin < 10) {
      recommendations
          .add('थोक खरीदारी के माध्यम से इनपुट लागत कम करने पर विचार करें');
      recommendations.add('उर्वरक और बीजों के लिए सरकारी सब्सिडी देखें');
      recommendations.add('निश्चित मूल्य के लिए अनुबंध खेती देखें');
    } else if (profitMargin < 20) {
      recommendations.add('अच्छा लाभ मार्जिन। फसल विविधीकरण पर विचार करें');
      recommendations
          .add('बेहतर मूल्य पाने के लिए भंडारण सुविधाओं में निवेश करें');
    } else {
      recommendations
          .add('उत्कृष्ट लाभप्रदता! खेत क्षेत्र बढ़ाने पर विचार करें');
      recommendations
          .add('उच्च उत्पादन के लिए आधुनिक कृषि तकनीकों में निवेश करें');
    }

    return recommendations;
  }

  Future<void> _generatePersonalizedAdvisory(
      String farmerId, Map<String, dynamic> profile) async {
    final advisories = [
      FinancialAdvisory(
        id: 'ADV_${DateTime.now().millisecondsSinceEpoch}',
        farmerId: farmerId,
        advisoryType: 'loan_guidance',
        title: 'Optimize Your Agricultural Loans',
        titleHindi: 'अपने कृषि ऋणों का अनुकूलन करें',
        advice:
            'Based on your profile, you can reduce loan interest by 1.5% by switching to KCC. Your current loan utilization is optimal.',
        adviceHindi:
            'आपकी प्रोफ़ाइल के आधार पर, आप KCC में स्विच करके ऋण ब्याज 1.5% तक कम कर सकते हैं। आपका वर्तमान ऋण उपयोग इष्टतम है।',
        actionItems: [
          'Apply for Kisan Credit Card',
          'Compare interest rates from 3 banks',
          'Negotiate with current bank for better rates',
        ],
        actionItemsHindi: [
          'किसान क्रेडिट कार्ड के लिए आवेदन करें',
          '3 बैंकों से ब्याज दरों की तुलना करें',
          'बेहतर दरों के लिए वर्तमान बैंक से बातचीत करें',
        ],
        priority: 'high',
        generatedAt: DateTime.now(),
        implementationDeadline: DateTime.now().add(Duration(days: 30)),
        financialData: {
          'potentialSavings': 15000.0,
          'implementationCost': 2000.0,
          'timeToImplement': '15 days',
        },
        estimatedSavings: 15000.0,
        potentialRisk: 0.1,
      ),
      FinancialAdvisory(
        id: 'ADV_${DateTime.now().millisecondsSinceEpoch + 1}',
        farmerId: farmerId,
        advisoryType: 'investment_planning',
        title: 'Smart Investment in Drip Irrigation',
        titleHindi: 'ड्रिप सिंचाई में स्मार्ट निवेश',
        advice:
            'Installing drip irrigation can save 40% water costs and increase yield by 15%. ROI expected in 3 years with government subsidy.',
        adviceHindi:
            'ड्रिप सिंचाई लगाने से 40% पानी की लागत बच सकती है और उत्पादन 15% बढ़ सकता है। सरकारी सब्सिडी के साथ 3 साल में ROI की उम्मीद।',
        actionItems: [
          'Apply for drip irrigation subsidy',
          'Get quotations from 3 suppliers',
          'Plan installation before next season',
        ],
        actionItemsHindi: [
          'ड्रिप सिंचाई सब्सिडी के लिए आवेदन करें',
          '3 आपूर्तिकर्ताओं से कोटेशन प्राप्त करें',
          'अगले सीजन से पहले स्थापना की योजना बनाएं',
        ],
        priority: 'medium',
        generatedAt: DateTime.now(),
        financialData: {
          'investmentRequired': 80000.0,
          'subsidyAmount': 32000.0,
          'annualSavings': 25000.0,
        },
        estimatedSavings: 25000.0,
        potentialRisk: 0.2,
      ),
    ];

    _advisories.addAll(advisories);
  }

  int _getPriorityOrder(String priority) {
    switch (priority) {
      case 'urgent':
        return 1;
      case 'high':
        return 2;
      case 'medium':
        return 3;
      case 'low':
        return 4;
      default:
        return 5;
    }
  }

  double _calculateEMI(double principal, double rate, int months) {
    final monthlyRate = rate / (12 * 100);
    final emi = (principal * monthlyRate * math.pow(1 + monthlyRate, months)) /
        (math.pow(1 + monthlyRate, months) - 1);
    return emi;
  }

  List<String> _generateMilestones(double targetAmount) {
    return [
      'Save ${(targetAmount * 0.25).toStringAsFixed(0)} (25%)',
      'Save ${(targetAmount * 0.50).toStringAsFixed(0)} (50%)',
      'Save ${(targetAmount * 0.75).toStringAsFixed(0)} (75%)',
      'Achieve target amount',
    ];
  }

  List<String> _generateMilestonesHindi(double targetAmount) {
    return [
      '${(targetAmount * 0.25).toStringAsFixed(0)} बचाएं (25%)',
      '${(targetAmount * 0.50).toStringAsFixed(0)} बचाएं (50%)',
      '${(targetAmount * 0.75).toStringAsFixed(0)} बचाएं (75%)',
      'लक्ष्य राशि प्राप्त करें',
    ];
  }

  List<String> _getGoalStrategies(String goalType) {
    final strategies = {
      'equipment_purchase': [
        'Apply for agricultural equipment subsidies',
        'Consider leasing options',
        'Look for group purchasing discounts',
      ],
      'land_expansion': [
        'Explore land lease options',
        'Check government land allotment schemes',
        'Consider partnership farming',
      ],
      'income_increase': [
        'Diversify crop portfolio',
        'Add value-added products',
        'Explore agro-tourism opportunities',
      ],
    };

    return strategies[goalType] ??
        [
          'Create monthly saving plan',
          'Reduce unnecessary expenses',
          'Explore additional income sources',
        ];
  }

  List<String> _getGoalStrategiesHindi(String goalType) {
    final strategies = {
      'equipment_purchase': [
        'कृषि उपकरण सब्सिडी के लिए आवेदन करें',
        'लीजिंग विकल्पों पर विचार करें',
        'समूह खरीदारी छूट देखें',
      ],
      'land_expansion': [
        'भूमि लीज विकल्पों का पता लगाएं',
        'सरकारी भूमि आवंटन योजनाएं देखें',
        'साझेदारी खेती पर विचार करें',
      ],
      'income_increase': [
        'फसल पोर्टफोलियो में विविधता लाएं',
        'मूल्य संवर्धित उत्पाद जोड़ें',
        'कृषि-पर्यटन अवसरों का पता लगाएं',
      ],
    };

    return strategies[goalType] ??
        [
          'मासिक बचत योजना बनाएं',
          'अनावश्यक खर्च कम करें',
          'अतिरिक्त आय स्रोतों का पता लगाएं',
        ];
  }
}
