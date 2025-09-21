import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'home_screen.dart';
import 'crop_advice_screen.dart';
import 'disease_detection_screen.dart';
import 'knowledge_screen.dart';
import 'contact_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CropAdviceScreen(),
    const DiseaseDetectionScreen(),
    const KnowledgeScreen(),
    const ContactScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.agriculture),
            label: 'get_crop_advice'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.camera_alt),
            label: 'crop_disease_detection'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.book),
            label: 'knowledge_faqs'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.contact_support),
            label: 'contact_support'.tr(),
          ),
        ],
      ),
    );
  }
}
