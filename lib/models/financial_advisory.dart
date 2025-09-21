// Financial Advisory models for loan eligibility, insurance, and cost-benefit analysis
class LoanApplication {
  final String id;
  final String farmerId;
  final String farmerName;
  final String farmerNameHindi;
  final String
      loanType; // 'crop_loan', 'farm_equipment', 'infrastructure', 'kisan_credit_card'
  final double requestedAmount;
  final String purpose;
  final String purposeHindi;
  final DateTime applicationDate;
  final String
      status; // 'pending', 'under_review', 'approved', 'rejected', 'disbursed'
  final double farmSize;
  final double annualIncome;
  final String creditScore; // 'excellent', 'good', 'fair', 'poor'
  final List<String> collaterals;
  final List<String> collateralsHindi;
  final Map<String, dynamic> financialDetails;
  final DateTime? approvalDate;
  final DateTime? disbursalDate;
  final double? approvedAmount;
  final double interestRate;
  final int repaymentPeriodMonths;

  const LoanApplication({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    required this.farmerNameHindi,
    required this.loanType,
    required this.requestedAmount,
    required this.purpose,
    required this.purposeHindi,
    required this.applicationDate,
    required this.status,
    required this.farmSize,
    required this.annualIncome,
    required this.creditScore,
    required this.collaterals,
    required this.collateralsHindi,
    required this.financialDetails,
    this.approvalDate,
    this.disbursalDate,
    this.approvedAmount,
    this.interestRate = 7.5,
    this.repaymentPeriodMonths = 60,
  });

  String get loanTypeDisplayName {
    switch (loanType) {
      case 'crop_loan':
        return 'Crop Loan';
      case 'farm_equipment':
        return 'Farm Equipment Loan';
      case 'infrastructure':
        return 'Infrastructure Loan';
      case 'kisan_credit_card':
        return 'Kisan Credit Card';
      default:
        return 'Agricultural Loan';
    }
  }

  String get loanTypeDisplayNameHindi {
    switch (loanType) {
      case 'crop_loan':
        return 'फसल ऋण';
      case 'farm_equipment':
        return 'कृषि उपकरण ऋण';
      case 'infrastructure':
        return 'अवसंरचना ऋण';
      case 'kisan_credit_card':
        return 'किसान क्रेडिट कार्ड';
      default:
        return 'कृषि ऋण';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case 'pending':
        return 'Pending Review';
      case 'under_review':
        return 'Under Review';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'disbursed':
        return 'Amount Disbursed';
      default:
        return 'Unknown';
    }
  }

  String get statusDisplayNameHindi {
    switch (status) {
      case 'pending':
        return 'समीक्षा लंबित';
      case 'under_review':
        return 'समीक्षाधीन';
      case 'approved':
        return 'स्वीकृत';
      case 'rejected':
        return 'अस्वीकृत';
      case 'disbursed':
        return 'राशि वितरित';
      default:
        return 'अज्ञात';
    }
  }
}

class InsurancePlan {
  final String id;
  final String planName;
  final String planNameHindi;
  final String
      category; // 'crop_insurance', 'livestock_insurance', 'equipment_insurance', 'life_insurance'
  final String provider;
  final String providerHindi;
  final String description;
  final String descriptionHindi;
  final double premiumAmount;
  final double coverageAmount;
  final String coveragePeriod; // '1_year', '3_years', '5_years'
  final List<String> coverageDetails;
  final List<String> coverageDetailsHindi;
  final List<String> exclusions;
  final List<String> exclusionsHindi;
  final double subsidyPercentage;
  final String claimProcess;
  final String claimProcessHindi;
  final bool isGovernmentScheme;
  final Map<String, dynamic> eligibilityCriteria;
  final List<String> requiredDocuments;
  final List<String> requiredDocumentsHindi;

  const InsurancePlan({
    required this.id,
    required this.planName,
    required this.planNameHindi,
    required this.category,
    required this.provider,
    required this.providerHindi,
    required this.description,
    required this.descriptionHindi,
    required this.premiumAmount,
    required this.coverageAmount,
    required this.coveragePeriod,
    required this.coverageDetails,
    required this.coverageDetailsHindi,
    required this.exclusions,
    required this.exclusionsHindi,
    this.subsidyPercentage = 0.0,
    required this.claimProcess,
    required this.claimProcessHindi,
    this.isGovernmentScheme = false,
    required this.eligibilityCriteria,
    required this.requiredDocuments,
    required this.requiredDocumentsHindi,
  });

