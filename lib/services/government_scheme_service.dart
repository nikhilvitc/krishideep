import 'dart:math' as math;
import '../models/government_scheme.dart';

class GovernmentSchemeService {
  // Mock schemes database
  static final List<GovernmentScheme> _schemes = [
    GovernmentScheme(
      id: 'pm_kisan',
      schemeName: 'PM-KISAN',
      schemeNameHindi: 'प्रधानमंत्री किसान सम्मान निधि',
      description: 'Direct income support to farmers with 6000 INR per year',
      descriptionHindi:
          'किसानों को प्रति वर्ष 6000 रुपये की प्रत्यक्ष आय सहायता',
      category: 'subsidy',
      eligibilityCriteria: 'Small and marginal farmers with cultivable land',
      eligibilityCriteriaHindi: 'खेती योग्य भूमि वाले छोटे और सीमांत किसान',
      maxBenefit: 6000.0,
      benefitType: 'amount',
      requiredDocuments: [
        'Aadhaar Card',
        'Bank Account Details',
        'Land Records'
      ],
      requiredDocumentsHindi: ['आधार कार्ड', 'बैंक खाता विवरण', 'भूमि अभिलेख'],
      applicationProcess:
          'Apply online through PM-KISAN portal or visit Common Service Center',
      applicationProcessHindi:
          'पीएम-किसान पोर्टल के माध्यम से ऑनलाइन आवेदन करें या कॉमन सर्विस सेंटर जाएं',
      contactInfo: 'Helpline: 155261 | Email: pmkisan-ict@gov.in',
      startDate: DateTime(2019, 2, 1),
      state: 'All India',
      stateHindi: 'सभी भारत',
    ),
    GovernmentScheme(
      id: 'pradhan_mantri_fasal_bima',
      schemeName: 'Pradhan Mantri Fasal Bima Yojana',
      schemeNameHindi: 'प्रधानमंत्री फसल बीमा योजना',
      description:
          'Crop insurance scheme covering yield losses due to natural calamities',
      descriptionHindi:
          'प्राकृतिक आपदाओं के कारण फसल हानि को कवर करने वाली बीमा योजना',
      category: 'insurance',
      eligibilityCriteria:
          'All farmers (loanee and non-loanee) growing notified crops',
      eligibilityCriteriaHindi:
          'अधिसूचित फसलों की खेती करने वाले सभी किसान (ऋणी और गैर-ऋणी)',
      maxBenefit: 200000.0,
      benefitType: 'amount',
      requiredDocuments: [
        'Aadhaar Card',
        'Bank Account',
        'Land Documents',
        'Sowing Certificate'
      ],
      requiredDocumentsHindi: [
        'आधार कार्ड',
        'बैंक खाता',
        'भूमि दस्तावेज',
        'बुआई प्रमाण पत्र'
      ],
      applicationProcess:
          'Apply through banks, CSCs, or online portal within cutoff dates',
      applicationProcessHindi:
          'कट-ऑफ तारीखों के भीतर बैंकों, सीएससी या ऑनलाइन पोर्टल के माध्यम से आवेदन करें',
      contactInfo: 'Toll Free: 14447 | Email: help.agri-insurance@gov.in',
      startDate: DateTime(2016, 4, 1),
      state: 'All India',
      stateHindi: 'सभी भारत',
    ),
    GovernmentScheme(
      id: 'kisan_credit_card',
      schemeName: 'Kisan Credit Card',
      schemeNameHindi: 'किसान क्रेडिट कार्ड',
      description: 'Credit support for farmers to meet agricultural expenses',
      descriptionHindi: 'कृषि व्यय को पूरा करने के लिए किसानों को ऋण सहायता',
      category: 'loan',
      eligibilityCriteria:
          'Farmers engaged in agriculture and allied activities',
      eligibilityCriteriaHindi: 'कृषि और संबद्ध गतिविधियों में लगे किसान',
      maxBenefit: 300000.0,
      benefitType: 'amount',
      requiredDocuments: [
        'Identity Proof',
        'Address Proof',
        'Land Documents',
        'Income Proof'
      ],
      requiredDocumentsHindi: [
        'पहचान प्रमाण',
        'पता प्रमाण',
        'भूमि दस्तावेज',
        'आय प्रमाण'
      ],
      applicationProcess:
          'Apply at any participating bank branch with required documents',
      applicationProcessHindi:
          'आवश्यक दस्तावेजों के साथ किसी भी सहभागी बैंक शाखा में आवेदन करें',
      contactInfo: 'Contact your nearest bank branch',
      startDate: DateTime(1998, 8, 1),
      state: 'All India',
      stateHindi: 'सभी भारत',
    ),
    GovernmentScheme(
      id: 'soil_health_card',
      schemeName: 'Soil Health Card Scheme',
      schemeNameHindi: 'मृदा स्वास्थ्य कार्ड योजना',
      description:
          'Free soil testing and health card for optimal fertilizer use',
      descriptionHindi:
          'इष्टतम उर्वरक उपयोग के लिए निःशुल्क मिट्टी परीक्षण और स्वास्थ्य कार्ड',
      category: 'welfare',
      eligibilityCriteria: 'All farmers with agricultural land',
      eligibilityCriteriaHindi: 'कृषि भूमि वाले सभी किसान',
      maxBenefit: 500.0,
      benefitType: 'fixed',
      requiredDocuments: ['Land Records', 'Identity Proof'],
      requiredDocumentsHindi: ['भूमि अभिलेख', 'पहचान प्रमाण'],
      applicationProcess:
          'Contact local agriculture department or visit soil testing labs',
      applicationProcessHindi:
          'स्थानीय कृषि विभाग से संपर्क करें या मिट्टी परीक्षण प्रयोगशाला जाएं',
      contactInfo: 'Contact District Agriculture Office',
      startDate: DateTime(2015, 2, 19),
      state: 'All India',
      stateHindi: 'सभी भारत',
    ),
    GovernmentScheme(
      id: 'organic_farming',
      schemeName: 'Organic Farming Promotion Scheme',
      schemeNameHindi: 'जैविक खेती संवर्धन योजना',
      description:
          'Financial assistance for organic farming adoption and certification',
      descriptionHindi: 'जैविक खेती अपनाने और प्रमाणीकरण के लिए वित्तीय सहायता',
      category: 'subsidy',
      eligibilityCriteria: 'Farmers willing to adopt organic farming practices',
      eligibilityCriteriaHindi: 'जैविक खेती प्रथाओं को अपनाने के इच्छुक किसान',
      maxBenefit: 25000.0,
      benefitType: 'amount',
      requiredDocuments: [
        'Land Records',
        'Bank Details',
        'Organic Farming Plan'
      ],
      requiredDocumentsHindi: ['भूमि अभिलेख', 'बैंक विवरण', 'जैविक खेती योजना'],
      applicationProcess: 'Apply through state agriculture departments',
      applicationProcessHindi: 'राज्य कृषि विभागों के माध्यम से आवेदन करें',
      contactInfo: 'State Agriculture Department',
      startDate: DateTime(2020, 4, 1),
      state: 'All India',
      stateHindi: 'सभी भारत',
    ),
    GovernmentScheme(
      id: 'drip_irrigation_subsidy',
      schemeName: 'Drip Irrigation Subsidy',
      schemeNameHindi: 'ड्रिप सिंचाई सब्सिडी',
      description: 'Subsidy for installing drip irrigation systems',
      descriptionHindi: 'ड्रिप सिंचाई सिस्टम स्थापित करने के लिए सब्सिडी',
      category: 'subsidy',
      eligibilityCriteria: 'Farmers with minimum 0.5 acres of land',
      eligibilityCriteriaHindi: 'न्यूनतम 0.5 एकड़ भूमि वाले किसान',
      maxBenefit: 50000.0,
      benefitType: 'percentage',
      requiredDocuments: [
        'Land Records',
        'Bank Account',
        'Quotation for Drip System'
      ],
      requiredDocumentsHindi: [
        'भूमि अभिलेख',
        'बैंक खाता',
        'ड्रिप सिस्टम का कोटेशन'
      ],
      applicationProcess: 'Apply through District Horticulture Office',
      applicationProcessHindi: 'जिला उद्यान विभाग के माध्यम से आवेदन करें',
      contactInfo: 'District Horticulture Office',
      startDate: DateTime(2018, 1, 1),
      state: 'All India',
      stateHindi: 'सभी भारत',
    ),
  ];

