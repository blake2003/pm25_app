import 'package:flutter/material.dart';
import 'package:pm25_app/core/loggers/log.dart';
import 'package:pm25_app/ui/screens/main/home_screen.dart';

/// 用於管理引導頁狀態的 Provider
class GuideProvider extends ChangeNotifier {
  final PageController pageController = PageController();
  final log = AppLogger('GuideProvider');

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
    log.i('引導頁切換: $_currentIndex');
    notifyListeners();
  }

  void nextPage() {
    if (_currentIndex < pages.length - 1) {
      log.d('前往下一頁: $_currentIndex -> ${_currentIndex + 1}');
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      log.w('已是最後一頁，無法繼續');
    }
  }

  void skip(BuildContext context) {
    log.i('用戶跳過引導頁，直接進入主頁');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void finish(BuildContext context) {
    log.i('用戶完成引導頁，進入主頁');
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
