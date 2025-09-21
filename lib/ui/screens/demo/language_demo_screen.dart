import 'package:flutter/material.dart';
import 'package:pm25_app/core/constants/language/language_constants.dart';
import 'package:pm25_app/features/settings/language/language_provider.dart';
import 'package:pm25_app/ui/widgets/language_selector.dart';
import 'package:provider/provider.dart';

/// 語言功能示範頁面
///
/// 展示多語言切換功能的完整實現
class LanguageDemoScreen extends StatelessWidget {
  const LanguageDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 當前語言資訊
                _buildCurrentLanguageCard(languageProvider),
                const SizedBox(height: 16),

                // 語言選擇器
                LanguageSelector(),
                const SizedBox(height: 16),

                // 簡化版語言選擇器
                SimpleLanguageSelector(),
                const SizedBox(height: 16),

                // 測試按鈕
                _buildTestButtons(context, languageProvider),
                const SizedBox(height: 16),

                // 支援的語言清單
                _buildSupportedLanguagesCard(context),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 建立當前語言資訊卡片
  Widget _buildCurrentLanguageCard(LanguageProvider languageProvider) {
    final currentLanguageInfo = LanguageConstants.getLanguageInfo(
      languageProvider.currentLanguage,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Language Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (currentLanguageInfo != null) ...[
              Text('Native Name: ${currentLanguageInfo.nativeName}'),
              Text('English Name: ${currentLanguageInfo.name}'),
              Text('Locale: ${currentLanguageInfo.locale}'),
              Text('Code: ${currentLanguageInfo.code}'),
            ] else ...[
              Text('Language Code: ${languageProvider.currentLanguage}'),
            ],
            const SizedBox(height: 8),
            Text('Loading: ${languageProvider.isLoading}'),
            if (languageProvider.error != null) ...[
              Text(
                'Error: ${languageProvider.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 建立測試按鈕
  Widget _buildTestButtons(
      BuildContext context, LanguageProvider languageProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Test Buttons',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: languageProvider.isLoading
                      ? null
                      : () => languageProvider.changeLanguage('en'),
                  child: const Text('Switch to English'),
                ),
                ElevatedButton(
                  onPressed: languageProvider.isLoading
                      ? null
                      : () => languageProvider.changeLanguage('zh_TW'),
                  child: const Text('Switch to 繁體中文'),
                ),
                ElevatedButton(
                  onPressed: languageProvider.isLoading
                      ? null
                      : () => languageProvider.resetToSystemLanguage(),
                  child: const Text('Reset to System'),
                ),
                ElevatedButton(
                  onPressed: languageProvider.isLoading
                      ? null
                      : () => languageProvider.clearLanguagePreference(),
                  child: const Text('Clear Preference'),
                ),
                if (languageProvider.error != null)
                  ElevatedButton(
                    onPressed: () => languageProvider.clearError(),
                    child: const Text('Clear Error'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 建立支援的語言清單卡片
  Widget _buildSupportedLanguagesCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Supported Languages',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...LanguageConstants.supportedLanguages.map((language) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Text(
                      language.nativeName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${language.name})',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      language.locale,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
