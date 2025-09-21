import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/knowledge_service.dart';
import '../models/faq.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final KnowledgeService _knowledgeService = KnowledgeService();
  final TextEditingController _searchController = TextEditingController();

  List<FAQ> _filteredFAQs = [];
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _filteredFAQs = _knowledgeService.getAllFAQs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('knowledge_faqs'.tr()),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'faqs'.tr()),
            Tab(text: 'guidelines'.tr()),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildFAQsTab(), _buildGuidelinesTab()],
      ),
    );
  }

  Widget _buildFAQsTab() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.green.shade700, Colors.green.shade50],
        ),
      ),
      child: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search FAQs...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: _filterFAQs,
                ),

                const SizedBox(height: 12),

                // Category Filter
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryChip('All'),
                      ..._knowledgeService.getCategories().map(
                        _buildCategoryChip,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // FAQs List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredFAQs.length,
              itemBuilder: (context, index) {
                return _buildFAQCard(_filteredFAQs[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelinesTab() {
    final guidelines = _knowledgeService.getFarmingGuidelines();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.green.shade700, Colors.green.shade50],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: guidelines.entries.map((entry) {
          return _buildGuidelineCard(entry.key, entry.value);
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
            _filterFAQs(_searchController.text);
          });
        },
        selectedColor: Colors.green.shade700,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _buildFAQCard(FAQ faq) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            context.locale.languageCode == 'hi'
                ? faq.questionHindi
                : faq.question,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                faq.category,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  context.locale.languageCode == 'hi'
                      ? faq.answerHindi
                      : faq.answer,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidelineCard(String title, List<String> guidelines) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          leading: Icon(
            _getIconForGuideline(title),
            color: Colors.green.shade700,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: guidelines.map((guideline) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6, right: 8),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.green.shade700,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            guideline,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForGuideline(String title) {
    switch (title) {
      case 'Soil Preparation':
        return Icons.landscape;
      case 'Seed Selection':
        return Icons.grass;
      case 'Planting':
        return Icons.agriculture;
      case 'Fertilization':
        return Icons.scatter_plot;
      case 'Irrigation':
        return Icons.water_drop;
      case 'Pest Management':
        return Icons.bug_report;
      default:
        return Icons.info;
    }
  }

  void _filterFAQs(String query) {
    setState(() {
      List<FAQ> allFAQs = _knowledgeService.getAllFAQs();

      // Filter by category
      if (_selectedCategory != 'All') {
        allFAQs = allFAQs
            .where((faq) => faq.category == _selectedCategory)
            .toList();
      }

      // Filter by search query
      if (query.isNotEmpty) {
        allFAQs = allFAQs.where((faq) {
          return faq.question.toLowerCase().contains(query.toLowerCase()) ||
              faq.questionHindi.contains(query) ||
              faq.answer.toLowerCase().contains(query.toLowerCase()) ||
              faq.answerHindi.contains(query);
        }).toList();
      }

      _filteredFAQs = allFAQs;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
