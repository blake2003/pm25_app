import 'package:flutter/material.dart';
import 'package:pm25_app/core/constants/language/l10n/app_localizations.dart';
import 'package:pm25_app/core/constants/language/language_constants.dart';
import 'package:pm25_app/core/loggers/log.dart';
import 'package:pm25_app/features/settings/language/language_provider.dart';
import 'package:pm25_app/ui/widgets/language_selector.dart';
import 'package:provider/provider.dart';

/// 語言設定頁面
///
/// 提供完整的語言設定功能，包括語言選擇和相關設定
class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  final log = AppLogger('LanguageSettingsScreen');

  @override
  void initState() {
    super.initState();
    log.d('語言設定頁面初始化');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.language ?? 'Language'),
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
                const SimpleLanguageSelector(),
                const SizedBox(height: 16),

                // 進階設定
                _buildAdvancedSettingsCard(languageProvider),
                const SizedBox(height: 16),

                // 語言資訊
                _buildLanguageInfoCard(),
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
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)?.language ?? 'Language',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (currentLanguageInfo != null) ...[
              Text(
                currentLanguageInfo.nativeName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currentLanguageInfo.name,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Locale: ${currentLanguageInfo.locale}',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ] else ...[
              Text(
                languageProvider.currentLanguage,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 建立進階設定卡片
  Widget _buildAdvancedSettingsCard(LanguageProvider languageProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)?.advancedSettings ??
                      'Advanced Settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 重設為系統語言
            ListTile(
              leading: const Icon(Icons.refresh),
              title: Text(AppLocalizations.of(context)?.resetToSystemLanguage ??
                  'Reset to System Language'),
              subtitle: Text(
                  AppLocalizations.of(context)?.useDeviceDefaultLanguage ??
                      'Use device default language'),
              onTap: languageProvider.isLoading
                  ? null
                  : () => _resetToSystemLanguage(languageProvider),
            ),

            const Divider(),

            // 清除語言設定
            ListTile(
              leading: const Icon(Icons.clear),
              title: Text(
                  AppLocalizations.of(context)?.clearLanguagePreference ??
                      'Clear Language Preference'),
              subtitle: Text(
                  AppLocalizations.of(context)?.removeSavedLanguageSetting ??
                      'Remove saved language setting'),
              onTap: languageProvider.isLoading
                  ? null
                  : () => _clearLanguagePreference(languageProvider),
            ),
          ],
        ),
      ),
    );
  }

  /// 建立語言資訊卡片
  Widget _buildLanguageInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.language,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)?.supportedLanguages ??
                      'Supported Languages',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
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
            }),
          ],
        ),
      ),
    );
  }

  /// 重設為系統語言
  Future<void> _resetToSystemLanguage(LanguageProvider languageProvider) async {
    log.i('重設為系統語言');

    final success = await languageProvider.resetToSystemLanguage();

    if (mounted) {
      if (success) {
        _showSuccessMessage(
            AppLocalizations.of(context)?.resetToSystemLanguageSuccess ??
                'Reset to system language successfully');
      } else {
        _showErrorMessage(languageProvider.error);
      }
    }
  }

  /// 清除語言設定
  Future<void> _clearLanguagePreference(
      LanguageProvider languageProvider) async {
    log.i('清除語言設定');

    // 顯示確認對話框
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.confirmAction ?? 'Confirm'),
        content: Text(
            AppLocalizations.of(context)?.confirmClearLanguagePreference ??
                'Are you sure you want to clear the language preference?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child:
                Text(AppLocalizations.of(context)?.confirmAction ?? 'Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await languageProvider.clearLanguagePreference();

      if (mounted) {
        if (success) {
          _showSuccessMessage(
              AppLocalizations.of(context)?.languagePreferenceClearedSuccess ??
                  'Language preference cleared successfully');
        } else {
          _showErrorMessage(languageProvider.error);
        }
      }
    }
  }

  /// 顯示成功訊息
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// 顯示錯誤訊息
  void _showErrorMessage(String? error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ??
            AppLocalizations.of(context)?.operationFailed ??
            'Operation failed'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
