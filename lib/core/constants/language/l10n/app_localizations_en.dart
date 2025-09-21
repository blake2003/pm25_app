// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import '../../theme/theme_colors.dart';
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PM2.5 Air Quality';

  @override
  String get home => 'Home';

  @override
  String get guide => 'Guide Page';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get logIn => 'Log In';

  @override
  String get logOut => 'Log Out';

  @override
  String get theme => 'Theme';

  @override
  String get airQuality => 'Air Quality';

  @override
  String get news => 'News';

  @override
  String get latestNews => 'Latest News';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get chineseTraditional => 'Traditional Chinese';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmAction => 'Confirm';

  @override
  String get languageChanged => 'Language changed successfully';

  @override
  String get advancedSettings => 'Advanced Settings';

  @override
  String get resetToSystemLanguage => 'Reset to System Language';

  @override
  String get useDeviceDefaultLanguage => 'Use device default language';

  @override
  String get clearLanguagePreference => 'Clear Language Preference';

  @override
  String get removeSavedLanguageSetting => 'Remove saved language setting';

  @override
  String get supportedLanguages => 'Supported Languages';

  @override
  String get resetToSystemLanguageSuccess =>
      'Reset to system language successfully';

  @override
  String get languagePreferenceClearedSuccess =>
      'Language preference cleared successfully';

  @override
  String get operationFailed => 'Operation failed';

  @override
  String get confirmClearLanguagePreference =>
      'Are you sure you want to clear the language preference?';

  @override
  String get pushNotification => 'Push Notification';

  @override
  String get receiveAirQualityAlert => 'Air Quality alerts';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get customizeNotificationContent => 'Customize notification content';

  @override
  String get version => 'Version';

  @override
  String get privacypolicy => 'PrivacyPolicy';

  @override
  String get viewPrivacyPolicy => 'View privacy policy explanation';

  @override
  String get appearanceSettings => 'Appearance Settings';

  @override
  String get auto => 'Auto';

  @override
  String get switchBasedOnTime => 'Switch based on time';

  @override
  String get light => 'Light';

  @override
  String get useLightTheme => 'Use light theme';

  @override
  String get dark => 'Dark';

  @override
  String get useDarkTheme => 'Use dark theme';

  @override
  String get autoSwitchTimeSettings => 'Auto Switch Time Settings';

  @override
  String get dayStartTime => 'Day Start Time';

  @override
  String get lightThemeStartTime => 'Light theme start time';

  @override
  String get nightStartTime => 'Night Start Time';

  @override
  String get darkThemeStartTime => 'Dark theme start time';

  @override
  String get resetToDefault => 'Reset to Default';

  @override
  String get autoModeDescription =>
      'Select \"Auto\" mode to automatically switch themes based on set times. Tap the auto option to customize switch times (using 24-hour format). You can also manually select light or dark theme.';

  @override
  String get appVersion => 'PM25 Air Quality Monitor v1.0.0';

  @override
  String get setDayStartTime => 'Set Day Start Time';

  @override
  String get setNightStartTime => 'Set Night Start Time';

  @override
  String get done => 'Done';

  @override
  String get reset => 'Reset';

  @override
  String get resetSuccess => 'Reset Successful';

  @override
  String get resetSuccessMessage =>
      'Time settings have been reset to default values (07:00 / 19:00)\nUsing 24-hour format';

  @override
  String get ok => 'OK';

  @override
  String get switchingTheme => 'Switching theme...';

  @override
  String get themeSwitchSuccess => 'Theme Switch Successful';

  @override
  String themeSwitchSuccessMessage(Object themeMode) {
    if (themeMode is AppThemeMode) {
      // 使用本地化的主題模式描述
      String localizedThemeMode;
      switch (themeMode) {
        case AppThemeMode.light:
          localizedThemeMode = light;
          break;
        case AppThemeMode.dark:
          localizedThemeMode = dark;
          break;
        case AppThemeMode.auto:
          localizedThemeMode = auto;
          break;
      }
      return 'Switched to $localizedThemeMode theme';
    }
    return 'Switched to $themeMode theme';
  }

  @override
  String get switchFailed => 'Switch Failed';

  @override
  String get switchFailedMessage =>
      'Theme switch failed, please try again later';

  @override
  String get airQualityTitle => 'Air Quality';

  @override
  String updatedAt(Object time) {
    return 'Updated at $time';
  }

  @override
  String get addSite => 'Add Site';

  @override
  String get deleteSite => 'Delete Site';

  @override
  String get recentThreeHoursStats => 'Recent Three Hours Statistics';

  @override
  String get dataCount => 'Data Count';

  @override
  String dataCountUnit(Object count) {
    return '$count records';
  }

  @override
  String get averagePM25 => 'Average PM2.5';

  @override
  String get timeRange => 'Time Range';

  @override
  String get aqiDataView => 'AQI Data View';

  @override
  String get selectTimeRange => 'Select Time Range';

  @override
  String get selectTimeRangeMessage => 'Select the time range for data display';

  @override
  String get loadDataFailed => 'Failed to load data';

  @override
  String get noData => 'No Data';

  @override
  String get noDataMessage =>
      'No AQI data available for the selected time range';

  @override
  String totalRecords(Object count) {
    return 'Total $count records';
  }

  @override
  String originalData(Object filtered, Object original) {
    return 'Original data: $original records | Filtered: $filtered records';
  }

  @override
  String get dataFilteredWarning =>
      'Some data has been filtered due to exceeding the selected time range';

  @override
  String recordNumber(Object number) {
    return 'Record #$number';
  }

  @override
  String get older => 'Older';

  @override
  String get healthLevel => 'Health Level';

  @override
  String get site => 'Site';

  @override
  String get county => 'County';

  @override
  String get detectionTime => 'Detection Time';

  @override
  String get pm25Label => 'PM2.5';

  @override
  String get delete => 'Delete';

  @override
  String get deleteFailed => 'Delete Failed';

  @override
  String get deleteFailedMessage =>
      'Cannot delete site, at least one site must remain.';

  @override
  String get selectRegion => 'Select Region';

  @override
  String get siteManagement => 'Site Management';
}
