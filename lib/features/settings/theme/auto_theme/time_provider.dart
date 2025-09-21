import 'package:flutter/foundation.dart';
import 'package:pm25_app/core/loggers/log.dart';

import 'time_repository.dart';

/// 時間管理 Provider
/// 負責管理自動切換主題的時間設定，包括白天和夜晚的切換時間
/// 使用 Provider 模式進行狀態管理和日誌記錄
class TimeProvider extends ChangeNotifier {
  final TimeRepository _timeRepository;
  final log = AppLogger('TimeProvider');

  // 狀態變數
  Map<String, int>? _dayStartTime;
  Map<String, int>? _nightStartTime;
  bool _isLoading = false;
  String? _errorMessage;

  // 暫存狀態變更標記
  bool _hasTimeChanges = false;
  Map<String, int>? _pendingDayStartTime;
  Map<String, int>? _pendingNightStartTime;

  TimeProvider({TimeRepository? timeRepository})
      : _timeRepository = timeRepository ?? TimeRepository() {
    _initializeTimeSettings();
  }

  // Getters
  Map<String, int>? get dayStartTime => _dayStartTime;
  Map<String, int>? get nightStartTime => _nightStartTime;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasTimeChanges => _hasTimeChanges;

  /// 初始化時間設定
  Future<void> _initializeTimeSettings() async {
    try {
      log.i('初始化時間設定');
      _setLoading(true);
      _clearError();

      await refreshTimeSettings();

      log.i('時間設定初始化完成');
    } catch (e, stack) {
      log.e('初始化時間設定失敗', e, stack);
      _setError('初始化時間設定失敗: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// 刷新時間設定
  Future<void> refreshTimeSettings() async {
    try {
      log.d('刷新時間設定');
      _setLoading(true);
      _clearError();

      _dayStartTime = await _timeRepository.getDayStartTime();
      _nightStartTime = await _timeRepository.getNightStartTime();

      log.i(
          '時間設定刷新完成 - 白天: ${_formatTime(_dayStartTime!)}, 夜晚: ${_formatTime(_nightStartTime!)}');
      notifyListeners();
    } catch (e, stack) {
      log.e('刷新時間設定失敗', e, stack);
      _setError('刷新時間設定失敗: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// 獲取白天開始時間
  /// 返回白天開始的小時和分鐘
  Future<Map<String, int>> getDayStartTime() async {
    try {
      final result = await _timeRepository.getDayStartTime();
      return result;
    } catch (e, stack) {
      log.e('獲取白天開始時間失敗', e, stack);
      rethrow;
    }
  }

  /// 獲取夜晚開始時間
  /// 返回夜晚開始的小時和分鐘
  Future<Map<String, int>> getNightStartTime() async {
    try {
      final result = await _timeRepository.getNightStartTime();
      return result;
    } catch (e, stack) {
      log.e('獲取夜晚開始時間失敗', e, stack);
      rethrow;
    }
  }

  /// 設定白天開始時間
  /// [hour] 小時 (0-23)
  /// [minute] 分鐘 (0-59)
  Future<void> setDayStartTime(int hour, int minute) async {
    try {
      _setLoading(true);
      _clearError();

      await _timeRepository.saveDayStartTime(hour, minute);
      _dayStartTime = {'hour': hour, 'minute': minute};

      // 標記有變更並暫存新值
      _hasTimeChanges = true;
      _pendingDayStartTime = {'hour': hour, 'minute': minute};

      notifyListeners();
    } catch (e) {
      _setError('設定白天開始時間失敗: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// 設定夜晚開始時間
  /// [hour] 小時 (0-23)
  /// [minute] 分鐘 (0-59)
  Future<void> setNightStartTime(int hour, int minute) async {
    try {
      _setLoading(true);
      _clearError();

      await _timeRepository.saveNightStartTime(hour, minute);
      _nightStartTime = {'hour': hour, 'minute': minute};

      // 標記有變更並暫存新值
      _hasTimeChanges = true;
      _pendingNightStartTime = {'hour': hour, 'minute': minute};

      notifyListeners();
    } catch (e) {
      _setError('設定夜晚開始時間失敗: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// 重置為預設時間設定
  Future<void> resetToDefault() async {
    try {
      _setLoading(true);
      _clearError();

      final defaultTimes = _timeRepository.getDefaultTimes();
      await setDayStartTime(defaultTimes['dayStart']!['hour']!,
          defaultTimes['dayStart']!['minute']!);
      await setNightStartTime(defaultTimes['nightStart']!['hour']!,
          defaultTimes['nightStart']!['minute']!);
    } catch (e, stack) {
      log.e('重置時間設定失敗', e, stack);
      _setError('重置時間設定失敗: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// 獲取預設時間設定
  Map<String, Map<String, int>> getDefaultTimes() {
    return _timeRepository.getDefaultTimes();
  }

  /// 完成時間設定變更
  /// 在用戶按下完成鈕時調用，輸出被記錄的最新狀態的 log
  void completeTimeSettings() {
    if (_hasTimeChanges) {
      log.i('時間設定變更完成');

      if (_pendingDayStartTime != null) {
        log.i('白天開始時間已設定為: ${_formatTime(_pendingDayStartTime!)}');
      }

      if (_pendingNightStartTime != null) {
        log.i('夜晚開始時間已設定為: ${_formatTime(_pendingNightStartTime!)}');
      }

      // 清除暫存狀態
      _hasTimeChanges = false;
      _pendingDayStartTime = null;
      _pendingNightStartTime = null;

      notifyListeners();
    }
  }

  /// 驗證時間設定是否有效
  /// 檢查白天和夜晚時間是否合理（白天時間應該在夜晚時間之前）
  Future<bool> validateTimeSettings() async {
    try {
      final dayTime = await getDayStartTime();
      final nightTime = await getNightStartTime();

      final dayMinutes = dayTime['hour']! * 60 + dayTime['minute']!;
      final nightMinutes = nightTime['hour']! * 60 + nightTime['minute']!;

      // 檢查時間是否合理（白天時間應該在夜晚時間之前）
      final isValid = dayMinutes < nightMinutes;

      return isValid;
    } catch (e, stack) {
      log.e('驗證時間設定失敗', e, stack);
      return false;
    }
  }

  /// 獲取當前時間對應的主題模式
  /// 根據當前時間和設定的切換時間判斷應該使用哪種主題
  Future<String> getCurrentThemeMode() async {
    try {
      final now = DateTime.now();
      final dayTime = await getDayStartTime();
      final nightTime = await getNightStartTime();

      final currentMinutes = now.hour * 60 + now.minute;
      final dayMinutes = dayTime['hour']! * 60 + dayTime['minute']!;
      final nightMinutes = nightTime['hour']! * 60 + nightTime['minute']!;

      // 判斷當前時間應該使用哪種主題
      String themeMode;
      if (currentMinutes >= dayMinutes && currentMinutes < nightMinutes) {
        themeMode = 'light'; // 白天時間使用淺色主題
      } else {
        themeMode = 'dark'; // 夜晚時間使用深色主題
      }

      return themeMode;
    } catch (e, stack) {
      log.e('獲取當前主題模式失敗', e, stack);
      return 'light'; // 預設返回淺色主題
    }
  }

  /// 計算下一個切換時間
  /// 返回距離下一個主題切換的時間（秒）
  Future<int> getNextSwitchTimeInSeconds() async {
    try {
      final now = DateTime.now();
      final dayTime = await getDayStartTime();
      final nightTime = await getNightStartTime();

      final currentMinutes = now.hour * 60 + now.minute;
      final dayMinutes = dayTime['hour']! * 60 + dayTime['minute']!;
      final nightMinutes = nightTime['hour']! * 60 + nightTime['minute']!;

      int nextSwitchMinutes;
      if (currentMinutes < dayMinutes) {
        // 當前時間在白天開始之前，下一個切換是白天開始
        nextSwitchMinutes = dayMinutes;
      } else if (currentMinutes < nightMinutes) {
        // 當前時間在白天，下一個切換是夜晚開始
        nextSwitchMinutes = nightMinutes;
      } else {
        // 當前時間在夜晚，下一個切換是明天的白天開始
        nextSwitchMinutes = dayMinutes + 24 * 60; // 加一天
      }

      final secondsUntilSwitch = (nextSwitchMinutes - currentMinutes) * 60;

      return secondsUntilSwitch;
    } catch (e, stack) {
      log.e('計算下一個切換時間失敗', e, stack);
      return 3600; // 預設返回1小時
    }
  }

  // 私有輔助方法
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  String _formatTime(Map<String, int> time) {
    return '${time['hour']!.toString().padLeft(2, '0')}:${time['minute']!.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    log.d('釋放 TimeProvider 資源');
    super.dispose();
  }
}
