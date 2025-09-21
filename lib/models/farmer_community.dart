// Farmer Community models for forums, experience sharing, and peer learning
class ForumPost {
  final String id;
  final String authorId;
  final String authorName;
  final String authorNameHindi;
  final String title;
  final String titleHindi;
  final String content;
  final String contentHindi;
  final String
      category; // 'crop_advice', 'market_info', 'success_story', 'problem_solving', 'general'
  final List<String> tags;
  final List<String> tagsHindi;
  final List<String> attachedImages;
  final DateTime createdAt;
  final DateTime? lastUpdatedAt;
  final int likeCount;
  final int commentCount;
  final bool isPinned;
  final bool isExpertVerified;
  final String location;
  final String locationHindi;
  final Map<String, dynamic> metadata;

  const ForumPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorNameHindi,
    required this.title,
    required this.titleHindi,
    required this.content,
    required this.contentHindi,
    required this.category,
    required this.tags,
    required this.tagsHindi,
    this.attachedImages = const [],
    required this.createdAt,
    this.lastUpdatedAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isPinned = false,
    this.isExpertVerified = false,
    required this.location,
    required this.locationHindi,
    this.metadata = const {},
  });

  String get categoryDisplayName {
    switch (category) {
      case 'crop_advice':
        return 'Crop Advice';
      case 'market_info':
        return 'Market Information';
      case 'success_story':
        return 'Success Story';
      case 'problem_solving':
        return 'Problem Solving';
      case 'general':
        return 'General Discussion';
      default:
        return 'Other';
    }
  }

  String get categoryDisplayNameHindi {
    switch (category) {
      case 'crop_advice':
        return 'फसल सलाह';
      case 'market_info':
        return 'बाजार जानकारी';
      case 'success_story':
        return 'सफलता की कहानी';
      case 'problem_solving':
        return 'समस्या समाधान';
      case 'general':
        return 'सामान्य चर्चा';
      default:
        return 'अन्य';
    }
  }
}

class ForumComment {
  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String authorNameHindi;
  final String content;
  final String contentHindi;
  final DateTime createdAt;
  final DateTime? lastUpdatedAt;
  final int likeCount;
  final String? parentCommentId; // For replies
  final List<String> attachedImages;
  final bool isExpertComment;
  final bool isHelpful;
  final Map<String, dynamic> metadata;

  const ForumComment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.authorNameHindi,
    required this.content,
    required this.contentHindi,
    required this.createdAt,
    this.lastUpdatedAt,
    this.likeCount = 0,
    this.parentCommentId,
    this.attachedImages = const [],
    this.isExpertComment = false,
    this.isHelpful = false,
    this.metadata = const {},
  });
}

class ExperienceShare {
  final String id;
  final String farmerId;
  final String farmerName;
  final String farmerNameHindi;
  final String title;
  final String titleHindi;
  final String experience;
  final String experienceHindi;
  final String
      category; // 'success', 'failure', 'innovation', 'technique', 'market'
  final String cropType;
  final String cropTypeHindi;
  final String season;
  final double? yieldAchieved;
  final double? profitMargin;
  final List<String> techniquesUsed;
  final List<String> techniquesUsedHindi;
  final List<String> challengesFaced;
  final List<String> challengesFacedHindi;
  final List<String> lessonsLearned;
  final List<String> lessonsLearnedHindi;
  final List<String> images;
  final DateTime sharedAt;
  final int helpfulCount;
  final int viewCount;
  final bool isFeatured;
  final String location;
  final String locationHindi;
  final Map<String, dynamic> additionalData;

  const ExperienceShare({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    required this.farmerNameHindi,
    required this.title,
    required this.titleHindi,
    required this.experience,
    required this.experienceHindi,
    required this.category,
    required this.cropType,
    required this.cropTypeHindi,
    required this.season,
    this.yieldAchieved,
    this.profitMargin,
    required this.techniquesUsed,
    required this.techniquesUsedHindi,
    required this.challengesFaced,
    required this.challengesFacedHindi,
    required this.lessonsLearned,
    required this.lessonsLearnedHindi,
    this.images = const [],
    required this.sharedAt,
    this.helpfulCount = 0,
    this.viewCount = 0,
    this.isFeatured = false,
    required this.location,
    required this.locationHindi,
    this.additionalData = const {},
  });

  String get categoryDisplayName {
    switch (category) {
      case 'success':
        return 'Success Story';
      case 'failure':
        return 'Lesson from Failure';
      case 'innovation':
        return 'Innovation';
      case 'technique':
        return 'New Technique';
      case 'market':
        return 'Market Experience';
      default:
        return 'General Experience';
    }
  }

  String get categoryDisplayNameHindi {
    switch (category) {
      case 'success':
        return 'सफलता की कहानी';
      case 'failure':
        return 'असफलता से सीख';
      case 'innovation':
        return 'नवाचार';
      case 'technique':
        return 'नई तकनीक';
      case 'market':
        return 'बाजार अनुभव';
      default:
        return 'सामान्य अनुभव';
    }
  }
}

class CommunityMember {
  final String id;
  final String name;
  final String nameHindi;
  final String profileImage;
  final String location;
  final String locationHindi;
  final double farmSize; // in acres
  final List<String> cropSpecializations;
  final List<String> cropSpecializationsHindi;
  final String
      membershipLevel; // 'beginner', 'intermediate', 'advanced', 'expert'
  final int postsCount;
  final int helpfulAnswers;
  final double communityRating;
  final DateTime joinedDate;
  final bool isVerifiedFarmer;
  final bool isExpert;
  final String bio;
  final String bioHindi;
  final List<String> achievements;
  final List<String> achievementsHindi;
  final Map<String, dynamic> stats;

