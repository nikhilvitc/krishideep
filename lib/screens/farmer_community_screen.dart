import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/farmer_community_service.dart';
import '../models/farmer_community.dart';

class FarmerCommunityScreen extends StatefulWidget {
  const FarmerCommunityScreen({super.key});

  @override
  State<FarmerCommunityScreen> createState() => _FarmerCommunityScreenState();
}

class _FarmerCommunityScreenState extends State<FarmerCommunityScreen>
    with TickerProviderStateMixin {
  final FarmerCommunityService _service = FarmerCommunityService();
  late TabController _tabController;

  List<ForumPost> _forumPosts = [];
  List<ExperienceShare> _experiences = [];
  List<CommunityMember> _members = [];
  List<ExpertAdvice> _expertAdvice = [];
  List<PeerLearningGroup> _learningGroups = [];

  bool _isLoading = true;
  String _error = '';
  String _selectedCategory = 'all';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'all',
    'crop_advice',
    'success_story',
    'market_info',
    'problem_solving',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
      // Load all data in parallel
      final results = await Future.wait([
        _service.getForumPosts(),
        _service.getExperienceShares(),
        _service.getCommunityMembers(),
        _service.getExpertAdvice(),
        _service.getPeerLearningGroups(),
      ]);

      setState(() {
        _forumPosts = results[0] as List<ForumPost>;
        _experiences = results[1] as List<ExperienceShare>;
        _members = results[2] as List<CommunityMember>;
        _expertAdvice = results[3] as List<ExpertAdvice>;
        _learningGroups = results[4] as List<PeerLearningGroup>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterPosts() {
    setState(() {
      _forumPosts = _forumPosts.where((post) {
        final matchesCategory =
            _selectedCategory == 'all' || post.category == _selectedCategory;
        final matchesSearch = _searchController.text.isEmpty ||
            post.title
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            post.titleHindi.contains(_searchController.text) ||
            post.content
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
        title: Text('farmer_community'.tr()),
        backgroundColor: Colors.teal.shade600,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: [
            Tab(text: 'forum'.tr()),
            Tab(text: 'experiences'.tr()),
            Tab(text: 'experts'.tr()),
            Tab(text: 'groups'.tr()),
            Tab(text: 'members'.tr()),
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
                    _buildForumTab(),
                    _buildExperiencesTab(),
                    _buildExpertsTab(),
                    _buildGroupsTab(),
                    _buildMembersTab(),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewPost(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildForumTab() {
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
                  hintText: 'search_posts'.tr(),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterPosts();
                          },
                        )
                      : null,
                ),
                onChanged: (value) => _filterPosts(),
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
                                _filterPosts();
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),

        // Posts List
        Expanded(
          child: _forumPosts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.forum, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'no_posts_found'.tr(),
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _forumPosts.length,
                  itemBuilder: (context, index) {
                    final post = _forumPosts[index];
                    return _buildForumPostCard(post);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildExperiencesTab() {
    return _experiences.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'no_experiences_shared'.tr(),
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _experiences.length,
            itemBuilder: (context, index) {
              final experience = _experiences[index];
              return _buildExperienceCard(experience);
            },
          );
  }

  Widget _buildExpertsTab() {
    return _expertAdvice.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'no_expert_advice'.tr(),
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _expertAdvice.length,
            itemBuilder: (context, index) {
              final advice = _expertAdvice[index];
              return _buildExpertAdviceCard(advice);
            },
          );
  }

  Widget _buildGroupsTab() {
    return _learningGroups.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.groups, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'no_learning_groups'.tr(),
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _learningGroups.length,
            itemBuilder: (context, index) {
              final group = _learningGroups[index];
              return _buildLearningGroupCard(group);
            },
          );
  }

  Widget _buildMembersTab() {
    return _members.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'no_members_found'.tr(),
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _members.length,
            itemBuilder: (context, index) {
              final member = _members[index];
              return _buildMemberCard(member);
            },
          );
  }

  Widget _buildForumPostCard(ForumPost post) {
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
                        post.title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        post.titleHindi,
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                if (post.isPinned)
                  Icon(Icons.push_pin, color: Colors.orange.shade600, size: 20),
                if (post.isExpertVerified)
                  Icon(Icons.verified, color: Colors.blue.shade600, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              post.content,
              style: const TextStyle(fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  post.authorName,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const Spacer(),
                Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  post.location,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.favorite, size: 16, color: Colors.red.shade400),
                const SizedBox(width: 4),
                Text('${post.likeCount}'),
                const SizedBox(width: 16),
                Icon(Icons.comment, size: 16, color: Colors.blue.shade400),
                const SizedBox(width: 4),
                Text('${post.commentCount}'),
                const Spacer(),
                Text(
                  _formatDate(post.createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: post.tags
                  .map((tag) => Chip(
                        label: Text(tag, style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.blue.shade50,
                        labelStyle: TextStyle(color: Colors.blue.shade700),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceCard(ExperienceShare experience) {
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
                  child: Text(
                    experience.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                if (experience.isFeatured)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'FEATURED',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              experience.experience,
              style: const TextStyle(fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.agriculture, size: 16, color: Colors.green.shade600),
                const SizedBox(width: 4),
                Text(
                  experience.cropType,
                  style: TextStyle(fontSize: 12, color: Colors.green.shade600),
                ),
                const Spacer(),
                Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  experience.farmerName,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.thumb_up, size: 16, color: Colors.blue.shade400),
                const SizedBox(width: 4),
                Text('${experience.helpfulCount} helpful'),
                const SizedBox(width: 16),
                Icon(Icons.visibility, size: 16, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Text('${experience.viewCount} views'),
                const Spacer(),
                Text(
                  _formatDate(experience.sharedAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpertAdviceCard(ExpertAdvice advice) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.school, color: Colors.blue.shade600),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        advice.expertName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        advice.expertise.replaceAll('_', ' ').toUpperCase(),
                        style: TextStyle(
                            fontSize: 12, color: Colors.blue.shade600),
                      ),
                    ],
                  ),
                ),
                if (advice.isVerifiedAnswer)
                  Icon(Icons.verified, color: Colors.green.shade600),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              advice.question,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              advice.answer,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.thumb_up, size: 16, color: Colors.blue.shade400),
                const SizedBox(width: 4),
                Text('${advice.helpfulVotes} helpful'),
                const Spacer(),
                Text(
                  _formatDate(advice.providedAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningGroupCard(PeerLearningGroup group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.teal.shade100,
                  child: Icon(Icons.groups, color: Colors.teal.shade600),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${group.memberIds.length} members',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(group.category),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getCategoryLabel(group.category),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              group.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  group.location,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const Spacer(),
                Text(
                  'Created ${_formatDate(group.createdAt)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard(CommunityMember member) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.teal.shade100,
              child: Text(
                member.name.substring(0, 1),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        member.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      if (member.isExpert)
                        Icon(Icons.verified,
                            color: Colors.blue.shade600, size: 16),
                      if (member.isVerifiedFarmer)
                        Icon(Icons.check_circle,
                            color: Colors.green.shade600, size: 16),
                    ],
                  ),
                  Text(
                    member.location,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Text(
                    '${member.farmSize.toStringAsFixed(1)} acres • ${member.membershipLevel}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber.shade600),
                      const SizedBox(width: 4),
                      Text(
                        member.communityRating.toStringAsFixed(1),
                        style: TextStyle(
                            fontSize: 12, color: Colors.amber.shade600),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${member.helpfulAnswers} helpful answers',
                        style: TextStyle(
                            fontSize: 12, color: Colors.blue.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'all':
        return 'all_categories'.tr();
      case 'crop_advice':
        return 'crop_advice'.tr();
      case 'success_story':
        return 'success_story'.tr();
      case 'market_info':
        return 'market_info'.tr();
      case 'problem_solving':
        return 'problem_solving'.tr();
      case 'technique_focused':
        return 'technique_focused'.tr();
      case 'region_based':
        return 'region_based'.tr();
      default:
        return category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'crop_advice':
        return Colors.green;
      case 'success_story':
        return Colors.orange;
      case 'market_info':
        return Colors.blue;
      case 'problem_solving':
        return Colors.red;
      case 'technique_focused':
        return Colors.purple;
      case 'region_based':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _createNewPost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('create_new_post'.tr()),
        content: const Text('Post creation feature will be implemented soon!'),
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
