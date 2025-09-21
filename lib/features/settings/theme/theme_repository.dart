import 'package:pm25_app/core/constants/theme/theme_colors.dart';
import 'package:pm25_app/core/loggers/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 主題資料存取層
/// 負責主題設定的本地儲存和讀取，封裝 SharedPreferences 操作
class ThemeRepository {
  static const String _themeKey = 'themeMode';
  static const String _lastUpdatedKey = 'themeLastUpdated';
  final log = AppLogger('ThemeRepository');

  /// 載入主題設定
  /// 從 SharedPreferences 載入主題設定，包含錯誤處理和資料驗證
  Future<Map<String, dynamic>> loadThemeSettings() async {
    try {
      log.d('開始載入主題設定');
      final prefs = await SharedPreferences.getInstance();
      final themeString = prefs.getString(_themeKey);
      final lastUpdatedString = prefs.getString(_lastUpdatedKey);

      // 解析主題模式
      AppThemeMode themeMode;
      try {
        if (themeString != null) {
          themeMode = AppThemeMode.values
              .firstWhere((e) => e.toString() == 'AppThemeMode.$themeString');
        } else {
          log.w('未找到主題設定，使用預設值: auto');
          themeMode = AppThemeMode.auto;
        }
      } catch (e) {
        log.w('無效的主題設定: $themeString，使用預設值: auto');
        themeMode = AppThemeMode.auto;
      }

      // 解析最後更新時間
      DateTime lastUpdated;
      if (lastUpdatedString != null) {
        try {
          lastUpdated = DateTime.parse(lastUpdatedString);
        } catch (e) {
          log.w('無效的時間格式: $lastUpdatedString，使用當前時間');
          lastUpdated = DateTime.now();
        }
      } else {
        lastUpdated = DateTime.now();
      }

      final result = {
        'themeMode': themeMode,
        'lastUpdated': lastUpdated,
      };

      log.i('主題設定載入成功: ${AppColors.getThemeModeDescription(themeMode)}');
      return result;
    } catch (e, stack) {
      log.e('載入主題設定失敗', e, stack);
      return {
        'themeMode': AppThemeMode.auto,
        'lastUpdated': DateTime.now(),
      };
    }
  }

  /// 儲存主題設定
  /// 將主題設定儲存到 SharedPreferences，包含資料驗證
  Future<void> saveThemeSettings(Map<String, dynamic> settings) async {
    try {
      log.d('開始儲存主題設定');

      // 資料驗證
      if (!settings.containsKey('themeMode') ||
          !settings.containsKey('lastUpdated')) {
        throw ArgumentError('缺少必要的主題設定資料');
      }

      final themeMode = settings['themeMode'] as AppThemeMode;
      final lastUpdated = settings['lastUpdated'] as DateTime;

      // 驗證主題模式
      if (!AppThemeMode.values.contains(themeMode)) {
        throw ArgumentError('無效的主題模式: $themeMode');
      }

      // 驗證時間
      if (lastUpdated.isAfter(DateTime.now().add(Duration(days: 1))) ||
          lastUpdated.isBefore(DateTime.now().subtract(Duration(days: 365)))) {
        log.w('時間設定異常: $lastUpdated，使用當前時間');
        settings['lastUpdated'] = DateTime.now();
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, themeMode.toString().split('.').last);
      await prefs.setString(_lastUpdatedKey, lastUpdated.toIso8601String());

      log.i('主題設定儲存成功: ${AppColors.getThemeModeDescription(themeMode)}');
    } catch (e, stack) {
      log.e('儲存主題設定失敗', e, stack);
      rethrow;
    }
  }

  /// 清除主題設定
  /// 清除所有主題相關的本地儲存資料
  Future<void> clearThemeSettings() async {
    try {
      log.d('開始清除主題設定');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_themeKey);
      await prefs.remove(_lastUpdatedKey);
      log.i('主題設定清除成功');
    } catch (e, stack) {
      log.e('清除主題設定失敗', e, stack);
      rethrow;
    }
  }

  /// 驗證主題模式值
  /// 檢查主題模式是否有效
  bool isValidThemeMode(AppThemeMode themeMode) {
    return AppThemeMode.values.contains(themeMode);
  }

  /// 獲取主題設定的鍵值
  /// 用於測試和除錯
  static String get themeKey => _themeKey;
  static String get lastUpdatedKey => _lastUpdatedKey;

  /// 檢查是否有儲存的主題設定
  Future<bool> hasStoredSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_themeKey);
    } catch (e, stack) {
      log.e('檢查主題設定失敗', e, stack);
      return false;
    }
  }

  /// 獲取主題設定的最後修改時間
  Future<DateTime?> getLastModified() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastUpdatedString = prefs.getString(_lastUpdatedKey);
      if (lastUpdatedString != null) {
        return DateTime.parse(lastUpdatedString);
      }
      return null;
    } catch (e, stack) {
      log.e('獲取最後修改時間失敗', e, stack);
      return null;
    }
  }
}
