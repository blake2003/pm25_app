// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import '../../theme/theme_colors.dart';
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'PM2.5 空气质量';

  @override
  String get home => '首页';

  @override
  String get guide => '导览页';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get logIn => '登录';

  @override
  String get logOut => '登出';

  @override
  String get theme => '主题';

  @override
  String get airQuality => '空气质量';

  @override
  String get news => '新闻';

  @override
  String get latestNews => '最新消息';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get english => 'English';

  @override
  String get chineseTraditional => '繁体中文';

  @override
  String get cancel => '取消';

  @override
  String get confirmAction => '确认';

  @override
  String get languageChanged => '语言切换成功';

  @override
  String get advancedSettings => '高级设置';

  @override
  String get resetToSystemLanguage => '重设为系统语言';

  @override
  String get useDeviceDefaultLanguage => '使用设备默认语言';

  @override
  String get clearLanguagePreference => '清除语言偏好设置';

  @override
  String get removeSavedLanguageSetting => '移除已保存的语言设置';

  @override
  String get supportedLanguages => '支持的语言';

  @override
  String get resetToSystemLanguageSuccess => '已成功重设为系统语言';

  @override
  String get languagePreferenceClearedSuccess => '语言偏好设置已成功清除';

  @override
  String get operationFailed => '操作失败';

  @override
  String get confirmClearLanguagePreference => '您确定要清除语言偏好设置吗？';

  @override
  String get pushNotification => '推送通知';

  @override
  String get receiveAirQualityAlert => '接收空气质量提醒';

  @override
  String get notificationSettings => '通知设置';

  @override
  String get customizeNotificationContent => '自定义通知内容';

  @override
  String get version => '版本';

  @override
  String get privacypolicy => '隐私政策';

  @override
  String get viewPrivacyPolicy => '查看隐私保护说明';

  @override
  String get appearanceSettings => '外观设置';

  @override
  String get auto => '自动';

  @override
  String get switchBasedOnTime => '根据时间自动切换';

  @override
  String get light => '浅色';

  @override
  String get useLightTheme => '使用浅色主题';

  @override
  String get dark => '深色';

  @override
  String get useDarkTheme => '使用深色主题';

  @override
  String get autoSwitchTimeSettings => '自动切换时间设置';

  @override
  String get dayStartTime => '白天开始时间';

  @override
  String get lightThemeStartTime => '浅色主题开始时间';

  @override
  String get nightStartTime => '夜晚开始时间';

  @override
  String get darkThemeStartTime => '深色主题开始时间';

  @override
  String get resetToDefault => '重置为预设';

  @override
  String get autoModeDescription =>
      '选择「自动」模式将根据设定的时间自动切换主题。点击自动选项可自定义切换时间（使用24小时制）。您也可以手动选择浅色或深色主题。';

  @override
  String get appVersion => 'PM25 空气质量监测 v1.0.0';

  @override
  String get setDayStartTime => '设置白天开始时间';

  @override
  String get setNightStartTime => '设置夜晚开始时间';

  @override
  String get done => '完成';

  @override
  String get reset => '重置';

  @override
  String get resetSuccess => '重置成功';

  @override
  String get resetSuccessMessage => '时间设置已重置为预设值（07:00 / 19:00）\n使用24小时制格式';

  @override
  String get ok => '确定';

  @override
  String get switchingTheme => '切换主题中...';

  @override
  String get themeSwitchSuccess => '主题切换成功';

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
    return '已切换到$themeMode主题';
  }

  @override
  String get switchFailed => '切换失败';

  @override
  String get switchFailedMessage => '主题切换失败，请稍后再试';

  @override
  String get airQualityTitle => '空气质量';

  @override
  String updatedAt(Object time) {
    return '（$time 更新）';
  }

  @override
  String get addSite => '添加站点';

  @override
  String get deleteSite => '删除站点';

  @override
  String get recentThreeHoursStats => '最近三个小时统计';

  @override
  String get dataCount => '数据笔数';

  @override
  String dataCountUnit(Object count) {
    return '$count 笔';
  }

  @override
  String get averagePM25 => '平均 PM2.5';

  @override
  String get timeRange => '时间范围';

  @override
  String get aqiDataView => 'AQI 数据查看';

  @override
  String get selectTimeRange => '选择时间范围';

  @override
  String get selectTimeRangeMessage => '选择要显示的数据时间范围';

  @override
  String get loadDataFailed => '加载数据失败';

  @override
  String get noData => '暂无数据';

  @override
  String get noDataMessage => '目前没有符合时间范围的 AQI 数据';

  @override
  String totalRecords(Object count) {
    return '共 $count 笔数据';
  }

  @override
  String originalData(Object filtered, Object original) {
    return '原始数据: $original 笔 | 过滤后: $filtered 笔';
  }

  @override
  String get dataFilteredWarning => '部分数据因超过选定时间范围而被过滤';

  @override
  String recordNumber(Object number) {
    return '记录 #$number';
  }

  @override
  String get older => '较旧';

  @override
  String get healthLevel => '健康等级';

  @override
  String get site => '站点';

  @override
  String get county => '县市';

  @override
  String get detectionTime => '检测时间';

  @override
  String get pm25Label => 'PM2.5';

  @override
  String get delete => '删除';

  @override
  String get deleteFailed => '删除失败';

  @override
  String get deleteFailedMessage => '无法删除站点，至少需保留一个站点。';

  @override
  String get selectRegion => '选择地区';

  @override
  String get siteManagement => '站點管理';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => 'PM2.5 空氣品質';

  @override
  String get home => '首頁';

  @override
  String get guide => '導覽頁';

  @override
  String get settings => '設定';

  @override
  String get language => '語言';

  @override
  String get logIn => '登入';

  @override
  String get logOut => '登出';

  @override
  String get theme => '主題';

  @override
  String get airQuality => '空氣品質';

  @override
  String get news => '新聞';

  @override
  String get latestNews => '最新消息';

  @override
  String get selectLanguage => '選擇語言';

  @override
  String get english => 'English';

  @override
  String get chineseTraditional => '繁體中文';

  @override
  String get cancel => '取消';

  @override
  String get confirmAction => '確認';

  @override
  String get languageChanged => '語言切換成功';

  @override
  String get advancedSettings => '進階設定';

  @override
  String get resetToSystemLanguage => '重設為系統語言';

  @override
  String get useDeviceDefaultLanguage => '使用裝置預設語言';

  @override
  String get clearLanguagePreference => '清除語言偏好設定';

  @override
  String get removeSavedLanguageSetting => '移除已儲存的語言設定';

  @override
  String get supportedLanguages => '支援的語言';

  @override
  String get resetToSystemLanguageSuccess => '已成功重設為系統語言';

  @override
  String get languagePreferenceClearedSuccess => '語言偏好設定已成功清除';

  @override
  String get operationFailed => '操作失敗';

  @override
  String get confirmClearLanguagePreference => '您確定要清除語言偏好設定嗎？';

  @override
  String get pushNotification => '推播通知';

  @override
  String get receiveAirQualityAlert => '接收空氣品質提醒';

  @override
  String get notificationSettings => '通知設定';

  @override
  String get customizeNotificationContent => '自訂通知內容';

  @override
  String get version => '版本';

  @override
  String get privacypolicy => '隱私政策';

  @override
  String get viewPrivacyPolicy => '查看隱私保護說明';

  @override
  String get appearanceSettings => '外觀設定';

  @override
  String get auto => '自動';

  @override
  String get switchBasedOnTime => '根據時間自動切換';

  @override
  String get light => '淺色';

  @override
  String get useLightTheme => '使用淺色主題';

  @override
  String get dark => '深色';

  @override
  String get useDarkTheme => '使用深色主題';

  @override
  String get autoSwitchTimeSettings => '自動切換時間設定';

  @override
  String get dayStartTime => '白天開始時間';

  @override
  String get lightThemeStartTime => '淺色主題開始時間';

  @override
  String get nightStartTime => '夜晚開始時間';

  @override
  String get darkThemeStartTime => '深色主題開始時間';

  @override
  String get resetToDefault => '重置為預設';

  @override
  String get autoModeDescription =>
      '選擇「自動」模式將根據設定的時間自動切換主題。點擊自動選項可自訂切換時間（使用24小時制）。您也可以手動選擇淺色或深色主題。';

  @override
  String get appVersion => 'PM25 空氣品質監測 v1.0.0';

  @override
  String get setDayStartTime => '設定白天開始時間';

  @override
  String get setNightStartTime => '設定夜晚開始時間';

  @override
  String get done => '完成';

  @override
  String get reset => '重置';

  @override
  String get resetSuccess => '重置成功';

  @override
  String get resetSuccessMessage => '時間設定已重置為預設值（07:00 / 19:00）\n使用24小時制格式';

  @override
  String get ok => '確定';

  @override
  String get switchingTheme => '切換主題中...';

  @override
  String get themeSwitchSuccess => '主題切換成功';

  @override
  String themeSwitchSuccessMessage(Object themeMode) {
    if (themeMode is AppThemeMode) {
      return '已切換到${AppColors.getThemeModeDescription(themeMode)}主題';
    }
    return '已切換到$themeMode主題';
  }

  @override
  String get switchFailed => '切換失敗';

  @override
  String get switchFailedMessage => '主題切換失敗，請稍後再試';

  @override
  String get airQualityTitle => '空氣品質';

  @override
  String updatedAt(Object time) {
    return '（$time 更新）';
  }

  @override
  String get addSite => '添加站點';

  @override
  String get deleteSite => '刪除站點';

  @override
  String get recentThreeHoursStats => '最近三個小時統計';

  @override
  String get dataCount => '資料筆數';

  @override
  String dataCountUnit(Object count) {
    return '$count 筆';
  }

  @override
  String get averagePM25 => '平均 PM2.5';

  @override
  String get timeRange => '時間範圍';

  @override
  String get aqiDataView => 'AQI 資料檢視';

  @override
  String get selectTimeRange => '選擇時間範圍';

  @override
  String get selectTimeRangeMessage => '選擇要顯示的資料時間範圍';

  @override
  String get loadDataFailed => '載入資料失敗';

  @override
  String get noData => '暫無資料';

  @override
  String get noDataMessage => '目前沒有符合時間範圍的 AQI 資料';

  @override
  String totalRecords(Object count) {
    return '共 $count 筆資料';
  }

  @override
  String originalData(Object filtered, Object original) {
    return '原始資料: $original 筆 | 過濾後: $filtered 筆';
  }

  @override
  String get dataFilteredWarning => '部分資料因超過選定時間範圍而被過濾';

  @override
  String recordNumber(Object number) {
    return '記錄 #$number';
  }

  @override
  String get older => '較舊';

  @override
  String get healthLevel => '健康等級';

  @override
  String get site => '站點';

  @override
  String get county => '縣市';

  @override
  String get detectionTime => '檢測時間';

  @override
  String get pm25Label => 'PM2.5';

  @override
  String get delete => '刪除';

  @override
  String get deleteFailed => '刪除失敗';

  @override
  String get deleteFailedMessage => '無法刪除站點，至少需保留一個站點。';

  @override
  String get selectRegion => '選擇要添加的地區';

  @override
  String get siteManagement => '站點管理';
}
