import 'dart:math' as math;
import '../models/farmer_community.dart';

class FarmerCommunityService {
  // Mock database
  static final List<ForumPost> _forumPosts = [];
  static final List<ForumComment> _comments = [];
  static final List<ExperienceShare> _experiences = [];
  static final List<CommunityMember> _members = [];
  static final List<CommunityNotification> _notifications = [];
  static final List<PeerLearningGroup> _learningGroups = [];
  static final List<ExpertAdvice> _expertAdvice = [];

  // Forum Operations
  Future<List<ForumPost>> getForumPosts({
    String? category,
    String? searchQuery,
    int limit = 20,
    int offset = 0,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (_forumPosts.isEmpty) {
      _generateMockForumPosts();
    }

    var posts = List<ForumPost>.from(_forumPosts);

    // Filter by category
    if (category != null && category.isNotEmpty) {
      posts = posts.where((post) => post.category == category).toList();
    }

    // Search functionality
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      posts = posts
          .where((post) =>
              post.title.toLowerCase().contains(query) ||
              post.titleHindi.contains(searchQuery) ||
              post.content.toLowerCase().contains(query) ||
              post.contentHindi.contains(searchQuery) ||
              post.tags.any((tag) => tag.toLowerCase().contains(query)))
          .toList();
    }

    // Sort by creation date (newest first) and pinned posts
    posts.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });

    // Apply pagination
    final endIndex = math.min(offset + limit, posts.length);
    return posts.sublist(offset, endIndex);
  }

  Future<String> createForumPost(
    String authorId,
    String title,
    String titleHindi,
    String content,
    String contentHindi,
    String category,
    List<String> tags,
    List<String> tagsHindi,
    List<String> images,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final postId = 'POST_${DateTime.now().millisecondsSinceEpoch}';

    final post = ForumPost(
      id: postId,
      authorId: authorId,
      authorName: 'Demo Farmer', // In real app, get from user profile
      authorNameHindi: 'डेमो किसान',
      title: title,
      titleHindi: titleHindi,
      content: content,
      contentHindi: contentHindi,
      category: category,
      tags: tags,
      tagsHindi: tagsHindi,
      attachedImages: images,
      createdAt: DateTime.now(),
      location: 'Maharashtra',
      locationHindi: 'महाराष्ट्र',
      metadata: {
        'deviceInfo': 'Mobile App',
        'version': '1.0.0',
      },
    );

    _forumPosts.add(post);
    return postId;
  }

  Future<List<ForumComment>> getPostComments(String postId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (_comments.isEmpty) {
      _generateMockComments();
    }

    return _comments.where((comment) => comment.postId == postId).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future<String> addComment(
    String postId,
    String authorId,
    String content,
    String contentHindi,
    String? parentCommentId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final commentId = 'COMMENT_${DateTime.now().millisecondsSinceEpoch}';

    final comment = ForumComment(
      id: commentId,
      postId: postId,
      authorId: authorId,
      authorName: 'Demo User',
      authorNameHindi: 'डेमो उपयोगकर्ता',
      content: content,
      contentHindi: contentHindi,
      createdAt: DateTime.now(),
      parentCommentId: parentCommentId,
    );

    _comments.add(comment);

    // Update post comment count
    final postIndex = _forumPosts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      _forumPosts[postIndex] = ForumPost(
        id: _forumPosts[postIndex].id,
        authorId: _forumPosts[postIndex].authorId,
        authorName: _forumPosts[postIndex].authorName,
        authorNameHindi: _forumPosts[postIndex].authorNameHindi,
        title: _forumPosts[postIndex].title,
        titleHindi: _forumPosts[postIndex].titleHindi,
        content: _forumPosts[postIndex].content,
        contentHindi: _forumPosts[postIndex].contentHindi,
        category: _forumPosts[postIndex].category,
        tags: _forumPosts[postIndex].tags,
        tagsHindi: _forumPosts[postIndex].tagsHindi,
        attachedImages: _forumPosts[postIndex].attachedImages,
        createdAt: _forumPosts[postIndex].createdAt,
        lastUpdatedAt: DateTime.now(),
        likeCount: _forumPosts[postIndex].likeCount,
        commentCount: _forumPosts[postIndex].commentCount + 1,
        isPinned: _forumPosts[postIndex].isPinned,
        isExpertVerified: _forumPosts[postIndex].isExpertVerified,
        location: _forumPosts[postIndex].location,
        locationHindi: _forumPosts[postIndex].locationHindi,
        metadata: _forumPosts[postIndex].metadata,
      );
    }

    return commentId;
  }

  // Experience Sharing Operations
  Future<List<ExperienceShare>> getExperienceShares({
    String? category,
    String? cropType,
    bool? isFeatured,
    int limit = 10,
    int offset = 0,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    if (_experiences.isEmpty) {
      _generateMockExperiences();
    }

    var experiences = List<ExperienceShare>.from(_experiences);

    // Apply filters
    if (category != null) {
      experiences =
          experiences.where((exp) => exp.category == category).toList();
    }

    if (cropType != null) {
      experiences = experiences
          .where((exp) =>
              exp.cropType.toLowerCase().contains(cropType.toLowerCase()))
          .toList();
    }

    if (isFeatured != null) {
      experiences =
          experiences.where((exp) => exp.isFeatured == isFeatured).toList();
    }

    // Sort by helpful count and view count
    experiences.sort((a, b) {
      if (a.isFeatured && !b.isFeatured) return -1;
      if (!a.isFeatured && b.isFeatured) return 1;
      return (b.helpfulCount + b.viewCount)
          .compareTo(a.helpfulCount + a.viewCount);
    });

    // Apply pagination
    final endIndex = math.min(offset + limit, experiences.length);
    return experiences.sublist(offset, endIndex);
  }

  Future<String> shareExperience(
      String farmerId,
      String title,
      String titleHindi,
      String experience,
      String experienceHindi,
      String category,
      String cropType,
      String cropTypeHindi,
      String season,
      List<String> techniques,
      List<String> techniquesHindi,
      List<String> challenges,
      List<String> challengesHindi,
      List<String> lessons,
      List<String> lessonsHindi,
      {double? yieldAchieved,
      double? profitMargin,
      List<String>? images}) async {
    await Future.delayed(const Duration(seconds: 1));

    final experienceId = 'EXP_${DateTime.now().millisecondsSinceEpoch}';

    final experienceShare = ExperienceShare(
      id: experienceId,
      farmerId: farmerId,
      farmerName: 'Demo Farmer',
      farmerNameHindi: 'डेमो किसान',
      title: title,
      titleHindi: titleHindi,
      experience: experience,
      experienceHindi: experienceHindi,
      category: category,
      cropType: cropType,
      cropTypeHindi: cropTypeHindi,
      season: season,
      yieldAchieved: yieldAchieved,
      profitMargin: profitMargin,
      techniquesUsed: techniques,
      techniquesUsedHindi: techniquesHindi,
      challengesFaced: challenges,
      challengesFacedHindi: challengesHindi,
      lessonsLearned: lessons,
      lessonsLearnedHindi: lessonsHindi,
      images: images ?? [],
      sharedAt: DateTime.now(),
      location: 'Punjab',
      locationHindi: 'पंजाब',
    );

    _experiences.add(experienceShare);
    return experienceId;
  }

  // Community Members
  Future<List<CommunityMember>> getCommunityMembers({
    String? location,
    String? expertise,
    String? membershipLevel,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (_members.isEmpty) {
      _generateMockMembers();
    }

    var members = List<CommunityMember>.from(_members);

    // Apply filters
    if (location != null) {
      members = members
          .where((member) =>
              member.location.toLowerCase().contains(location.toLowerCase()))
          .toList();
    }

    if (membershipLevel != null) {
      members = members
          .where((member) => member.membershipLevel == membershipLevel)
          .toList();
    }

    // Sort by rating and helpful answers
    members.sort((a, b) => (b.communityRating * 10 + b.helpfulAnswers)
        .compareTo(a.communityRating * 10 + a.helpfulAnswers));

    return members.take(limit).toList();
  }

  // Expert Advice
  Future<List<ExpertAdvice>> getExpertAdvice({
    String? category,
    String? expertise,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (_expertAdvice.isEmpty) {
      _generateMockExpertAdvice();
    }

    var advice = List<ExpertAdvice>.from(_expertAdvice);

    // Apply filters
    if (category != null) {
      advice = advice.where((adv) => adv.category == category).toList();
    }

    if (expertise != null) {
      advice = advice.where((adv) => adv.expertise == expertise).toList();
    }

    // Sort by helpful votes and verification
    advice.sort((a, b) {
      if (a.isVerifiedAnswer && !b.isVerifiedAnswer) return -1;
      if (!a.isVerifiedAnswer && b.isVerifiedAnswer) return 1;
      return b.helpfulVotes.compareTo(a.helpfulVotes);
    });

    return advice.take(limit).toList();
  }

  Future<String> askExpert(
    String question,
    String questionHindi,
    String category,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    // Simulate expert response generation
    final questionId = 'QUESTION_${DateTime.now().millisecondsSinceEpoch}';

    // Generate automatic response from available experts
    final random = math.Random();
    final expertResponses = [
      {
        'answer':
            'Based on your question, I recommend conducting a soil test first to determine the exact nutrient requirements. This will help you choose the right fertilizer combination.',
        'answerHindi':
            'आपके प्रश्न के आधार पर, मैं पहले मिट्टी का परीक्षण करने की सिफारिश करता हूं ताकि सही पोषक तत्वों की आवश्यकताओं का पता लग सके। इससे आपको सही उर्वरक संयोजन चुनने में मदद मिलेगी।',
        'expert': 'Dr. Rajesh Kumar',
        'expertHindi': 'डॉ. राजेश कुमार',
        'expertise': 'soil_science',
      },
      {
        'answer':
            'For better pest management, try integrated pest management (IPM) approach. Use biological controls along with minimal chemical intervention.',
        'answerHindi':
            'बेहतर कीट प्रबंधन के लिए, एकीकृत कीट प्रबंधन (IPM) दृष्टिकोण अपनाएं। न्यूनतम रासायनिक हस्तक्षेप के साथ जैविक नियंत्रण का उपयोग करें।',
        'expert': 'Dr. Priya Sharma',
        'expertHindi': 'डॉ. प्रिया शर्मा',
        'expertise': 'pest_management',
      },
    ];

    final selectedResponse =
        expertResponses[random.nextInt(expertResponses.length)];

    final advice = ExpertAdvice(
      id: 'ADVICE_${DateTime.now().millisecondsSinceEpoch}',
      expertId: 'EXPERT_001',
      expertName: selectedResponse['expert']!,
      expertNameHindi: selectedResponse['expertHindi']!,
      questionId: questionId,
      question: question,
      questionHindi: questionHindi,
      answer: selectedResponse['answer']!,
      answerHindi: selectedResponse['answerHindi']!,
      category: category,
      expertise: selectedResponse['expertise']!,
      providedAt: DateTime.now(),
      isVerifiedAnswer: true,
      references: [
        'Agricultural Extension Guidelines 2024',
        'Integrated Farming Systems Manual',
      ],
      referencesHindi: [
        'कृषि विस्तार दिशानिर्देश 2024',
        'एकीकृत कृषि प्रणाली मैनुअल',
      ],
    );

    _expertAdvice.add(advice);
    return questionId;
  }

  // Peer Learning Groups
  Future<List<PeerLearningGroup>> getPeerLearningGroups({
    String? category,
    String? location,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (_learningGroups.isEmpty) {
      _generateMockLearningGroups();
    }

    var groups = List<PeerLearningGroup>.from(_learningGroups);

    // Apply filters
    if (category != null) {
      groups = groups.where((group) => group.category == category).toList();
    }

    if (location != null) {
      groups = groups
          .where((group) =>
              group.location.toLowerCase().contains(location.toLowerCase()))
          .toList();
    }

    // Sort by member count and activity
    groups = groups.where((group) => group.isActive).toList();
    groups.sort((a, b) => b.memberIds.length.compareTo(a.memberIds.length));

    return groups.take(limit).toList();
  }

  Future<String> createLearningGroup(
    String adminId,
    String name,
    String nameHindi,
    String description,
    String descriptionHindi,
    String category,
    List<String> tags,
    List<String> tagsHindi,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final groupId = 'GROUP_${DateTime.now().millisecondsSinceEpoch}';

    final group = PeerLearningGroup(
      id: groupId,
      name: name,
      nameHindi: nameHindi,
      description: description,
      descriptionHindi: descriptionHindi,
      category: category,
      adminId: adminId,
      memberIds: [adminId], // Admin is the first member
      location: 'India',
      locationHindi: 'भारत',
      createdAt: DateTime.now(),
      tags: tags,
      tagsHindi: tagsHindi,
    );

    _learningGroups.add(group);
    return groupId;
  }

  // Notifications
  Future<List<CommunityNotification>> getNotifications(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (_notifications.isEmpty) {
      _generateMockNotifications();
    }

    return _notifications.where((notif) => notif.recipientId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Community Statistics
  Future<Map<String, dynamic>> getCommunityStatistics() async {
    await Future.delayed(const Duration(milliseconds: 600));

    final random = math.Random();

    return {
      'totalMembers': _members.length + random.nextInt(1000),
      'totalPosts': _forumPosts.length + random.nextInt(500),
      'totalExperiences': _experiences.length + random.nextInt(200),
      'totalComments': _comments.length + random.nextInt(2000),
      'activeExperts': random.nextInt(20) + 10,
      'totalGroups': _learningGroups.length + random.nextInt(50),
      'dailyActiveUsers': random.nextInt(200) + 100,
      'monthlyActiveUsers': random.nextInt(2000) + 1000,
      'topCategories': {
        'crop_advice': random.nextInt(100) + 50,
        'market_info': random.nextInt(80) + 30,
        'success_story': random.nextInt(60) + 20,
        'problem_solving': random.nextInt(120) + 80,
      },
      'engagementMetrics': {
        'averagePostLikes': random.nextDouble() * 20 + 5,
        'averageComments': random.nextDouble() * 10 + 2,
        'helpfulAnswerRate': random.nextDouble() * 30 + 70,
        'responseTime': '${random.nextInt(60) + 30} minutes',
      },
    };
  }

  // Private helper methods for generating mock data
  void _generateMockForumPosts() {
    final random = math.Random();

    final mockPosts = [
      {
        'title': 'Best organic fertilizers for wheat crop',
        'titleHindi': 'गेहूं की फसल के लिए सर्वोत्तम जैविक उर्वरक',
        'content':
            'I have been experimenting with different organic fertilizers for my wheat crop. Based on my experience, cow manure mixed with compost works best.',
        'contentHindi':
            'मैं अपनी गेहूं की फसल के लिए विभिन्न जैविक उर्वरकों के साथ प्रयोग कर रहा हूं। मेरे अनुभव के आधार पर, गोबर खाद और कंपोस्ट का मिश्रण सबसे अच्छा काम करता है।',
        'category': 'crop_advice',
        'tags': ['organic', 'fertilizer', 'wheat'],
        'tagsHindi': ['जैविक', 'उर्वरक', 'गेहूं'],
      },
      {
        'title': 'Successful cotton farming with drip irrigation',
        'titleHindi': 'ड्रिप सिंचाई के साथ सफल कपास की खेती',
        'content':
            'This season I achieved 25% higher yield using drip irrigation system. Water consumption reduced by 40% and quality improved significantly.',
        'contentHindi':
            'इस सीजन में मैंने ड्रिप सिंचाई प्रणाली का उपयोग करके 25% अधिक उत्पादन प्राप्त किया। पानी की खपत 40% कम हो गई और गुणवत्ता में काफी सुधार हुआ।',
        'category': 'success_story',
        'tags': ['cotton', 'drip irrigation', 'success'],
        'tagsHindi': ['कपास', 'ड्रिप सिंचाई', 'सफलता'],
      },
      {
        'title': 'Current market prices in Maharashtra',
        'titleHindi': 'महाराष्ट्र में वर्तमान बाजार भाव',
        'content':
            'Sharing today\'s market rates from APMC Pune. Onion prices are up by 15% compared to last week.',
        'contentHindi':
            'APMC पुणे से आज के बाजार भाव साझा कर रहा हूं। प्याज की कीमतें पिछले सप्ताह की तुलना में 15% बढ़ी हैं।',
        'category': 'market_info',
        'tags': ['market', 'prices', 'onion', 'Maharashtra'],
        'tagsHindi': ['बाजार', 'भाव', 'प्याज', 'महाराष्ट्र'],
      },
    ];

    for (int i = 0; i < mockPosts.length; i++) {
      final post = mockPosts[i];
      _forumPosts.add(ForumPost(
        id: 'MOCK_POST_$i',
        authorId: 'USER_${random.nextInt(100)}',
        authorName: 'Farmer ${i + 1}',
        authorNameHindi: 'किसान ${i + 1}',
        title: post['title'] as String,
        titleHindi: post['titleHindi'] as String,
        content: post['content'] as String,
        contentHindi: post['contentHindi'] as String,
        category: post['category'] as String,
        tags: List<String>.from(post['tags']! as List),
        tagsHindi: List<String>.from(post['tagsHindi']! as List),
        createdAt: DateTime.now().subtract(Duration(days: random.nextInt(30))),
        likeCount: random.nextInt(50),
        commentCount: random.nextInt(20),
        isPinned: i == 0,
        isExpertVerified: random.nextBool(),
        location: 'Maharashtra',
        locationHindi: 'महाराष्ट्र',
      ));
    }
  }

  void _generateMockComments() {
    final random = math.Random();

    for (int i = 0; i < 10; i++) {
      _comments.add(ForumComment(
        id: 'MOCK_COMMENT_$i',
        postId: 'MOCK_POST_${i % 3}',
        authorId: 'USER_${random.nextInt(100)}',
        authorName: 'Commenter ${i + 1}',
        authorNameHindi: 'टिप्पणीकर्ता ${i + 1}',
        content:
            'Thank you for sharing this valuable information. Very helpful!',
        contentHindi:
            'इस मूल्यवान जानकारी को साझा करने के लिए धन्यवाद। बहुत उपयोगी!',
        createdAt: DateTime.now().subtract(Duration(hours: random.nextInt(48))),
        likeCount: random.nextInt(10),
        isExpertComment: random.nextBool(),
        isHelpful: random.nextBool(),
      ));
    }
  }

  void _generateMockExperiences() {
    final random = math.Random();

    final mockExperiences = [
      {
        'title': 'Integrated farming increased my income by 60%',
        'titleHindi': 'एकीकृत कृषि ने मेरी आय 60% बढ़ाई',
        'experience':
            'By combining crop farming with fish farming and dairy, I diversified my income sources and reduced risks.',
        'experienceHindi':
            'फसल की खेती को मछली पालन और डेयरी के साथ जोड़कर, मैंने अपनी आय के स्रोतों में विविधता लाई और जोखिम कम किया।',
        'category': 'success',
        'cropType': 'Mixed Farming',
        'cropTypeHindi': 'मिश्रित कृषि',
      },
      {
        'title': 'Lesson learned from crop failure',
        'titleHindi': 'फसल खराब होने से सीखा गया सबक',
        'experience':
            'Due to improper water management, I lost 30% of my crop. Now I use moisture sensors for better irrigation control.',
        'experienceHindi':
            'अनुचित जल प्रबंधन के कारण, मैंने अपनी फसल का 30% नुकसान उठाया। अब मैं बेहतर सिंचाई नियंत्रण के लिए नमी सेंसर का उपयोग करता हूं।',
        'category': 'failure',
        'cropType': 'Tomato',
        'cropTypeHindi': 'टमाटर',
      },
    ];

    for (int i = 0; i < mockExperiences.length; i++) {
      final exp = mockExperiences[i];
      _experiences.add(ExperienceShare(
        id: 'MOCK_EXP_$i',
        farmerId: 'FARMER_${random.nextInt(100)}',
        farmerName: 'Success Farmer ${i + 1}',
        farmerNameHindi: 'सफल किसान ${i + 1}',
        title: exp['title'] as String,
        titleHindi: exp['titleHindi'] as String,
        experience: exp['experience'] as String,
        experienceHindi: exp['experienceHindi'] as String,
        category: exp['category'] as String,
        cropType: exp['cropType'] as String,
        cropTypeHindi: exp['cropTypeHindi'] as String,
        season: 'Kharif 2024',
        yieldAchieved: 2500 + random.nextDouble() * 2000,
        profitMargin: 15 + random.nextDouble() * 35,
        techniquesUsed: ['Drip irrigation', 'Organic fertilizers', 'IPM'],
        techniquesUsedHindi: [
          'ड्रिप सिंचाई',
          'जैविक उर्वरक',
          'एकीकृत कीट प्रबंधन'
        ],
        challengesFaced: [
          'Weather variations',
          'Pest attacks',
          'Labor shortage'
        ],
        challengesFacedHindi: ['मौसम की मार', 'कीट आक्रमण', 'श्रमिक की कमी'],
        lessonsLearned: [
          'Plan for contingencies',
          'Diversify crops',
          'Use technology'
        ],
        lessonsLearnedHindi: [
          'आकस्मिकताओं के लिए योजना',
          'फसलों में विविधता',
          'तकनीक का उपयोग'
        ],
        sharedAt: DateTime.now().subtract(Duration(days: random.nextInt(60))),
        helpfulCount: random.nextInt(100),
        viewCount: random.nextInt(500),
        isFeatured: i == 0,
        location: 'Punjab',
        locationHindi: 'पंजाब',
      ));
    }
  }

  void _generateMockMembers() {
    final random = math.Random();
    final levels = ['beginner', 'intermediate', 'advanced', 'expert'];

    for (int i = 0; i < 20; i++) {
      _members.add(CommunityMember(
        id: 'MEMBER_$i',
        name: 'Farmer ${i + 1}',
        nameHindi: 'किसान ${i + 1}',
        profileImage: 'assets/images/profile_placeholder.png',
        location: 'Maharashtra',
        locationHindi: 'महाराष्ट्र',
        farmSize: 1.0 + random.nextDouble() * 10,
        cropSpecializations: ['Wheat', 'Rice', 'Cotton'],
        cropSpecializationsHindi: ['गेहूं', 'धान', 'कपास'],
        membershipLevel: levels[random.nextInt(levels.length)],
        postsCount: random.nextInt(50),
        helpfulAnswers: random.nextInt(30),
        communityRating: 3.0 + random.nextDouble() * 2,
        joinedDate:
            DateTime.now().subtract(Duration(days: random.nextInt(365))),
        isVerifiedFarmer: random.nextBool(),
        isExpert: i < 3,
        bio: 'Experienced farmer with focus on sustainable agriculture',
        bioHindi: 'टिकाऊ कृषि पर ध्यान देने वाला अनुभवी किसान',
        achievements: ['Best Yield 2023', 'Organic Certified'],
        achievementsHindi: ['सर्वश्रेष्ठ उत्पादन 2023', 'जैविक प्रमाणित'],
      ));
    }
  }

  void _generateMockExpertAdvice() {
    final random = math.Random();

    final mockAdvice = [
      {
        'question': 'How to control pest attack in tomato crop?',
        'questionHindi': 'टमाटर की फसल में कीट आक्रमण को कैसे नियंत्रित करें?',
        'answer':
            'Use IPM approach combining biological controls, neem oil spray, and yellow sticky traps. Monitor regularly and spray only when threshold is reached.',
        'answerHindi':
            'जैविक नियंत्रण, नीम तेल स्प्रे, और पीले स्टिकी ट्रैप्स को मिलाकर IPM दृष्टिकोण का उपयोग करें। नियमित निगरानी करें और केवल तभी स्प्रे करें जब सीमा पहुंच जाए।',
        'expertise': 'pest_management',
      },
      {
        'question': 'Best soil preparation for wheat sowing?',
        'questionHindi': 'गेहूं की बुआई के लिए सर्वोत्तम मिट्टी की तैयारी?',
        'answer':
            'Deep plowing followed by 2-3 harrowing. Add farmyard manure @10 tons/hectare. Ensure proper leveling for uniform water distribution.',
        'answerHindi':
            'गहरी जुताई के बाद 2-3 बार हैरो करें। 10 टन/हेक्टेयर की दर से गोबर खाद डालें। समान पानी वितरण के लिए उचित समतलीकरण सुनिश्चित करें।',
        'expertise': 'agronomy',
      },
    ];

    for (int i = 0; i < mockAdvice.length; i++) {
      final advice = mockAdvice[i];
      _expertAdvice.add(ExpertAdvice(
        id: 'MOCK_ADVICE_$i',
        expertId: 'EXPERT_${i + 1}',
        expertName: 'Dr. Expert ${i + 1}',
        expertNameHindi: 'डॉ. विशेषज्ञ ${i + 1}',
        questionId: 'QUESTION_$i',
        question: advice['question'] as String,
        questionHindi: advice['questionHindi'] as String,
        answer: advice['answer'] as String,
        answerHindi: advice['answerHindi'] as String,
        category: 'crop_advice',
        expertise: advice['expertise'] as String,
        providedAt:
            DateTime.now().subtract(Duration(hours: random.nextInt(168))),
        helpfulVotes: random.nextInt(50),
        isVerifiedAnswer: true,
        references: [
          'Agricultural Extension Guidelines',
          'Research Paper 2024'
        ],
        referencesHindi: ['कृषि विस्तार दिशानिर्देश', 'अनुसंधान पत्र 2024'],
      ));
    }
  }

  void _generateMockLearningGroups() {
    final random = math.Random();

    final mockGroups = [
      {
        'name': 'Organic Farming Enthusiasts',
        'nameHindi': 'जैविक खेती प्रेमी',
        'description':
            'Learn and share organic farming techniques and experiences',
        'descriptionHindi':
            'जैविक खेती तकनीकों और अनुभवों को सीखें और साझा करें',
        'category': 'technique_focused',
      },
      {
        'name': 'Punjab Wheat Growers',
        'nameHindi': 'पंजाब गेहूं उत्पादक',
        'description': 'Regional group for wheat farmers in Punjab',
        'descriptionHindi': 'पंजाब में गेहूं किसानों के लिए क्षेत्रीय समूह',
        'category': 'region_based',
      },
    ];

    for (int i = 0; i < mockGroups.length; i++) {
      final group = mockGroups[i];
      final memberCount = 10 + random.nextInt(40);
      _learningGroups.add(PeerLearningGroup(
        id: 'MOCK_GROUP_$i',
        name: group['name'] as String,
        nameHindi: group['nameHindi'] as String,
        description: group['description'] as String,
        descriptionHindi: group['descriptionHindi'] as String,
        category: group['category'] as String,
        adminId: 'ADMIN_$i',
        memberIds: List.generate(memberCount, (index) => 'MEMBER_$index'),
        location: 'All India',
        locationHindi: 'सभी भारत',
        createdAt: DateTime.now().subtract(Duration(days: random.nextInt(180))),
        tags: ['farming', 'community', 'learning'],
        tagsHindi: ['खेती', 'समुदाय', 'शिक्षा'],
      ));
    }
  }

  void _generateMockNotifications() {
    final random = math.Random();

    for (int i = 0; i < 5; i++) {
      _notifications.add(CommunityNotification(
        id: 'MOCK_NOTIF_$i',
        recipientId: 'USER_123',
        type: 'post_like',
        title: 'Your post got a new like!',
        titleHindi: 'आपकी पोस्ट को नया लाइक मिला!',
        message: 'Someone liked your post about organic farming',
        messageHindi: 'किसी ने जैविक खेती के बारे में आपकी पोस्ट को पसंद किया',
        relatedPostId: 'MOCK_POST_0',
        createdAt: DateTime.now().subtract(Duration(hours: random.nextInt(72))),
      ));
    }
  }
}