  static final List<SubsidyApplication> _applications = [];
  static final List<SchemeNotification> _notifications = [];

  // Get all available schemes
  Future<List<GovernmentScheme>> getAllSchemes() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List.from(_schemes);
  }

  // Get schemes by category
  Future<List<GovernmentScheme>> getSchemesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _schemes.where((scheme) => scheme.category == category).toList();
  }

  // Search schemes by name or description
  Future<List<GovernmentScheme>> searchSchemes(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final lowerQuery = query.toLowerCase();
    return _schemes.where((scheme) {
      return scheme.schemeName.toLowerCase().contains(lowerQuery) ||
          scheme.schemeNameHindi.contains(query) ||
          scheme.description.toLowerCase().contains(lowerQuery) ||
          scheme.descriptionHindi.contains(query);
    }).toList();
  }

  // Check eligibility for a scheme
  Future<EligibilityResult> checkEligibility(
    String schemeId,
    Map<String, dynamic> farmerData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final scheme = _schemes.firstWhere((s) => s.id == schemeId);
    final random = math.Random();

    // Mock eligibility calculation
    final eligibilityScore = 60 + random.nextDouble() * 35; // 60-95
    final isEligible = eligibilityScore > 70;

    final eligibleCriteria = <String>[];
    final ineligibleCriteria = <String>[];
    final eligibleCriteriaHindi = <String>[];
    final ineligibleCriteriaHindi = <String>[];

    // Simulate eligibility checks
    if (farmerData['hasLand'] == true) {
      eligibleCriteria.add('Has agricultural land');
      eligibleCriteriaHindi.add('कृषि भूमि है');
    } else {
      ineligibleCriteria.add('No agricultural land');
      ineligibleCriteriaHindi.add('कृषि भूमि नहीं है');
    }

    if (farmerData['farmSize'] != null && farmerData['farmSize'] > 0) {
      eligibleCriteria.add('Farm size meets criteria');
      eligibleCriteriaHindi.add('खेत का आकार मापदंडों को पूरा करता है');
    }

    if (farmerData['hasAadhaar'] == true) {
      eligibleCriteria.add('Has Aadhaar card');
      eligibleCriteriaHindi.add('आधार कार्ड है');
    } else {
      ineligibleCriteria.add('Aadhaar card required');
      ineligibleCriteriaHindi.add('आधार कार्ड आवश्यक है');
    }

    final estimatedBenefit =
        isEligible ? scheme.maxBenefit * (eligibilityScore / 100) : 0.0;

    final recommendations = <String>[];
    final recommendationsHindi = <String>[];

    if (isEligible) {
      recommendations.add('You are eligible! Apply as soon as possible.');
      recommendationsHindi.add('आप पात्र हैं! जल्द से जल्द आवेदन करें।');
      recommendations.add('Keep all required documents ready before applying.');
      recommendationsHindi
          .add('आवेदन करने से पहले सभी आवश्यक दस्तावेज तैयार रखें।');
    } else {
      recommendations
          .add('Complete the missing requirements to become eligible.');
      recommendationsHindi
          .add('पात्र बनने के लिए लापता आवश्यकताओं को पूरा करें।');
      recommendations.add('Contact local agriculture office for guidance.');
      recommendationsHindi
          .add('मार्गदर्शन के लिए स्थानीय कृषि कार्यालय से संपर्क करें।');
    }

    return EligibilityResult(
      schemeId: schemeId,
      isEligible: isEligible,
      eligibilityScore: eligibilityScore,
      eligibleCriteria: eligibleCriteria,
      ineligibleCriteria: ineligibleCriteria,
      eligibleCriteriaHindi: eligibleCriteriaHindi,
      ineligibleCriteriaHindi: ineligibleCriteriaHindi,
      estimatedBenefit: estimatedBenefit,
      recommendations: recommendations,
      recommendationsHindi: recommendationsHindi,
    );
  }

  // Submit subsidy application
  Future<String> submitApplication(
    String schemeId,
    Map<String, dynamic> applicationData,
    List<String> documentPaths,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    final applicationId = 'APP_${DateTime.now().millisecondsSinceEpoch}';

    final application = SubsidyApplication(
      id: applicationId,
      schemeId: schemeId,
      farmerName: applicationData['farmerName'] ?? 'Demo Farmer',
      farmerId: applicationData['farmerId'] ?? 'FARMER123',
      mobileNumber: applicationData['mobileNumber'] ?? '+919876543210',
      applicationData: applicationData,
      status: 'submitted',
      submissionDate: DateTime.now(),
      uploadedDocuments: documentPaths,
    );

    _applications.add(application);

    // Create notification
    final notification = SchemeNotification(
      id: 'NOTIF_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Application Submitted Successfully',
      titleHindi: 'आवेदन सफलतापूर्वक जमा किया गया',
      message:
          'Your application for ${_schemes.firstWhere((s) => s.id == schemeId).schemeName} has been submitted. Application ID: $applicationId',
      messageHindi:
          '${_schemes.firstWhere((s) => s.id == schemeId).schemeNameHindi} के लिए आपका आवेदन जमा हो गया है। आवेदन आईडी: $applicationId',
      type: 'status_update',
      schemeId: schemeId,
      createdAt: DateTime.now(),
      isImportant: true,
    );

    _notifications.add(notification);

    return applicationId;
  }

  // Get application status
  Future<SubsidyApplication?> getApplicationStatus(String applicationId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return _applications.firstWhere((app) => app.id == applicationId);
    } catch (e) {
      return null;
    }
  }

  // Get all applications for a farmer
  Future<List<SubsidyApplication>> getFarmerApplications(
      String farmerId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    return _applications.where((app) => app.farmerId == farmerId).toList();
  }

  // Get scheme notifications
  Future<List<SchemeNotification>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 400));

    // Generate some mock notifications if empty
    if (_notifications.isEmpty) {
      _generateMockNotifications();
    }

    return List.from(_notifications);
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = SchemeNotification(
        id: _notifications[index].id,
        title: _notifications[index].title,
        titleHindi: _notifications[index].titleHindi,
        message: _notifications[index].message,
        messageHindi: _notifications[index].messageHindi,
        type: _notifications[index].type,
        schemeId: _notifications[index].schemeId,
        createdAt: _notifications[index].createdAt,
        expiryDate: _notifications[index].expiryDate,
        isRead: true,
        isImportant: _notifications[index].isImportant,
      );
    }
  }

  // Get benefit calculator
  Future<Map<String, dynamic>> calculateBenefits(
    String schemeId,
    Map<String, dynamic> farmerData,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final scheme = _schemes.firstWhere((s) => s.id == schemeId);
    final random = math.Random();

    double estimatedBenefit = 0;
    String calculationBasis = '';
    Map<String, dynamic> breakdown = {};

    switch (scheme.benefitType) {
      case 'amount':
        estimatedBenefit = scheme.maxBenefit;
        calculationBasis = 'Fixed amount benefit';
        breakdown = {
          'baseAmount': scheme.maxBenefit,
          'deductions': 0,
          'finalAmount': estimatedBenefit,
        };
        break;

      case 'percentage':
        final projectCost = farmerData['projectCost'] ?? 100000.0;
        final subsidyRate = 40 + random.nextDouble() * 20; // 40-60%
        estimatedBenefit = projectCost * (subsidyRate / 100);
        estimatedBenefit = math.min(estimatedBenefit, scheme.maxBenefit);
        calculationBasis = '$subsidyRate% of project cost';
        breakdown = {
          'projectCost': projectCost,
          'subsidyRate': subsidyRate,
          'calculatedAmount': projectCost * (subsidyRate / 100),
          'maxBenefit': scheme.maxBenefit,
          'finalAmount': estimatedBenefit,
        };
        break;

      case 'fixed':
        estimatedBenefit = scheme.maxBenefit;
        calculationBasis = 'Fixed benefit amount';
        breakdown = {
          'fixedAmount': scheme.maxBenefit,
          'finalAmount': estimatedBenefit,
        };
        break;
    }

    return {
      'schemeId': schemeId,
      'schemeName': scheme.schemeName,
      'estimatedBenefit': estimatedBenefit,
      'calculationBasis': calculationBasis,
      'breakdown': breakdown,
      'disbursalMode': 'Direct Bank Transfer',
      'processingTime': '15-30 working days',
      'processingTimeHindi': '15-30 कार्य दिवस',
      'remarks': 'Benefits are subject to scheme guidelines and approval',
      'remarksHindi': 'लाभ योजना दिशानिर्देशों और अनुमोदन के अधीन हैं',
    };
  }

  // Get scheme statistics
  Future<Map<String, dynamic>> getSchemeStatistics() async {
    await Future.delayed(const Duration(milliseconds: 600));

    final random = math.Random();

    return {
      'totalSchemes': _schemes.length,
      'activeSchemes': _schemes.where((s) => s.isActive).length,
      'totalApplications': _applications.length,
      'approvedApplications': random.nextInt(_applications.length + 50),
      'disbursedAmount':
          random.nextDouble() * 10000000, // Random amount disbursed
      'beneficiaries': random.nextInt(100000) + 50000,
      'categoryWiseSchemes': {
        'subsidy': _schemes.where((s) => s.category == 'subsidy').length,
        'loan': _schemes.where((s) => s.category == 'loan').length,
        'insurance': _schemes.where((s) => s.category == 'insurance').length,
        'welfare': _schemes.where((s) => s.category == 'welfare').length,
      },
      'stateWiseSchemes': {
        'All India': _schemes.where((s) => s.state == 'All India').length,
        'State Specific': _schemes.where((s) => s.state != 'All India').length,
      },
    };
  }

  // Generate mock notifications
  void _generateMockNotifications() {
    final random = math.Random();
    final notifications = [
      {
        'title': 'New Scheme Launched',
        'titleHindi': 'नई योजना शुरू की गई',
        'message':
            'PM Drone Didi Scheme launched for women farmers. Apply now!',
        'messageHindi':
            'महिला किसानों के लिए पीएम ड्रोन दीदी योजना शुरू की गई। अभी आवेदन करें!',
        'type': 'new_scheme',
      },
      {
        'title': 'Application Deadline Reminder',
        'titleHindi': 'आवेदन समय सीमा अनुस्मारक',
        'message': 'Only 7 days left to apply for Organic Farming Subsidy',
        'messageHindi':
            'जैविक खेती सब्सिडी के लिए आवेदन करने में केवल 7 दिन बचे हैं',
        'type': 'deadline_reminder',
      },
      {
        'title': 'Disbursement Update',
        'titleHindi': 'वितरण अपडेट',
        'message': 'PM-KISAN 15th installment disbursed to eligible farmers',
        'messageHindi':
            'पीएम-किसान की 15वीं किस्त पात्र किसानों को वितरित की गई',
        'type': 'general',
      },
    ];

    for (int i = 0; i < notifications.length; i++) {
      final notif = notifications[i];
      _notifications.add(SchemeNotification(
        id: 'MOCK_NOTIF_$i',
        title: notif['title']!,
        titleHindi: notif['titleHindi']!,
        message: notif['message']!,
        messageHindi: notif['messageHindi']!,
        type: notif['type']!,
        createdAt: DateTime.now().subtract(Duration(hours: random.nextInt(72))),
        isImportant: i == 0,
      ));
    }
  }
}
