import 'package:flutter/material.dart';
import 'package:pm25_app/ui/screens/home_screen.dart';

/// 用於管理引導頁狀態的 Provider
class GuideProvider extends ChangeNotifier {
  final PageController pageController = PageController();
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  final List<OnboardingData> pages = [
    OnboardingData(
      title: '即時空氣監測',
      description: '查看周邊地區的空氣品質指數 (AQI)。',
      icon: Icons.air, // 空氣 icon
    ),
    OnboardingData(
      title: '深度污染分析',
      description: '細看 PM2.5、PM10、CO…等各項污染物濃度。',
      icon: Icons.grain, // 顆粒物 icon
    ),
    OnboardingData(
      title: '健康智慧提醒',
      description: '空氣品質差時，自動推播健康防護建議。',
      icon: Icons.notifications_active, // 通知 icon
    ),
  ];

  void onPageChanged(int idx) {
    _currentIndex = idx;
    notifyListeners();
  }

  void nextPage() {
    if (_currentIndex < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void skip(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void finish(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
  });
}
