import 'package:flutter_test/flutter_test.dart';
import 'package:pm25_app/core/constants/theme/theme_colors.dart';
import 'package:pm25_app/features/settings/theme/auto_theme/auto_theme_service.dart';

/// 主題一致性測試
/// 確保自動模式切換與手動切換深色主題模式時畫面會一致
void main() {
  group('主題一致性測試', () {
    late AutoThemeService autoThemeService;

    setUp(() {
      autoThemeService = AutoThemeService();
    });

    tearDown(() {
      autoThemeService.dispose();
    });

    test('getThemeForTime 使用預設時間設定', () {
      // 測試白天時間 (10:00) - 應該使用淺色主題
      final dayTime = DateTime(2024, 1, 1, 10, 0);
      final themeForDay = autoThemeService.getThemeForTime(dayTime);
      expect(themeForDay, AppThemeMode.light, reason: '在預設白天時間應該使用淺色主題');

      // 測試夜晚時間 (22:00) - 應該使用深色主題
      final nightTime = DateTime(2024, 1, 1, 22, 0);
      final themeForNight = autoThemeService.getThemeForTime(nightTime);
      expect(themeForNight, AppThemeMode.dark, reason: '在預設夜晚時間應該使用深色主題');

      // 測試邊界時間 (07:00) - 應該使用淺色主題
      final boundaryDayTime = DateTime(2024, 1, 1, 7, 0);
      final themeForBoundaryDay =
          autoThemeService.getThemeForTime(boundaryDayTime);
      expect(themeForBoundaryDay, AppThemeMode.light,
          reason: '在預設白天開始時間應該使用淺色主題');

      // 測試邊界時間 (19:00) - 應該使用深色主題
      final boundaryNightTime = DateTime(2024, 1, 1, 19, 0);
      final themeForBoundaryNight =
          autoThemeService.getThemeForTime(boundaryNightTime);
      expect(themeForBoundaryNight, AppThemeMode.dark,
          reason: '在預設夜晚開始時間應該使用深色主題');
    });

    test('getThemeForTimeWithUserSettings 使用緩存時間設定', () {
      // 由於緩存可能為空，這個方法會使用預設值
      // 測試白天時間
      final themeWithUserSettings =
          autoThemeService.getThemeForTimeWithUserSettings();
      expect(
          [AppThemeMode.light, AppThemeMode.dark]
              .contains(themeWithUserSettings),
          true,
          reason: 'getThemeForTimeWithUserSettings 應該返回有效的主題模式');
    });

    test('主題模式枚舉值正確性', () {
      // 測試枚舉值
      expect(AppThemeMode.light.toString(), 'AppThemeMode.light');
      expect(AppThemeMode.dark.toString(), 'AppThemeMode.dark');
      expect(AppThemeMode.auto.toString(), 'AppThemeMode.auto');
    });

    test('主題模式描述文字正確性', () {
      // 測試描述文字
      expect(AppColors.getThemeModeDescription(AppThemeMode.light), '淺色');
      expect(AppColors.getThemeModeDescription(AppThemeMode.dark), '深色');
      expect(AppColors.getThemeModeDescription(AppThemeMode.auto), '自動');
    });

    test('AutoThemeService 基本功能', () {
      // 測試服務狀態
      expect(autoThemeService.isRunning, false, reason: '初始狀態下自動切換服務不應該運行');

      // 測試定時器狀態
      final timerStatus = autoThemeService.getTimerStatus();
      expect(timerStatus['isRunning'], false, reason: '初始狀態下定時器不應該運行');
      expect(timerStatus['hasCallback'], false, reason: '初始狀態下不應該有回調函數');
    });
  });
}
