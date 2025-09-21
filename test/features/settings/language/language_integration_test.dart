import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pm25_app/core/constants/language/l10n/app_localizations.dart';
import 'package:pm25_app/features/settings/language/language_provider.dart';
import 'package:pm25_app/ui/widgets/language_selector.dart';
import 'package:provider/provider.dart';

void main() {
  group('Language Integration Tests', () {
    testWidgets('LanguageSelector should display translated text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChangeNotifierProvider(
            create: (_) => LanguageProvider(),
            child: Scaffold(
              body: LanguageSelector(),
            ),
          ),
        ),
      );

      // 等待語言初始化
      await tester.pumpAndSettle();

      // 檢查是否顯示語言相關文字
      expect(find.text('Language'), findsOneWidget);
    });

    testWidgets('Language switching should update UI text',
        (WidgetTester tester) async {
      final languageProvider = LanguageProvider();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChangeNotifierProvider(
            create: (_) => languageProvider,
            child: Scaffold(
              body: LanguageSelector(),
            ),
          ),
        ),
      );

      // 等待語言初始化
      await tester.pumpAndSettle();

      // 檢查初始語言
      expect(languageProvider.currentLanguage, 'zh_TW');

      // 切換到英文
      await languageProvider.changeLanguage('en');
      await tester.pumpAndSettle();

      // 檢查語言是否已切換
      expect(languageProvider.currentLanguage, 'en');
    });

    testWidgets(
        'LanguageProvider should initialize with correct default language',
        (WidgetTester tester) async {
      final languageProvider = LanguageProvider();

      // 初始化語言提供者
      await languageProvider.initializeLanguage();

      // 檢查預設語言
      expect(languageProvider.currentLanguage, 'zh_TW');
      expect(languageProvider.isLoading, false);
      expect(languageProvider.error, null);
    });

    testWidgets('LanguageProvider should support language switching',
        (WidgetTester tester) async {
      final languageProvider = LanguageProvider();

      // 初始化
      await languageProvider.initializeLanguage();

      // 切換到英文
      final success = await languageProvider.changeLanguage('en');

      expect(success, true);
      expect(languageProvider.currentLanguage, 'en');
    });

    testWidgets('LanguageProvider should reject unsupported languages',
        (WidgetTester tester) async {
      final languageProvider = LanguageProvider();

      // 初始化
      await languageProvider.initializeLanguage();

      // 嘗試切換到不支援的語言
      final success = await languageProvider.changeLanguage('unsupported');

      expect(success, false);
      expect(languageProvider.error, isNotNull);
    });
  });
}
