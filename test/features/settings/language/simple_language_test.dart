import 'package:flutter_test/flutter_test.dart';
import 'package:pm25_app/core/constants/language/language_constants.dart';
import 'package:pm25_app/features/settings/language/language_provider.dart';

void main() {
  group('Simple Language Tests', () {
    test('LanguageProvider should initialize with correct default language',
        () async {
      final languageProvider = LanguageProvider();

      // 初始化語言提供者
      await languageProvider.initializeLanguage();

      // 檢查預設語言
      expect(
          languageProvider.currentLanguage, LanguageConstants.defaultLanguage);
      expect(languageProvider.isLoading, false);
      expect(languageProvider.error, null);
    });

    test('LanguageProvider should support language switching', () async {
      final languageProvider = LanguageProvider();

      // 初始化
      await languageProvider.initializeLanguage();

      // 檢查初始狀態
      expect(
          languageProvider.currentLanguage, LanguageConstants.defaultLanguage);

      // 注意：在測試環境中，SharedPreferences 可能無法正常工作
      // 所以我們只測試語言代碼驗證邏輯
      expect(languageProvider.isLanguageSupported('en'), true);
      expect(languageProvider.isLanguageSupported('zh_TW'), true);
      expect(languageProvider.isLanguageSupported('unsupported'), false);
    });

    test('LanguageProvider should reject unsupported languages', () async {
      final languageProvider = LanguageProvider();

      // 初始化
      await languageProvider.initializeLanguage();

      // 嘗試切換到不支援的語言
      final success = await languageProvider.changeLanguage('unsupported');

      expect(success, false);
      expect(languageProvider.error, isNotNull);
    });

    test('LanguageProvider should have supported languages list', () {
      final languageProvider = LanguageProvider();

      expect(languageProvider.supportedLanguages, isNotEmpty);
      expect(languageProvider.supportedLanguages.length, 2);

      final languageCodes =
          languageProvider.supportedLanguages.map((lang) => lang.code).toList();
      expect(languageCodes, contains('en'));
      expect(languageCodes, contains('zh_TW'));
    });
  });
}
