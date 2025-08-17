import 'package:pm25_app/core/constants/app_colors.dart';
import 'package:pm25_app/core/loggers/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeRepository {
  static const String _themeKey = 'themeMode';
  static const String _lastUpdatedKey = 'themeLastUpdated';
  final log = AppLogger('ThemeRepository');

  // 載入主題設定
  Future<Map<String, dynamic>> loadThemeSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeString = prefs.getString(_themeKey);
      final lastUpdatedString = prefs.getString(_lastUpdatedKey);

      AppThemeMode themeMode;
      try {
        themeMode = AppThemeMode.values
            .firstWhere((e) => e.toString() == 'AppThemeMode.$themeString');
      } catch (e) {
        log.w('無效的主題設定，使用預設值: $themeString');
        themeMode = AppThemeMode.system;
      }

      DateTime lastUpdated;
      if (lastUpdatedString != null) {
        lastUpdated = DateTime.parse(lastUpdatedString);
      } else {
        lastUpdated = DateTime.now();
      }

      return {
        'themeMode': themeMode,
        'lastUpdated': lastUpdated,
      };
    } catch (e, stack) {
      log.e('載入主題設定失敗', e, stack);
      return {
        'themeMode': AppThemeMode.system,
        'lastUpdated': DateTime.now(),
      };
    }
  }

  // 儲存主題設定
  Future<void> saveThemeSettings(Map<String, dynamic> settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeMode = settings['themeMode'] as AppThemeMode;
      final lastUpdated = settings['lastUpdated'] as DateTime;

      await prefs.setString(_themeKey, themeMode.toString().split('.').last);
      await prefs.setString(_lastUpdatedKey, lastUpdated.toIso8601String());
      log.i('主題設定儲存成功');
    } catch (e, stack) {
      log.e('儲存主題設定失敗', e, stack);
      rethrow;
    }
  }

  // 驗證主題模式值
  AppThemeMode _validateThemeMode(String? themeString) {
    if (themeString == null) return AppThemeMode.system;

    try {
      return AppThemeMode.values
          .firstWhere((e) => e.toString() == 'AppThemeMode.$themeString');
    } catch (e) {
      log.w('無效的主題設定，使用預設值: $themeString');
      return AppThemeMode.system;
    }
  }
}
