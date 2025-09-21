import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/language/l10n/app_localizations.dart';
import '../../core/constants/language/language_constants.dart';
import '../../core/loggers/log.dart';
import '../../features/settings/language/language_provider.dart';

/// 語言選擇器組件
///
/// 提供語言切換的 UI 介面，支援 iOS 風格設計
class LanguageSelector extends StatelessWidget {
  final log = AppLogger('LanguageSelector');

  LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return ListTile(
          leading: const Icon(Icons.language),
          title: Text(
            AppLocalizations.of(context)?.language ?? 'Language',
            style: const TextStyle(fontSize: 16),
          ),
          subtitle: Text(
            _getCurrentLanguageName(languageProvider.currentLanguage),
            style: const TextStyle(fontSize: 14),
          ),
          trailing: languageProvider.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: languageProvider.isLoading
              ? null
              : () => _showLanguageDialog(context, languageProvider),
        );
      },
    );
  }

  /// 顯示語言選擇對話框
  void _showLanguageDialog(
      BuildContext context, LanguageProvider languageProvider) {
    log.d('顯示語言選擇對話框');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)?.selectLanguage ??
              'Select Language'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: languageProvider.supportedLanguages.length,
              itemBuilder: (context, index) {
                final language = languageProvider.supportedLanguages[index];
                final isSelected =
                    language.code == languageProvider.currentLanguage;

                return ListTile(
                  title: Text(
                    language.nativeName,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(language.name),
                  leading: Radio<String>(
                    value: language.code,
                    groupValue: languageProvider.currentLanguage,
                    onChanged: languageProvider.isLoading
                        ? null
                        : (String? value) {
                            if (value != null) {
                              _changeLanguage(context, languageProvider, value);
                            }
                          },
                  ),
                  onTap: languageProvider.isLoading
                      ? null
                      : () => _changeLanguage(
                          context, languageProvider, language.code),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
            ),
          ],
        );
      },
    );
  }

  /// 切換語言
  Future<void> _changeLanguage(
    BuildContext context,
    LanguageProvider languageProvider,
    String languageCode,
  ) async {
    log.i('切換語言: $languageCode');

    final success = await languageProvider.changeLanguage(languageCode);

    if (context.mounted) {
      if (success) {
        Navigator.of(context).pop();
        _showSuccessMessage(context);
      } else {
        _showErrorMessage(context, languageProvider.error);
      }
    }
  }

  /// 顯示成功訊息
  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)?.languageChanged ??
            'Language changed successfully'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// 顯示錯誤訊息
  void _showErrorMessage(BuildContext context, String? error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'Language change failed'),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// 取得當前語言名稱
  String _getCurrentLanguageName(String languageCode) {
    final languageInfo = LanguageConstants.getLanguageInfo(languageCode);
    return languageInfo?.nativeName ?? languageCode;
  }
}

/// 簡化版語言選擇器（用於設定頁面）
class SimpleLanguageSelector extends StatelessWidget {
  const SimpleLanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)?.language ?? 'Language',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...languageProvider.supportedLanguages.map((language) {
                  return RadioListTile<String>(
                    title: Text(language.nativeName),
                    subtitle: Text(language.name),
                    value: language.code,
                    groupValue: languageProvider.currentLanguage,
                    onChanged: languageProvider.isLoading
                        ? null
                        : (String? value) {
                            if (value != null) {
                              languageProvider.changeLanguage(value);
                            }
                          },
                    activeColor: Theme.of(context).primaryColor,
                  );
                }).toList(),
                if (languageProvider.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (languageProvider.error != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      languageProvider.error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
