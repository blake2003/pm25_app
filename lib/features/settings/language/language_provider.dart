import 'package:flutter/material.dart';

import '../../../core/constants/language/language_constants.dart';
import '../../../core/loggers/log.dart';
import 'language_repository.dart';

/// 語言 Provider
///
/// 使用 Provider 進行語言狀態管理，提供語言切換功能
class LanguageProvider extends ChangeNotifier {
  final log = AppLogger('LanguageProvider');
  final LanguageRepository _repository = LanguageRepository();

  // 私有狀態變數
  String _currentLanguage = LanguageConstants.defaultLanguage;
  Locale _currentLocale = const Locale('zh', 'TW');
  bool _isLoading = false;
  String? _error;

  // 公開 getter
  String get currentLanguage => _currentLanguage;
  Locale get currentLocale => _currentLocale;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<LanguageInfo> get supportedLanguages =>
      _repository.getSupportedLanguages();

  /// 初始化語言設定
  Future<void> initializeLanguage() async {
    log.i('初始化語言設定');
    _setLoading(true);
    _clearError();

    try {
      final language = await _repository.getCurrentLanguage();
      final locale = await _repository.getCurrentLocale();

      _currentLanguage = language;
      _currentLocale = locale;

      log.i('語言初始化成功: $language');
      notifyListeners();
    } catch (e, stack) {
      log.e('語言初始化失敗', e, stack);
      _setError('語言初始化失敗: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// 切換語言
  Future<bool> changeLanguage(String languageCode) async {
    log.i('切換語言: $languageCode');
    _setLoading(true);
    _clearError();

    try {
      // 檢查語言是否支援
      if (!_repository.isLanguageSupported(languageCode)) {
        _setError('不支援的語言: $languageCode');
        return false;
      }

      // 設定語言
      final success = await _repository.setLanguage(languageCode);
      if (!success) {
        _setError('語言切換失敗');
        return false;
      }

      // 更新狀態
      _currentLanguage = languageCode;
      _currentLocale = await _repository.getCurrentLocale();

      log.i('語言切換成功: $languageCode');
      notifyListeners();
      return true;
    } catch (e, stack) {
      log.e('語言切換失敗', e, stack);
      _setError('語言切換失敗: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 重設為系統語言
  Future<bool> resetToSystemLanguage() async {
    log.i('重設為系統語言');
    _setLoading(true);
    _clearError();

    try {
      final success = await _repository.resetToSystemLanguage();
      if (success) {
        await initializeLanguage();
        log.i('重設為系統語言成功');
      } else {
        _setError('重設為系統語言失敗');
      }
      return success;
    } catch (e, stack) {
      log.e('重設為系統語言失敗', e, stack);
      _setError('重設為系統語言失敗: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 清除語言設定
  Future<bool> clearLanguagePreference() async {
    log.i('清除語言設定');
    _setLoading(true);
    _clearError();

    try {
      final success = await _repository.clearLanguagePreference();
      if (success) {
        await initializeLanguage();
        log.i('清除語言設定成功');
      } else {
        _setError('清除語言設定失敗');
      }
      return success;
    } catch (e, stack) {
      log.e('清除語言設定失敗', e, stack);
      _setError('清除語言設定失敗: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 取得語言資訊
  LanguageInfo? getLanguageInfo(String languageCode) {
    return _repository.getLanguageInfo(languageCode);
  }

  /// 檢查語言是否支援
  bool isLanguageSupported(String languageCode) {
    return _repository.isLanguageSupported(languageCode);
  }

  /// 檢查是否有語言偏好設定
  Future<bool> hasLanguagePreference() async {
    return await _repository.hasLanguagePreference();
  }

  /// 設定載入狀態
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// 設定錯誤訊息
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  /// 清除錯誤訊息
  void _clearError() {
    _error = null;
    notifyListeners();
  }

  /// 清除錯誤訊息（公開方法）
  void clearError() {
    _clearError();
  }

  @override
  void dispose() {
    log.d('LanguageProvider disposed');
    super.dispose();
  }
}
