import 'package:shared_preferences/shared_preferences.dart';

/// 時間設定儲存庫
/// 負責處理時間設定的本地儲存，包括白天和夜晚的切換時間
class TimeRepository {
  static const String _dayStartTimeKey = 'dayStartTime';
  static const String _nightStartTimeKey = 'nightStartTime';

  // 預設時間設定 (07:00 和 19:00)
  static const int _defaultDayStartHour = 7;
  static const int _defaultDayStartMinute = 0;
  static const int _defaultNightStartHour = 19;
  static const int _defaultNightStartMinute = 0;

  /// 獲取白天開始時間
  /// 返回白天開始的小時和分鐘
  Future<Map<String, int>> getDayStartTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hour =
          prefs.getInt('${_dayStartTimeKey}_hour') ?? _defaultDayStartHour;
      final minute =
          prefs.getInt('${_dayStartTimeKey}_minute') ?? _defaultDayStartMinute;

      return {'hour': hour, 'minute': minute};
    } catch (e) {
      return {'hour': _defaultDayStartHour, 'minute': _defaultDayStartMinute};
    }
  }

  /// 獲取夜晚開始時間
  /// 返回夜晚開始的小時和分鐘
  Future<Map<String, int>> getNightStartTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hour =
          prefs.getInt('${_nightStartTimeKey}_hour') ?? _defaultNightStartHour;
      final minute = prefs.getInt('${_nightStartTimeKey}_minute') ??
          _defaultNightStartMinute;

      return {'hour': hour, 'minute': minute};
    } catch (e) {
      return {
        'hour': _defaultNightStartHour,
        'minute': _defaultNightStartMinute
      };
    }
  }

  /// 儲存白天開始時間
  /// [hour] 小時 (0-23)
  /// [minute] 分鐘 (0-59)
  Future<void> saveDayStartTime(int hour, int minute) async {
    // 驗證時間格式
    if (hour < 0 || hour > 23) {
      throw ArgumentError('小時必須在 0-23 之間');
    }
    if (minute < 0 || minute > 59) {
      throw ArgumentError('分鐘必須在 0-59 之間');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${_dayStartTimeKey}_hour', hour);
    await prefs.setInt('${_dayStartTimeKey}_minute', minute);
  }

  /// 儲存夜晚開始時間
  /// [hour] 小時 (0-23)
  /// [minute] 分鐘 (0-59)
  Future<void> saveNightStartTime(int hour, int minute) async {
    // 驗證時間格式
    if (hour < 0 || hour > 23) {
      throw ArgumentError('小時必須在 0-23 之間');
    }
    if (minute < 0 || minute > 59) {
      throw ArgumentError('分鐘必須在 0-59 之間');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${_nightStartTimeKey}_hour', hour);
    await prefs.setInt('${_nightStartTimeKey}_minute', minute);
  }

  /// 清除所有時間設定
  Future<void> clearAllTimeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_dayStartTimeKey}_hour');
    await prefs.remove('${_dayStartTimeKey}_minute');
    await prefs.remove('${_nightStartTimeKey}_hour');
    await prefs.remove('${_nightStartTimeKey}_minute');
  }

  /// 檢查是否有儲存的時間設定
  Future<bool> hasStoredTimeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final hasDayTime = prefs.containsKey('${_dayStartTimeKey}_hour');
    final hasNightTime = prefs.containsKey('${_nightStartTimeKey}_hour');
    return hasDayTime && hasNightTime;
  }

  /// 獲取預設時間設定
  Map<String, Map<String, int>> getDefaultTimes() {
    return {
      'dayStart': {
        'hour': _defaultDayStartHour,
        'minute': _defaultDayStartMinute
      },
      'nightStart': {
        'hour': _defaultNightStartHour,
        'minute': _defaultNightStartMinute
      },
    };
  }
}
