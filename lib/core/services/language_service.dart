import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/language/language_constants.dart';
import '../loggers/log.dart';

/// 語言服務
///
/// 負責管理語言切換、儲存和載入語言偏好設定
class LanguageService {
  final log = AppLogger('LanguageService');

  static LanguageService? _instance;
  static LanguageService get instance => _instance ??= LanguageService._();

  LanguageService._();

  /// 取得當前語言
  Future<String> getCurrentLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage =
          prefs.getString(LanguageConstants.languagePreferenceKey);

      if (savedLanguage != null &&
          LanguageConstants.isLanguageSupported(savedLanguage)) {
        log.i('載入已儲存的語言: $savedLanguage');
        return savedLanguage;
      }

      // 如果沒有儲存的語言或語言不支援，使用預設語言
      final defaultLanguage = LanguageConstants.defaultLanguage;
      log.i('使用預設語言: $defaultLanguage');
      return defaultLanguage;
    } catch (e, stack) {
      log.e('載入語言設定失敗', e, stack);
      return LanguageConstants.defaultLanguage;
    }
  }

  /// 設定語言
  Future<bool> setLanguage(String languageCode) async {
    try {
      if (!LanguageConstants.isLanguageSupported(languageCode)) {
        log.w('不支援的語言代碼: $languageCode');
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setString(
        LanguageConstants.languagePreferenceKey,
        languageCode,
      );

      if (success) {
        log.i('語言設定成功: $languageCode');
      } else {
        log.e('語言設定失敗: $languageCode');
      }

      return success;
    } catch (e, stack) {
      log.e('設定語言失敗', e, stack);
      return false;
    }
  }

  /// 取得 Locale 物件
  Future<Locale> getCurrentLocale() async {
    final languageCode = await getCurrentLanguage();
    final languageInfo = LanguageConstants.getLanguageInfo(languageCode);

    if (languageInfo != null) {
      // 解析 locale 字串，支援 zh_TW 格式
      if (languageInfo.locale.contains('_')) {
        final parts = languageInfo.locale.split('_');
        return Locale(parts[0], parts[1]);
      } else {
        return Locale(languageInfo.locale);
      }
    }

    // 如果找不到語言資訊，返回預設語言
    return const Locale('zh', 'TW');
  }

  /// 清除語言設定
  Future<bool> clearLanguagePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success =
          await prefs.remove(LanguageConstants.languagePreferenceKey);

      if (success) {
        log.i('語言設定已清除');
      } else {
        log.w('清除語言設定失敗');
      }

      return success;
    } catch (e, stack) {
      log.e('清除語言設定失敗', e, stack);
      return false;
    }
  }

  /// 取得支援的語言清單
  List<LanguageInfo> getSupportedLanguages() {
    return LanguageConstants.supportedLanguages;
  }

  /// 檢查語言是否已設定
  Future<bool> hasLanguagePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(LanguageConstants.languagePreferenceKey);
    } catch (e, stack) {
      log.e('檢查語言偏好設定失敗', e, stack);
      return false;
    }
  }

  /// 重設為系統語言
  Future<bool> resetToSystemLanguage() async {
    try {
      final systemLanguage = LanguageConstants.getSystemLanguage();
      log.i('重設為系統語言: $systemLanguage');
      return await setLanguage(systemLanguage);
    } catch (e, stack) {
      log.e('重設為系統語言失敗', e, stack);
      return false;
    }
  }
}
