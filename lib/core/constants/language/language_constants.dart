/// 語言常數定義
///
/// 定義應用程式支援的語言清單和相關常數
class LanguageConstants {
  // 支援的語言清單
  static const List<LanguageInfo> supportedLanguages = [
    LanguageInfo(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      locale: 'en',
    ),
    LanguageInfo(
      code: 'zh',
      name: 'Chinese Simplified',
      nativeName: '简体中文',
      locale: 'zh',
    ),
    LanguageInfo(
      code: 'zh_TW',
      name: 'Chinese Traditional',
      nativeName: '繁體中文',
      locale: 'zh_TW',
    ),
  ];

  // 預設語言
  static const String defaultLanguage = 'zh_TW';

  // 語言代碼常數
  static const String languageEn = 'en';
  static const String languageZh = 'zh';
  static const String languageZhTW = 'zh_TW';

  // SharedPreferences 鍵值
  static const String languagePreferenceKey = 'selected_language';

  // 系統語言偵測
  static String getSystemLanguage() {
    // 這裡可以加入系統語言偵測邏輯
    // 目前返回預設語言
    return defaultLanguage;
  }

  // 根據語言代碼取得語言資訊
  static LanguageInfo? getLanguageInfo(String languageCode) {
    try {
      return supportedLanguages.firstWhere(
        (language) => language.code == languageCode,
      );
    } catch (e) {
      return null;
    }
  }

  // 檢查語言是否支援
  static bool isLanguageSupported(String languageCode) {
    return supportedLanguages.any(
      (language) => language.code == languageCode,
    );
  }
}

/// 語言資訊模型
class LanguageInfo {
  final String code;
  final String name;
  final String nativeName;
  final String locale;

  const LanguageInfo({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.locale,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LanguageInfo && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() {
    return 'LanguageInfo(code: $code, name: $name, nativeName: $nativeName, locale: $locale)';
  }
}
