import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'PM2.5 Air Quality'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @guide.
  ///
  /// In en, this message translates to:
  /// **'Guide Page'**
  String get guide;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @airQuality.
  ///
  /// In en, this message translates to:
  /// **'Air Quality'**
  String get airQuality;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @latestNews.
  ///
  /// In en, this message translates to:
  /// **'Latest News'**
  String get latestNews;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @chineseTraditional.
  ///
  /// In en, this message translates to:
  /// **'Traditional Chinese'**
  String get chineseTraditional;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirmAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmAction;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

  /// No description provided for @advancedSettings.
  ///
  /// In en, this message translates to:
  /// **'Advanced Settings'**
  String get advancedSettings;

  /// No description provided for @resetToSystemLanguage.
  ///
  /// In en, this message translates to:
  /// **'Reset to System Language'**
  String get resetToSystemLanguage;

  /// No description provided for @useDeviceDefaultLanguage.
  ///
  /// In en, this message translates to:
  /// **'Use device default language'**
  String get useDeviceDefaultLanguage;

  /// No description provided for @clearLanguagePreference.
  ///
  /// In en, this message translates to:
  /// **'Clear Language Preference'**
  String get clearLanguagePreference;

  /// No description provided for @removeSavedLanguageSetting.
  ///
  /// In en, this message translates to:
  /// **'Remove saved language setting'**
  String get removeSavedLanguageSetting;

  /// No description provided for @supportedLanguages.
  ///
  /// In en, this message translates to:
  /// **'Supported Languages'**
  String get supportedLanguages;

  /// No description provided for @resetToSystemLanguageSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reset to system language successfully'**
  String get resetToSystemLanguageSuccess;

  /// No description provided for @languagePreferenceClearedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Language preference cleared successfully'**
  String get languagePreferenceClearedSuccess;

  /// No description provided for @operationFailed.
  ///
  /// In en, this message translates to:
  /// **'Operation failed'**
  String get operationFailed;

  /// No description provided for @confirmClearLanguagePreference.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear the language preference?'**
  String get confirmClearLanguagePreference;

  /// No description provided for @pushNotification.
  ///
  /// In en, this message translates to:
  /// **'Push Notification'**
  String get pushNotification;

  /// No description provided for @receiveAirQualityAlert.
  ///
  /// In en, this message translates to:
  /// **'Air Quality alerts'**
  String get receiveAirQualityAlert;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @customizeNotificationContent.
  ///
  /// In en, this message translates to:
  /// **'Customize notification content'**
  String get customizeNotificationContent;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @privacypolicy.
  ///
  /// In en, this message translates to:
  /// **'PrivacyPolicy'**
  String get privacypolicy;

  /// No description provided for @viewPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'View privacy policy explanation'**
  String get viewPrivacyPolicy;

  /// No description provided for @appearanceSettings.
  ///
  /// In en, this message translates to:
  /// **'Appearance Settings'**
  String get appearanceSettings;

  /// No description provided for @auto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

  /// No description provided for @switchBasedOnTime.
  ///
  /// In en, this message translates to:
  /// **'Switch based on time'**
  String get switchBasedOnTime;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @useLightTheme.
  ///
  /// In en, this message translates to:
  /// **'Use light theme'**
  String get useLightTheme;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @useDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'Use dark theme'**
  String get useDarkTheme;

  /// No description provided for @autoSwitchTimeSettings.
  ///
  /// In en, this message translates to:
  /// **'Auto Switch Time Settings'**
  String get autoSwitchTimeSettings;

  /// No description provided for @dayStartTime.
  ///
  /// In en, this message translates to:
  /// **'Day Start Time'**
  String get dayStartTime;

  /// No description provided for @lightThemeStartTime.
  ///
  /// In en, this message translates to:
  /// **'Light theme start time'**
  String get lightThemeStartTime;

  /// No description provided for @nightStartTime.
  ///
  /// In en, this message translates to:
  /// **'Night Start Time'**
  String get nightStartTime;

  /// No description provided for @darkThemeStartTime.
  ///
  /// In en, this message translates to:
  /// **'Dark theme start time'**
  String get darkThemeStartTime;

  /// No description provided for @resetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get resetToDefault;

  /// No description provided for @autoModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Select \"Auto\" mode to automatically switch themes based on set times. Tap the auto option to customize switch times (using 24-hour format). You can also manually select light or dark theme.'**
  String get autoModeDescription;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'PM25 Air Quality Monitor v1.0.0'**
  String get appVersion;

  /// No description provided for @setDayStartTime.
  ///
  /// In en, this message translates to:
  /// **'Set Day Start Time'**
  String get setDayStartTime;

  /// No description provided for @setNightStartTime.
  ///
  /// In en, this message translates to:
  /// **'Set Night Start Time'**
  String get setNightStartTime;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reset Successful'**
  String get resetSuccess;

  /// No description provided for @resetSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Time settings have been reset to default values (07:00 / 19:00)\nUsing 24-hour format'**
  String get resetSuccessMessage;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @switchingTheme.
  ///
  /// In en, this message translates to:
  /// **'Switching theme...'**
  String get switchingTheme;

  /// No description provided for @themeSwitchSuccess.
  ///
  /// In en, this message translates to:
  /// **'Theme Switch Successful'**
  String get themeSwitchSuccess;

  /// No description provided for @themeSwitchSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Switched to {themeMode} theme'**
  String themeSwitchSuccessMessage(Object themeMode);

  /// No description provided for @switchFailed.
  ///
  /// In en, this message translates to:
  /// **'Switch Failed'**
  String get switchFailed;

  /// No description provided for @switchFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Theme switch failed, please try again later'**
  String get switchFailedMessage;

  /// No description provided for @airQualityTitle.
  ///
  /// In en, this message translates to:
  /// **'Air Quality'**
  String get airQualityTitle;

  /// No description provided for @updatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated at {time}'**
  String updatedAt(Object time);

  /// No description provided for @addSite.
  ///
  /// In en, this message translates to:
  /// **'Add Site'**
  String get addSite;

  /// No description provided for @deleteSite.
  ///
  /// In en, this message translates to:
  /// **'Delete Site'**
  String get deleteSite;

  /// No description provided for @recentThreeHoursStats.
  ///
  /// In en, this message translates to:
  /// **'Recent Three Hours Statistics'**
  String get recentThreeHoursStats;

  /// No description provided for @dataCount.
  ///
  /// In en, this message translates to:
  /// **'Data Count'**
  String get dataCount;

  /// No description provided for @dataCountUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} records'**
  String dataCountUnit(Object count);

  /// No description provided for @averagePM25.
  ///
  /// In en, this message translates to:
  /// **'Average PM2.5'**
  String get averagePM25;

  /// No description provided for @timeRange.
  ///
  /// In en, this message translates to:
  /// **'Time Range'**
  String get timeRange;

  /// No description provided for @aqiDataView.
  ///
  /// In en, this message translates to:
  /// **'AQI Data View'**
  String get aqiDataView;

  /// No description provided for @selectTimeRange.
  ///
  /// In en, this message translates to:
  /// **'Select Time Range'**
  String get selectTimeRange;

  /// No description provided for @selectTimeRangeMessage.
  ///
  /// In en, this message translates to:
  /// **'Select the time range for data display'**
  String get selectTimeRangeMessage;

  /// No description provided for @loadDataFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data'**
  String get loadDataFailed;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// No description provided for @noDataMessage.
  ///
  /// In en, this message translates to:
  /// **'No AQI data available for the selected time range'**
  String get noDataMessage;

  /// No description provided for @totalRecords.
  ///
  /// In en, this message translates to:
  /// **'Total {count} records'**
  String totalRecords(Object count);

  /// No description provided for @originalData.
  ///
  /// In en, this message translates to:
  /// **'Original data: {original} records | Filtered: {filtered} records'**
  String originalData(Object filtered, Object original);

  /// No description provided for @dataFilteredWarning.
  ///
  /// In en, this message translates to:
  /// **'Some data has been filtered due to exceeding the selected time range'**
  String get dataFilteredWarning;

  /// No description provided for @recordNumber.
  ///
  /// In en, this message translates to:
  /// **'Record #{number}'**
  String recordNumber(Object number);

  /// No description provided for @older.
  ///
  /// In en, this message translates to:
  /// **'Older'**
  String get older;

  /// No description provided for @healthLevel.
  ///
  /// In en, this message translates to:
  /// **'Health Level'**
  String get healthLevel;

  /// No description provided for @site.
  ///
  /// In en, this message translates to:
  /// **'Site'**
  String get site;

  /// No description provided for @county.
  ///
  /// In en, this message translates to:
  /// **'County'**
  String get county;

  /// No description provided for @detectionTime.
  ///
  /// In en, this message translates to:
  /// **'Detection Time'**
  String get detectionTime;

  /// No description provided for @pm25Label.
  ///
  /// In en, this message translates to:
  /// **'PM2.5'**
  String get pm25Label;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Delete Failed'**
  String get deleteFailed;

  /// No description provided for @deleteFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete site, at least one site must remain.'**
  String get deleteFailedMessage;

  /// No description provided for @selectRegion.
  ///
  /// In en, this message translates to:
  /// **'Select Region'**
  String get selectRegion;

  /// No description provided for @siteManagement.
  ///
  /// In en, this message translates to:
  /// **'Site Management'**
  String get siteManagement;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