  double get subsidizedPremium => premiumAmount * (1 - subsidyPercentage / 100);

  String get categoryDisplayName {
    switch (category) {
      case 'crop_insurance':
        return 'Crop Insurance';
      case 'livestock_insurance':
        return 'Livestock Insurance';
      case 'equipment_insurance':
        return 'Equipment Insurance';
      case 'life_insurance':
        return 'Life Insurance';
      default:
        return 'Agricultural Insurance';
    }
  }

  String get categoryDisplayNameHindi {
    switch (category) {
      case 'crop_insurance':
        return 'फसल बीमा';
      case 'livestock_insurance':
        return 'पशुधन बीमा';
      case 'equipment_insurance':
        return 'उपकरण बीमा';
      case 'life_insurance':
        return 'जीवन बीमा';
      default:
        return 'कृषि बीमा';
    }
  }
}

class CostBenefitAnalysis {
  final String id;
  final String farmerId;
  final String cropType;
  final String cropTypeHindi;
  final double farmSize; // in acres
  final String season;
  final DateTime analysisDate;
  final Map<String, double>
      inputCosts; // seed, fertilizer, pesticide, labor, etc.
  final Map<String, double> inputCostsPerAcre;
  final double totalInputCost;
  final double expectedYield; // kg/acre
  final double expectedMarketPrice; // per kg
  final double expectedRevenue;
  final double expectedProfit;
  final double profitMarginPercentage;
  final double breakEvenPrice;
  final Map<String, dynamic> riskFactors;
  final List<String> recommendations;
  final List<String> recommendationsHindi;
  final Map<String, double>
      scenarioAnalysis; // optimistic, realistic, pessimistic
  final Map<String, double> subsidyBenefits;

  const CostBenefitAnalysis({
    required this.id,
    required this.farmerId,
    required this.cropType,
    required this.cropTypeHindi,
    required this.farmSize,
    required this.season,
    required this.analysisDate,
    required this.inputCosts,
    required this.inputCostsPerAcre,
    required this.totalInputCost,
    required this.expectedYield,
    required this.expectedMarketPrice,
    required this.expectedRevenue,
    required this.expectedProfit,
    required this.profitMarginPercentage,
    required this.breakEvenPrice,
    required this.riskFactors,
    required this.recommendations,
    required this.recommendationsHindi,
    required this.scenarioAnalysis,
    required this.subsidyBenefits,
  });

  String get profitabilityRating {
    if (profitMarginPercentage >= 30) return 'Excellent';
    if (profitMarginPercentage >= 20) return 'Good';
    if (profitMarginPercentage >= 10) return 'Moderate';
    if (profitMarginPercentage >= 0) return 'Marginal';
    return 'Loss';
  }

  String get profitabilityRatingHindi {
    if (profitMarginPercentage >= 30) return 'उत्कृष्ट';
    if (profitMarginPercentage >= 20) return 'अच्छा';
    if (profitMarginPercentage >= 10) return 'मध्यम';
    if (profitMarginPercentage >= 0) return 'न्यूनतम';
    return 'हानि';
  }

  double get returnOnInvestment => (expectedProfit / totalInputCost) * 100;
}

class FinancialAdvisory {
  final String id;
  final String farmerId;
  final String
      advisoryType; // 'loan_guidance', 'investment_planning', 'risk_management', 'tax_planning'
  final String title;
  final String titleHindi;
  final String advice;
  final String adviceHindi;
  final List<String> actionItems;
  final List<String> actionItemsHindi;
  final String priority; // 'low', 'medium', 'high', 'urgent'
  final DateTime generatedAt;
  final DateTime? implementationDeadline;
  final Map<String, dynamic> financialData;
  final List<String> relatedDocuments;
  final double? estimatedSavings;
  final double? potentialRisk;
  final bool isPersonalized;

  const FinancialAdvisory({
    required this.id,
    required this.farmerId,
    required this.advisoryType,
    required this.title,
    required this.titleHindi,
    required this.advice,
    required this.adviceHindi,
    required this.actionItems,
    required this.actionItemsHindi,
    required this.priority,
    required this.generatedAt,
    this.implementationDeadline,
    required this.financialData,
    this.relatedDocuments = const [],
    this.estimatedSavings,
    this.potentialRisk,
    this.isPersonalized = true,
  });

