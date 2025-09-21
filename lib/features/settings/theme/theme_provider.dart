import 'package:flutter/material.dart';
import 'package:pm25_app/core/constants/theme/theme_colors.dart';
import 'package:pm25_app/core/loggers/log.dart';
import 'package:pm25_app/features/settings/theme/auto_theme/auto_theme_service.dart';
import 'package:pm25_app/features/settings/theme/theme_repository.dart';

class ThemeProvider extends ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.auto;
  DateTime _lastUpdated = DateTime.now();
  final ThemeRepository _themeRepository;
  final AutoThemeService _autoThemeService;
  final log = AppLogger('ThemeProvider');

  /// 建構子
  ///
  /// [themeRepository] 主題資料存取層，如果未提供則創建新的實例
  /// [autoThemeService] 自動切換服務，如果未提供則創建新的實例
  ThemeProvider({
    ThemeRepository? themeRepository,
    AutoThemeService? autoThemeService,
  })  : _themeRepository = themeRepository ?? ThemeRepository(),
        _autoThemeService = autoThemeService ?? AutoThemeService() {
    // 設定自動切換服務的回調
    _autoThemeService.setOnThemeChanged(_onAutoThemeChanged);
  }

  // Getters
  /// 當前主題模式
  AppThemeMode get themeMode => _themeMode;

  /// 最後更新時間
  DateTime get lastUpdated => _lastUpdated;

  /// 將 AppThemeMode 轉換為 Flutter 的 ThemeMode
  /// 用於與 Flutter 的主題系統整合
  ThemeMode get flutterThemeMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.auto:
        // 自動模式需要根據當前時間判斷
        return _getResolvedThemeMode() == AppThemeMode.light
            ? ThemeMode.light
            : ThemeMode.dark;
    }
  }

  /// 獲取解析後的主題模式
  /// 如果是自動模式，則根據當前時間返回實際的主題模式
  AppThemeMode _getResolvedThemeMode() {
    if (_themeMode == AppThemeMode.auto) {
      // 使用 AutoThemeService 的 _getCurrentThemeMode 方法來獲取基於用戶設定的主題
      // 這個方法會考慮用戶自訂的時間設定，而不是硬編碼的預設時間
      return _autoThemeService.getThemeForTimeWithUserSettings();
    }
    return _themeMode;
  }

  /// 載入主題設定
  /// 從本地儲存載入主題設定，如果載入失敗則使用預設設定
  Future<void> loadTheme() async {
    try {
      log.i('開始載入主題設定');
      final settings = await _themeRepository.loadThemeSettings();
      _themeMode = settings['themeMode'] ?? AppThemeMode.auto;
      _lastUpdated = settings['lastUpdated'] ?? DateTime.now();

      // 如果是自動模式，啟動自動切換服務
      if (_themeMode == AppThemeMode.auto) {
        await _autoThemeService.startAutoSwitch();
      } else {
        _autoThemeService.stopAutoSwitch();
      }

      notifyListeners();
      log.i('主題設定載入完成: ${AppColors.getThemeModeDescription(_themeMode)}');
    } catch (e, stack) {
      log.e('主題設定載入失敗，使用預設設定', e, stack);
      // 使用預設設定
      _themeMode = AppThemeMode.auto;
      _lastUpdated = DateTime.now();
      await _autoThemeService.startAutoSwitch();
      notifyListeners();
    }
  }

  /// 切換主題
  ///
  /// [mode] 要切換到的主題模式
  /// 切換主題並儲存到本地儲存
  Future<void> toggleTheme(AppThemeMode mode) async {
    try {
      log.i(
          '切換主題: ${AppColors.getThemeModeDescription(_themeMode)} -> ${AppColors.getThemeModeDescription(mode)}');

      // 記錄切換開始時間（用於效能監控）
      final startTime = DateTime.now();

      _themeMode = mode;
      _lastUpdated = DateTime.now();

      // 根據新的主題模式啟動或停止自動切換服務
      if (mode == AppThemeMode.auto) {
        await _autoThemeService.startAutoSwitch();
      } else {
        _autoThemeService.stopAutoSwitch();
      }

      notifyListeners();

      // 儲存設定
      await _themeRepository.saveThemeSettings({
        'themeMode': mode,
        'lastUpdated': _lastUpdated,
      });

      // 計算切換耗時
      final duration = DateTime.now().difference(startTime);
      log.i('主題切換完成並已儲存，耗時: ${duration.inMilliseconds}ms');

      // 檢查效能是否符合要求（100ms 內）
      if (duration.inMilliseconds > 100) {
        log.w('主題切換耗時超過 100ms: ${duration.inMilliseconds}ms');
      }
    } catch (e, stack) {
      log.e('主題切換失敗', e, stack);
      rethrow;
    }
  }

  /// 切換到淺色主題
  Future<void> setLightTheme() async {
    await toggleTheme(AppThemeMode.light);
  }

  /// 切換到深色主題
  Future<void> setDarkTheme() async {
    await toggleTheme(AppThemeMode.dark);
  }

  /// 切換到自動主題（跟隨系統）
  Future<void> setAutoTheme() async {
    await toggleTheme(AppThemeMode.auto);
  }

  /// 檢查是否為淺色主題
  bool get isLightTheme => _themeMode == AppThemeMode.light;

  /// 檢查是否為深色主題
  bool get isDarkTheme => _themeMode == AppThemeMode.dark;

  /// 檢查是否為自動主題
  bool get isAutoTheme => _themeMode == AppThemeMode.auto;

  /// 獲取當前主題的描述文字
  String get currentThemeDescription =>
      AppColors.getThemeModeDescription(_themeMode);

  /// 獲取解析後的主題模式（公開方法）
  /// 其他組件可以使用這個方法來獲取實際應該使用的主題模式
  AppThemeMode get resolvedThemeMode => _getResolvedThemeMode();

  /// 重置為預設主題
  Future<void> resetToDefault() async {
    await toggleTheme(AppThemeMode.auto);
  }

  /// 自動切換服務的回調函數
  /// 當自動切換服務觸發主題變更時調用
  void _onAutoThemeChanged(AppThemeMode newThemeMode) {
    try {
      log.i('自動切換服務觸發主題變更: ${AppColors.getThemeModeDescription(newThemeMode)}');
      // 注意：這裡不更新 _themeMode，因為它仍然是 auto
      // 只是通知 UI 重新渲染以反映新的解析後主題
      notifyListeners();
    } catch (e, stack) {
      log.e('處理自動主題變更失敗', e, stack);
    }
  }

  /// 手動觸發自動切換
  /// 立即根據當前時間判斷並切換主題（僅在自動模式下有效）
  Future<void> triggerAutoSwitch() async {
    if (_themeMode == AppThemeMode.auto) {
      await _autoThemeService.triggerManualSwitch();
    }
  }

  /// 獲取自動切換服務狀態
  Map<String, dynamic> getAutoSwitchStatus() {
    return _autoThemeService.getTimerStatus();
  }

  /// 檢查自動切換是否正在運行
  bool get isAutoSwitchRunning => _autoThemeService.isRunning;

  @override
  void dispose() {
    log.d('ThemeProvider 已釋放');
    _autoThemeService.dispose();
    super.dispose();
  }
}
