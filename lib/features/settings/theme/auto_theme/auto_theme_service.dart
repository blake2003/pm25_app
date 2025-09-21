import 'dart:async';

import 'package:pm25_app/core/constants/theme/theme_colors.dart';
import 'package:pm25_app/core/loggers/log.dart';
import 'package:pm25_app/features/settings/theme/auto_theme/time_provider.dart';

/// 自動切換主題服務
/// 負責根據時間自動切換主題，包括定時器管理和主題判斷邏輯
class AutoThemeService {
  Timer? _autoSwitchTimer;
  final TimeProvider _timeProvider;
  final log = AppLogger('AutoThemeService');

  // 回調函數，用於通知主題變更
  Function(AppThemeMode)? _onThemeChanged;

  // 緩存時間設定，避免頻繁的異步調用
  Map<String, int>? _cachedDayStartTime;
  Map<String, int>? _cachedNightStartTime;

  /// 建構子
  AutoThemeService({TimeProvider? timeProvider})
      : _timeProvider = timeProvider ?? TimeProvider();

  /// 設定主題變更回調
  /// [onThemeChanged] 主題變更時的回調函數
  void setOnThemeChanged(Function(AppThemeMode) onThemeChanged) {
    _onThemeChanged = onThemeChanged;
    log.d('設定主題變更回調');
  }

  /// 啟動自動切換服務
  /// 根據當前時間判斷主題，並啟動定時器
  Future<void> startAutoSwitch() async {
    try {
      log.i('啟動自動切換服務');

      // 先停止現有的定時器
      stopAutoSwitch();

      // 更新緩存的時間設定
      await _updateCachedTimeSettings();

      // 根據當前時間判斷應該使用的主題
      final currentThemeMode = await _getCurrentThemeMode();
      log.i(
          '當前應該使用的主題: ${AppColors.getThemeModeDescription(currentThemeMode)}');

      // 通知主題變更
      _onThemeChanged?.call(currentThemeMode);

      // 計算下一個切換時間並啟動定時器
      await _scheduleNextSwitch();

      log.i('自動切換服務啟動完成');
    } catch (e, stack) {
      log.e('啟動自動切換服務失敗', e, stack);
    }
  }

  /// 停止自動切換服務
  void stopAutoSwitch() {
    try {
      log.d('停止自動切換服務');
      _autoSwitchTimer?.cancel();
      _autoSwitchTimer = null;
      log.d('自動切換服務已停止');
    } catch (e, stack) {
      log.e('停止自動切換服務失敗', e, stack);
    }
  }

  /// 根據指定時間獲取對應的主題模式
  /// [dateTime] 指定的時間，如果為 null 則使用當前時間
  /// 返回對應的主題模式
  AppThemeMode getThemeForTime(DateTime? dateTime) {
    try {
      final now = dateTime ?? DateTime.now();
      final currentMinutes = now.hour * 60 + now.minute;

      // 使用預設時間進行判斷 (07:00 和 19:00)
      const dayMinutes = 7 * 60; // 07:00
      const nightMinutes = 19 * 60; // 19:00

      if (currentMinutes >= dayMinutes && currentMinutes < nightMinutes) {
        return AppThemeMode.light; // 白天時間使用淺色主題
      } else {
        return AppThemeMode.dark; // 夜晚時間使用深色主題
      }
    } catch (e, stack) {
      log.e('獲取時間對應主題失敗', e, stack);
      return AppThemeMode.light; // 預設返回淺色主題
    }
  }

  /// 根據用戶設定的時間獲取對應的主題模式
  /// 這個方法會考慮用戶自訂的時間設定，而不是硬編碼的預設時間
  /// 返回對應的主題模式
  AppThemeMode getThemeForTimeWithUserSettings() {
    try {
      final now = DateTime.now();
      final currentMinutes = now.hour * 60 + now.minute;

      // 使用 TimeProvider 獲取用戶設定的時間
      // 由於需要同步返回，我們使用一個簡化的邏輯
      // 如果無法獲取用戶設定，則使用預設時間
      final dayTime = _getCachedDayStartTime();
      final nightTime = _getCachedNightStartTime();

      final dayMinutes = dayTime['hour']! * 60 + dayTime['minute']!;
      final nightMinutes = nightTime['hour']! * 60 + nightTime['minute']!;

      if (currentMinutes >= dayMinutes && currentMinutes < nightMinutes) {
        return AppThemeMode.light; // 白天時間使用淺色主題
      } else {
        return AppThemeMode.dark; // 夜晚時間使用深色主題
      }
    } catch (e, stack) {
      log.e('獲取用戶設定時間對應主題失敗', e, stack);
      // 如果獲取用戶設定失敗，回退到預設邏輯
      return getThemeForTime(null);
    }
  }

