import 'dart:ui';

import '../../../core/constants/language/language_constants.dart';
import '../../../core/loggers/log.dart';
import '../../../core/services/language_service.dart';

/// 語言 Repository
///
/// 負責語言資料的存取和管理，提供給 Provider 使用
class LanguageRepository {
  final log = AppLogger('LanguageRepository');
  final LanguageService _languageService = LanguageService.instance;

  /// 取得當前語言
  Future<String> getCurrentLanguage() async {
    log.d('取得當前語言');
    return await _languageService.getCurrentLanguage();
  }

  /// 設定語言
  Future<bool> setLanguage(String languageCode) async {
    log.d('設定語言: $languageCode');
    return await _languageService.setLanguage(languageCode);
  }

  /// 取得當前 Locale
  Future<Locale> getCurrentLocale() async {
    log.d('取得當前 Locale');
    return await _languageService.getCurrentLocale();
  }

  /// 取得支援的語言清單
  List<LanguageInfo> getSupportedLanguages() {
    log.d('取得支援的語言清單');
    return _languageService.getSupportedLanguages();
  }

  /// 檢查語言是否已設定
  Future<bool> hasLanguagePreference() async {
    log.d('檢查語言偏好設定');
    return await _languageService.hasLanguagePreference();
  }

  /// 重設為系統語言
  Future<bool> resetToSystemLanguage() async {
    log.d('重設為系統語言');
    return await _languageService.resetToSystemLanguage();
  }

  /// 清除語言設定
  Future<bool> clearLanguagePreference() async {
    log.d('清除語言設定');
    return await _languageService.clearLanguagePreference();
  }

  /// 取得語言資訊
  LanguageInfo? getLanguageInfo(String languageCode) {
    log.d('取得語言資訊: $languageCode');
    return LanguageConstants.getLanguageInfo(languageCode);
  }

  /// 檢查語言是否支援
  bool isLanguageSupported(String languageCode) {
    log.d('檢查語言是否支援: $languageCode');
    return LanguageConstants.isLanguageSupported(languageCode);
  }
}
