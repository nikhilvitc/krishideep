class GovernmentScheme {
  final String id;
  final String schemeName;
  final String schemeNameHindi;
  final String description;
  final String descriptionHindi;
  final String category; // subsidy, loan, insurance, welfare
  final String eligibilityCriteria;
  final String eligibilityCriteriaHindi;
  final double maxBenefit;
  final String benefitType; // amount, percentage, fixed
  final List<String> requiredDocuments;
  final List<String> requiredDocumentsHindi;
  final String applicationProcess;
  final String applicationProcessHindi;
  final String contactInfo;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final String state;
  final String stateHindi;

  GovernmentScheme({
    required this.id,
    required this.schemeName,
    required this.schemeNameHindi,
    required this.description,
    required this.descriptionHindi,
    required this.category,
    required this.eligibilityCriteria,
    required this.eligibilityCriteriaHindi,
    required this.maxBenefit,
    required this.benefitType,
    required this.requiredDocuments,
    required this.requiredDocumentsHindi,
    required this.applicationProcess,
    required this.applicationProcessHindi,
    required this.contactInfo,
    required this.startDate,
    this.endDate,
    this.isActive = true,
    required this.state,
    required this.stateHindi,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schemeName': schemeName,
      'schemeNameHindi': schemeNameHindi,
      'description': description,
      'descriptionHindi': descriptionHindi,
      'category': category,
      'eligibilityCriteria': eligibilityCriteria,
      'eligibilityCriteriaHindi': eligibilityCriteriaHindi,
      'maxBenefit': maxBenefit,
      'benefitType': benefitType,
      'requiredDocuments': requiredDocuments,
      'requiredDocumentsHindi': requiredDocumentsHindi,
      'applicationProcess': applicationProcess,
      'applicationProcessHindi': applicationProcessHindi,
      'contactInfo': contactInfo,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
      'state': state,
      'stateHindi': stateHindi,
    };
  }

  factory GovernmentScheme.fromJson(Map<String, dynamic> json) {
    return GovernmentScheme(
      id: json['id'],
      schemeName: json['schemeName'],
      schemeNameHindi: json['schemeNameHindi'],
      description: json['description'],
      descriptionHindi: json['descriptionHindi'],
      category: json['category'],
      eligibilityCriteria: json['eligibilityCriteria'],
      eligibilityCriteriaHindi: json['eligibilityCriteriaHindi'],
      maxBenefit: json['maxBenefit'],
      benefitType: json['benefitType'],
      requiredDocuments: List<String>.from(json['requiredDocuments']),
      requiredDocumentsHindi: List<String>.from(json['requiredDocumentsHindi']),
      applicationProcess: json['applicationProcess'],
      applicationProcessHindi: json['applicationProcessHindi'],
      contactInfo: json['contactInfo'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isActive: json['isActive'] ?? true,
      state: json['state'],
      stateHindi: json['stateHindi'],
    );
  }
}

class SubsidyApplication {
  final String id;
  final String schemeId;
  final String farmerName;
  final String farmerId;
  final String mobileNumber;
  final Map<String, dynamic> applicationData;
  final String status; // submitted, under_review, approved, rejected, disbursed
  final DateTime submissionDate;
  final DateTime? approvalDate;
  final DateTime? disbursalDate;
  final double? approvedAmount;
  final String? rejectionReason;
  final String? rejectionReasonHindi;
  final List<String> uploadedDocuments;

  SubsidyApplication({
    required this.id,
    required this.schemeId,
    required this.farmerName,
    required this.farmerId,
    required this.mobileNumber,
    required this.applicationData,
    required this.status,
    required this.submissionDate,
    this.approvalDate,
    this.disbursalDate,
    this.approvedAmount,
    this.rejectionReason,
    this.rejectionReasonHindi,
    this.uploadedDocuments = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schemeId': schemeId,
      'farmerName': farmerName,
      'farmerId': farmerId,
      'mobileNumber': mobileNumber,
      'applicationData': applicationData,
      'status': status,
      'submissionDate': submissionDate.toIso8601String(),
      'approvalDate': approvalDate?.toIso8601String(),
      'disbursalDate': disbursalDate?.toIso8601String(),
      'approvedAmount': approvedAmount,
      'rejectionReason': rejectionReason,
      'rejectionReasonHindi': rejectionReasonHindi,
      'uploadedDocuments': uploadedDocuments,
    };
  }

  factory SubsidyApplication.fromJson(Map<String, dynamic> json) {
    return SubsidyApplication(
      id: json['id'],
      schemeId: json['schemeId'],
      farmerName: json['farmerName'],
      farmerId: json['farmerId'],
      mobileNumber: json['mobileNumber'],
      applicationData: json['applicationData'],
      status: json['status'],
      submissionDate: DateTime.parse(json['submissionDate']),
      approvalDate: json['approvalDate'] != null
          ? DateTime.parse(json['approvalDate'])
          : null,
      disbursalDate: json['disbursalDate'] != null
          ? DateTime.parse(json['disbursalDate'])
          : null,
      approvedAmount: json['approvedAmount'],
      rejectionReason: json['rejectionReason'],
      rejectionReasonHindi: json['rejectionReasonHindi'],
      uploadedDocuments: List<String>.from(json['uploadedDocuments'] ?? []),
    );
  }
}

class EligibilityResult {
  final String schemeId;
  final bool isEligible;
  final double eligibilityScore; // 0-100
  final List<String> eligibleCriteria;
  final List<String> ineligibleCriteria;
  final List<String> eligibleCriteriaHindi;
  final List<String> ineligibleCriteriaHindi;
  final double estimatedBenefit;
  final List<String> recommendations;
  final List<String> recommendationsHindi;

  EligibilityResult({
    required this.schemeId,
    required this.isEligible,
    required this.eligibilityScore,
    required this.eligibleCriteria,
    required this.ineligibleCriteria,
    required this.eligibleCriteriaHindi,
    required this.ineligibleCriteriaHindi,
    required this.estimatedBenefit,
    required this.recommendations,
    required this.recommendationsHindi,
  });

  Map<String, dynamic> toJson() {
    return {
      'schemeId': schemeId,
      'isEligible': isEligible,
      'eligibilityScore': eligibilityScore,
      'eligibleCriteria': eligibleCriteria,
      'ineligibleCriteria': ineligibleCriteria,
      'eligibleCriteriaHindi': eligibleCriteriaHindi,
      'ineligibleCriteriaHindi': ineligibleCriteriaHindi,
      'estimatedBenefit': estimatedBenefit,
      'recommendations': recommendations,
      'recommendationsHindi': recommendationsHindi,
    };
  }

  factory EligibilityResult.fromJson(Map<String, dynamic> json) {
    return EligibilityResult(
      schemeId: json['schemeId'],
      isEligible: json['isEligible'],
      eligibilityScore: json['eligibilityScore'],
      eligibleCriteria: List<String>.from(json['eligibleCriteria']),
      ineligibleCriteria: List<String>.from(json['ineligibleCriteria']),
      eligibleCriteriaHindi: List<String>.from(json['eligibleCriteriaHindi']),
      ineligibleCriteriaHindi:
          List<String>.from(json['ineligibleCriteriaHindi']),
      estimatedBenefit: json['estimatedBenefit'],
      recommendations: List<String>.from(json['recommendations']),
      recommendationsHindi: List<String>.from(json['recommendationsHindi']),
    );
  }
}

class SchemeNotification {
  final String id;
  final String title;
  final String titleHindi;
  final String message;
  final String messageHindi;
  final String type; // new_scheme, deadline_reminder, status_update, general
  final String? schemeId;
  final DateTime createdAt;
  final DateTime? expiryDate;
  final bool isRead;
  final bool isImportant;

  SchemeNotification({
    required this.id,
    required this.title,
    required this.titleHindi,
    required this.message,
    required this.messageHindi,
    required this.type,
    this.schemeId,
    required this.createdAt,
    this.expiryDate,
    this.isRead = false,
    this.isImportant = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'titleHindi': titleHindi,
      'message': message,
      'messageHindi': messageHindi,
      'type': type,
      'schemeId': schemeId,
      'createdAt': createdAt.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'isRead': isRead,
      'isImportant': isImportant,
    };
  }

  factory SchemeNotification.fromJson(Map<String, dynamic> json) {
    return SchemeNotification(
      id: json['id'],
      title: json['title'],
      titleHindi: json['titleHindi'],
      message: json['message'],
      messageHindi: json['messageHindi'],
      type: json['type'],
      schemeId: json['schemeId'],
      createdAt: DateTime.parse(json['createdAt']),
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : null,
      isRead: json['isRead'] ?? false,
      isImportant: json['isImportant'] ?? false,
    );
  }
}