  String get priorityDisplayName {
    switch (priority) {
      case 'low':
        return 'Low Priority';
      case 'medium':
        return 'Medium Priority';
      case 'high':
        return 'High Priority';
      case 'urgent':
        return 'Urgent';
      default:
        return 'Normal';
    }
  }

  String get priorityDisplayNameHindi {
    switch (priority) {
      case 'low':
        return 'कम प्राथमिकता';
      case 'medium':
        return 'मध्यम प्राथमिकता';
      case 'high':
        return 'उच्च प्राथमिकता';
      case 'urgent':
        return 'तत्काल';
      default:
        return 'सामान्य';
    }
  }
}

class LoanEligibility {
  final String farmerId;
  final String loanType;
  final bool isEligible;
  final double eligibilityScore; // 0-100
  final double maxEligibleAmount;
  final double recommendedAmount;
  final double suggestedInterestRate;
  final int recommendedTenureMonths;
  final List<String> eligibleCriteria;
  final List<String> eligibleCriteriaHindi;
  final List<String> ineligibleCriteria;
  final List<String> ineligibleCriteriaHindi;
  final List<String> improvementSuggestions;
  final List<String> improvementSuggestionsHindi;
  final Map<String, dynamic> assessmentDetails;
  final List<String> requiredDocuments;
  final List<String> requiredDocumentsHindi;
  final Map<String, String> bankRecommendations;

  const LoanEligibility({
    required this.farmerId,
    required this.loanType,
    required this.isEligible,
    required this.eligibilityScore,
    required this.maxEligibleAmount,
    required this.recommendedAmount,
    required this.suggestedInterestRate,
    required this.recommendedTenureMonths,
    required this.eligibleCriteria,
    required this.eligibleCriteriaHindi,
    required this.ineligibleCriteria,
    required this.ineligibleCriteriaHindi,
    required this.improvementSuggestions,
    required this.improvementSuggestionsHindi,
    required this.assessmentDetails,
    required this.requiredDocuments,
    required this.requiredDocumentsHindi,
    required this.bankRecommendations,
  });

  String get eligibilityGrade {
    if (eligibilityScore >= 90) return 'A+';
    if (eligibilityScore >= 80) return 'A';
    if (eligibilityScore >= 70) return 'B+';
    if (eligibilityScore >= 60) return 'B';
    if (eligibilityScore >= 50) return 'C';
    return 'D';
  }
}

class FinancialGoal {
  final String id;
  final String farmerId;
  final String
      goalType; // 'equipment_purchase', 'land_expansion', 'income_increase', 'debt_reduction'
  final String title;
  final String titleHindi;
  final String description;
  final String descriptionHindi;
  final double targetAmount;
  final DateTime targetDate;
  final DateTime createdAt;
  final String status; // 'active', 'achieved', 'paused', 'cancelled'
  final double currentProgress;
  final List<String> milestones;
  final List<String> milestonesHindi;
  final Map<String, dynamic> actionPlan;
  final double monthlySavingRequired;
  final List<String> strategies;
  final List<String> strategiesHindi;

  const FinancialGoal({
    required this.id,
    required this.farmerId,
    required this.goalType,
    required this.title,
    required this.titleHindi,
    required this.description,
    required this.descriptionHindi,
    required this.targetAmount,
    required this.targetDate,
    required this.createdAt,
    required this.status,
    this.currentProgress = 0.0,
    required this.milestones,
    required this.milestonesHindi,
    required this.actionPlan,
    required this.monthlySavingRequired,
    required this.strategies,
    required this.strategiesHindi,
  });

  double get progressPercentage => (currentProgress / targetAmount) * 100;

  int get daysRemaining => targetDate.difference(DateTime.now()).inDays;

  String get statusDisplayName {
    switch (status) {
      case 'active':
        return 'Active';
      case 'achieved':
        return 'Achieved';
      case 'paused':
        return 'Paused';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  String get statusDisplayNameHindi {
    switch (status) {
      case 'active':
        return 'सक्रिय';
      case 'achieved':
        return 'प्राप्त';
      case 'paused':
        return 'रुकी हुई';
      case 'cancelled':
        return 'रद्द';
      default:
        return 'अज्ञात';
    }
  }
}