  /// 根據當前時間和設定獲取主題模式
  /// 返回當前應該使用的主題模式
  Future<AppThemeMode> _getCurrentThemeMode() async {
    try {
      // 使用緩存的時間設定來確保一致性
      return getThemeForTimeWithUserSettings();
    } catch (e, stack) {
      log.e('獲取當前主題模式失敗', e, stack);
      return getThemeForTime(null); // 使用預設邏輯
    }
  }

  /// 排程下一個切換
  /// 計算下一個切換時間並啟動定時器
  Future<void> _scheduleNextSwitch() async {
    try {
      final secondsUntilSwitch =
          await _timeProvider.getNextSwitchTimeInSeconds();

      log.d('排程下一個切換，等待 $secondsUntilSwitch 秒');

      _autoSwitchTimer = Timer(Duration(seconds: secondsUntilSwitch), () async {
        log.i('定時器觸發，執行主題切換');
        await _performThemeSwitch();
        // 重新排程下一個切換
        await _scheduleNextSwitch();
      });
    } catch (e, stack) {
      log.e('排程下一個切換失敗', e, stack);
      // 如果排程失敗，設定一個預設的定時器（1小時後重試）
      _autoSwitchTimer = Timer(Duration(hours: 1), () async {
        log.w('使用預設定時器重試');
        await _scheduleNextSwitch();
      });
    }
  }

  /// 執行主題切換
  /// 根據當前時間判斷新主題並通知變更
  Future<void> _performThemeSwitch() async {
    try {
      final newThemeMode = await _getCurrentThemeMode();
      log.i('執行主題切換到: ${AppColors.getThemeModeDescription(newThemeMode)}');

      // 通知主題變更
      _onThemeChanged?.call(newThemeMode);
    } catch (e, stack) {
      log.e('執行主題切換失敗', e, stack);
    }
  }

  /// 手動觸發主題切換
  /// 立即根據當前時間判斷並切換主題
  Future<void> triggerManualSwitch() async {
    try {
      log.i('手動觸發主題切換');
      // 更新緩存的時間設定
      await _updateCachedTimeSettings();
      await _performThemeSwitch();
    } catch (e, stack) {
      log.e('手動觸發主題切換失敗', e, stack);
    }
  }

  /// 檢查自動切換是否正在運行
  bool get isRunning => _autoSwitchTimer?.isActive ?? false;

  /// 獲取當前定時器狀態
  Map<String, dynamic> getTimerStatus() {
    return {
      'isRunning': isRunning,
      'hasCallback': _onThemeChanged != null,
    };
  }

  /// 更新緩存的時間設定
  /// 從 TimeProvider 獲取最新的時間設定並緩存
  Future<void> _updateCachedTimeSettings() async {
    try {
      _cachedDayStartTime = await _timeProvider.getDayStartTime();
      _cachedNightStartTime = await _timeProvider.getNightStartTime();
      log.d('時間設定緩存已更新');
    } catch (e, stack) {
      log.e('更新時間設定緩存失敗', e, stack);
      // 如果更新失敗，使用預設值
      _cachedDayStartTime = {'hour': 7, 'minute': 0};
      _cachedNightStartTime = {'hour': 19, 'minute': 0};
    }
  }

  /// 獲取緩存的白天開始時間
  /// 如果緩存為空，返回預設值
  Map<String, int> _getCachedDayStartTime() {
    return _cachedDayStartTime ?? {'hour': 7, 'minute': 0};
  }

  /// 獲取緩存的夜晚開始時間
  /// 如果緩存為空，返回預設值
  Map<String, int> _getCachedNightStartTime() {
    return _cachedNightStartTime ?? {'hour': 19, 'minute': 0};
  }

  /// 釋放資源
  void dispose() {
    try {
      log.d('釋放自動切換服務資源');
      stopAutoSwitch();
      _onThemeChanged = null;
      _cachedDayStartTime = null;
      _cachedNightStartTime = null;
      log.d('自動切換服務資源已釋放');
    } catch (e, stack) {
      log.e('釋放自動切換服務資源失敗', e, stack);
    }
  }
}
