import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pm25_app/core/constants/language/l10n/app_localizations.dart';
import 'package:pm25_app/core/constants/language/language_constants.dart';
import 'package:pm25_app/features/settings/language/language_provider.dart';
import 'package:provider/provider.dart';

/// 語言切換除錯應用程式
///
/// 用於詳細測試和除錯語言切換功能
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider()..initializeLanguage(),
      child: const LanguageDebugApp(),
    ),
  );
}

class LanguageDebugApp extends StatelessWidget {
  const LanguageDebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          title: 'Language Debug',
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
          home: const LanguageDebugScreen(),
        );
      },
    );
  }
}

class LanguageDebugScreen extends StatefulWidget {
  const LanguageDebugScreen({super.key});

  @override
  State<LanguageDebugScreen> createState() => _LanguageDebugScreenState();
}

class _LanguageDebugScreenState extends State<LanguageDebugScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Language Debug - ${languageProvider.currentLanguage}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 當前狀態資訊
            _buildStatusSection(languageProvider, localizations),

            const SizedBox(height: 20),

            // 語言切換按鈕
            _buildLanguageButtons(languageProvider),

            const SizedBox(height: 20),

            // 翻譯測試
            _buildTranslationTest(localizations),

            const SizedBox(height: 20),

            // 語言常數測試
            _buildLanguageConstantsTest(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection(
      LanguageProvider languageProvider, AppLocalizations? localizations) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Language Code: ${languageProvider.currentLanguage}'),
            Text('Locale: ${languageProvider.currentLocale}'),
            Text(
                'Language Code: ${languageProvider.currentLocale.languageCode}'),
            Text(
                'Country Code: ${languageProvider.currentLocale.countryCode ?? 'null'}'),
            Text('AppLocalizations Type: ${localizations.runtimeType}'),
            Text('App Title: ${localizations?.appTitle ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButtons(LanguageProvider languageProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Language Switching',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => _changeLanguage('en'),
                  child: const Text('English (en)'),
                ),
                ElevatedButton(
                  onPressed: () => _changeLanguage('zh'),
                  child: const Text('简体中文 (zh)'),
                ),
                ElevatedButton(
                  onPressed: () => _changeLanguage('zh_TW'),
                  child: const Text('繁體中文 (zh_TW)'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationTest(AppLocalizations? localizations) {
    final translations = [
      'appTitle',
      'home',
      'settings',
      'language',
      'theme',
      'airQuality',
      'news',
      'selectLanguage',
      'advancedSettings',
      'resetToSystemLanguage',
      'clearLanguagePreference',
      'supportedLanguages',
      'cancel',
      'confirmAction',
      'languageChanged',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Translation Test',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...translations.map((key) {
              String value = 'N/A';
              switch (key) {
                case 'appTitle':
                  value = localizations?.appTitle ?? 'N/A';
                  break;
                case 'home':
                  value = localizations?.home ?? 'N/A';
                  break;
                case 'settings':
                  value = localizations?.settings ?? 'N/A';
                  break;
                case 'language':
                  value = localizations?.language ?? 'N/A';
                  break;
                case 'theme':
                  value = localizations?.theme ?? 'N/A';
                  break;
                case 'airQuality':
                  value = localizations?.airQuality ?? 'N/A';
                  break;
                case 'news':
                  value = localizations?.news ?? 'N/A';
                  break;
                case 'selectLanguage':
                  value = localizations?.selectLanguage ?? 'N/A';
                  break;
                case 'advancedSettings':
                  value = localizations?.advancedSettings ?? 'N/A';
                  break;
                case 'resetToSystemLanguage':
                  value = localizations?.resetToSystemLanguage ?? 'N/A';
                  break;
                case 'clearLanguagePreference':
                  value = localizations?.clearLanguagePreference ?? 'N/A';
                  break;
                case 'supportedLanguages':
                  value = localizations?.supportedLanguages ?? 'N/A';
                  break;
                case 'cancel':
                  value = localizations?.cancel ?? 'N/A';
                  break;
                case 'confirmAction':
                  value = localizations?.confirmAction ?? 'N/A';
                  break;
                case 'languageChanged':
                  value = localizations?.languageChanged ?? 'N/A';
                  break;
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('$key: $value'),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageConstantsTest() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Language Constants Test',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...LanguageConstants.supportedLanguages.map((lang) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '${lang.code}: ${lang.name} (${lang.nativeName}) - Locale: ${lang.locale}',
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _changeLanguage(String languageCode) async {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final success = await languageProvider.changeLanguage(languageCode);

    if (mounted) {
      setState(() {}); // 觸發重建以顯示新狀態

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Language changed to $languageCode'
              : 'Failed to change language to $languageCode'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }
}
