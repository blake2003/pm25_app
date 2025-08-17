import 'package:flutter/material.dart';
import 'package:pm25_app/core/constants/app_colors.dart';
import 'package:pm25_app/core/loggers/log.dart';
import 'package:pm25_app/features/settings/theme_repository.dart';

class ThemeProvider extends ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.system;
  DateTime _lastUpdated = DateTime.now();
  final ThemeRepository _themeRepository;
  final log = AppLogger('ThemeProvider');

  ThemeProvider({ThemeRepository? themeRepository})
      : _themeRepository = themeRepository ?? ThemeRepository();

  // Getters
  AppThemeMode get themeMode => _themeMode;
  DateTime get lastUpdated => _lastUpdated;

  // 將 AppThemeMode 轉換為 Flutter 的 ThemeMode
  ThemeMode get flutterThemeMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  // 載入主題設定
  Future<void> loadTheme() async {
    try {
      log.i('開始載入主題設定');
      final settings = await _themeRepository.loadThemeSettings();
      _themeMode = settings['themeMode'] ?? AppThemeMode.system;
      _lastUpdated = settings['lastUpdated'] ?? DateTime.now();
      notifyListeners();
      log.i('主題設定載入完成: $_themeMode');
    } catch (e, stack) {
      log.e('主題設定載入失敗', e, stack);
      // 使用預設設定
      _themeMode = AppThemeMode.system;
      _lastUpdated = DateTime.now();
      notifyListeners();
    }
  }

  // 切換主題
  Future<void> toggleTheme(AppThemeMode mode) async {
    try {
      log.i('切換主題: $_themeMode -> $mode');
      _themeMode = mode;
      _lastUpdated = DateTime.now();
      notifyListeners();

      await _themeRepository.saveThemeSettings({
        'themeMode': mode,
        'lastUpdated': _lastUpdated,
      });
      log.i('主題切換完成並已儲存');
    } catch (e, stack) {
      log.e('主題切換失敗', e, stack);
      rethrow;
    }
  }
}