  const CommunityMember({
    required this.id,
    required this.name,
    required this.nameHindi,
    required this.profileImage,
    required this.location,
    required this.locationHindi,
    required this.farmSize,
    required this.cropSpecializations,
    required this.cropSpecializationsHindi,
    required this.membershipLevel,
    this.postsCount = 0,
    this.helpfulAnswers = 0,
    this.communityRating = 0.0,
    required this.joinedDate,
    this.isVerifiedFarmer = false,
    this.isExpert = false,
    required this.bio,
    required this.bioHindi,
    this.achievements = const [],
    this.achievementsHindi = const [],
    this.stats = const {},
  });

  String get membershipDisplayName {
    switch (membershipLevel) {
      case 'beginner':
        return 'New Farmer';
      case 'intermediate':
        return 'Experienced Farmer';
      case 'advanced':
        return 'Advanced Farmer';
      case 'expert':
        return 'Expert Farmer';
      default:
        return 'Farmer';
    }
  }

  String get membershipDisplayNameHindi {
    switch (membershipLevel) {
      case 'beginner':
        return 'नया किसान';
      case 'intermediate':
        return 'अनुभवी किसान';
      case 'advanced':
        return 'उन्नत किसान';
      case 'expert':
        return 'विशेषज्ञ किसान';
      default:
        return 'किसान';
    }
  }
}

class CommunityNotification {
  final String id;
  final String recipientId;
  final String
      type; // 'post_like', 'comment', 'mention', 'expert_answer', 'achievement'
  final String title;
  final String titleHindi;
  final String message;
  final String messageHindi;
  final String? relatedPostId;
  final String? relatedCommentId;
  final String? senderId;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic> data;

  const CommunityNotification({
    required this.id,
    required this.recipientId,
    required this.type,
    required this.title,
    required this.titleHindi,
    required this.message,
    required this.messageHindi,
    this.relatedPostId,
    this.relatedCommentId,
    this.senderId,
    required this.createdAt,
    this.isRead = false,
    this.data = const {},
  });
}

class PeerLearningGroup {
  final String id;
  final String name;
  final String nameHindi;
  final String description;
  final String descriptionHindi;
  final String
      category; // 'crop_specific', 'region_based', 'technique_focused', 'general'
  final String adminId;
  final List<String> memberIds;
  final String location;
  final String locationHindi;
  final DateTime createdAt;
  final bool isPublic;
  final bool isActive;
  final int maxMembers;
  final List<String> tags;
  final List<String> tagsHindi;
  final Map<String, dynamic> groupSettings;

  const PeerLearningGroup({
    required this.id,
    required this.name,
    required this.nameHindi,
    required this.description,
    required this.descriptionHindi,
    required this.category,
    required this.adminId,
    required this.memberIds,
    required this.location,
    required this.locationHindi,
    required this.createdAt,
    this.isPublic = true,
    this.isActive = true,
    this.maxMembers = 50,
    this.tags = const [],
    this.tagsHindi = const [],
    this.groupSettings = const {},
  });

  String get categoryDisplayName {
    switch (category) {
      case 'crop_specific':
        return 'Crop Specific';
      case 'region_based':
        return 'Region Based';
      case 'technique_focused':
        return 'Technique Focused';
      case 'general':
        return 'General Learning';
      default:
        return 'Other';
    }
  }

  String get categoryDisplayNameHindi {
    switch (category) {
      case 'crop_specific':
        return 'फसल विशिष्ट';
      case 'region_based':
        return 'क्षेत्र आधारित';
      case 'technique_focused':
        return 'तकनीक केंद्रित';
      case 'general':
        return 'सामान्य शिक्षा';
      default:
        return 'अन्य';
    }
  }
}

class ExpertAdvice {
  final String id;
  final String expertId;
  final String expertName;
  final String expertNameHindi;
  final String questionId;
  final String question;
  final String questionHindi;
  final String answer;
  final String answerHindi;
  final String category;
  final String
      expertise; // 'agronomy', 'pest_management', 'soil_science', 'market_analysis'
  final DateTime providedAt;
  final int helpfulVotes;
  final bool isVerifiedAnswer;
  final List<String> attachments;
  final List<String> references;
  final List<String> referencesHindi;
  final Map<String, dynamic> adviceData;

  const ExpertAdvice({
    required this.id,
    required this.expertId,
    required this.expertName,
    required this.expertNameHindi,
    required this.questionId,
    required this.question,
    required this.questionHindi,
    required this.answer,
    required this.answerHindi,
    required this.category,
    required this.expertise,
    required this.providedAt,
    this.helpfulVotes = 0,
    this.isVerifiedAnswer = false,
    this.attachments = const [],
    this.references = const [],
    this.referencesHindi = const [],
    this.adviceData = const {},
  });

  String get expertiseDisplayName {
    switch (expertise) {
      case 'agronomy':
        return 'Crop Science Expert';
      case 'pest_management':
        return 'Pest Control Expert';
      case 'soil_science':
        return 'Soil Science Expert';
      case 'market_analysis':
        return 'Market Analysis Expert';
      default:
        return 'Agricultural Expert';
    }
  }

  String get expertiseDisplayNameHindi {
    switch (expertise) {
      case 'agronomy':
        return 'फसल विज्ञान विशेषज्ञ';
      case 'pest_management':
        return 'कीट नियंत्रण विशेषज्ञ';
      case 'soil_science':
        return 'मृदा विज्ञान विशेषज्ञ';
      case 'market_analysis':
        return 'बाजार विश्लेषण विशेषज्ञ';
      default:
        return 'कृषि विशेषज्ञ';
    }
  }
}
