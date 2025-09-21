import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pm25_app/core/constants/language/l10n/app_localizations.dart';
import 'package:pm25_app/features/settings/language/language_provider.dart';
import 'package:provider/provider.dart';

/// 語言切換測試應用程式
///
/// 用於測試語言切換功能是否正常工作
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider()..initializeLanguage(),
      child: const LanguageTestApp(),
    ),
  );
}

class LanguageTestApp extends StatelessWidget {
  const LanguageTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          title: 'Language Test',
          locale: languageProvider.currentLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('zh'),
            Locale('zh', 'TW'),
          ],
          home: const LanguageTestScreen(),
        );
      },
    );
  }
}

class LanguageTestScreen extends StatelessWidget {
  const LanguageTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.appTitle ?? 'PM2.5 Air Quality'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Language: ${languageProvider.currentLanguage}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 測試各種翻譯文字
            _buildTestSection('Basic Navigation', [
              'appTitle: ${localizations?.appTitle ?? 'N/A'}',
              'home: ${localizations?.home ?? 'N/A'}',
              'settings: ${localizations?.settings ?? 'N/A'}',
              'language: ${localizations?.language ?? 'N/A'}',
              'theme: ${localizations?.theme ?? 'N/A'}',
              'airQuality: ${localizations?.airQuality ?? 'N/A'}',
              'news: ${localizations?.news ?? 'N/A'}',
            ]),

            const SizedBox(height: 20),

            _buildTestSection('Language Settings', [
              'selectLanguage: ${localizations?.selectLanguage ?? 'N/A'}',
              'advancedSettings: ${localizations?.advancedSettings ?? 'N/A'}',
              'resetToSystemLanguage: ${localizations?.resetToSystemLanguage ?? 'N/A'}',
              'clearLanguagePreference: ${localizations?.clearLanguagePreference ?? 'N/A'}',
              'supportedLanguages: ${localizations?.supportedLanguages ?? 'N/A'}',
            ]),

            const SizedBox(height: 20),

            _buildTestSection('Actions', [
              'cancel: ${localizations?.cancel ?? 'N/A'}',
              'confirmAction: ${localizations?.confirmAction ?? 'N/A'}',
              'languageChanged: ${localizations?.languageChanged ?? 'N/A'}',
            ]),

            const SizedBox(height: 30),

            // 語言切換按鈕
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _changeLanguage(context, 'en'),
                  child: const Text('English'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _changeLanguage(context, 'zh'),
                  child: const Text('简体中文'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _changeLanguage(context, 'zh_TW'),
                  child: const Text('繁體中文'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Text(item, style: const TextStyle(fontSize: 14)),
            )),
      ],
    );
  }

  Future<void> _changeLanguage(
      BuildContext context, String languageCode) async {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final success = await languageProvider.changeLanguage(languageCode);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Language changed to $languageCode'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to change language to $languageCode'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
