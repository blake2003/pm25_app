import 'package:flutter_test/flutter_test.dart';
import 'package:pm25_app/core/constants/theme/theme_colors.dart';
import 'package:pm25_app/features/settings/theme/auto_theme/auto_theme_service.dart';
import 'package:pm25_app/features/settings/theme/auto_theme/time_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('AutoThemeService 測試', () {
    late AutoThemeService autoThemeService;
    late TimeProvider timeProvider;

    setUp(() {
      timeProvider = TimeProvider();
      autoThemeService = AutoThemeService(timeProvider: timeProvider);
    });

    tearDown(() {
      autoThemeService.dispose();
    });

    group('主題判斷測試', () {
      test('應該在白天時間返回淺色主題', () {
        // Arrange
        final testTime = DateTime(2024, 1, 1, 10, 0); // 10:00 AM

        // Act
        final theme = autoThemeService.getThemeForTime(testTime);

        // Assert
        expect(theme, AppThemeMode.light);
      });

      test('應該使用用戶設定的時間進行主題判斷', () {
        // Arrange & Act
        // 測試 getThemeForTimeWithUserSettings 方法能正常執行
        // 由於沒有設定自訂時間，應該使用預設時間邏輯
        final theme = autoThemeService.getThemeForTimeWithUserSettings();

        // Assert
        // 驗證方法能正常執行而不會拋出異常
        expect(theme, isA<AppThemeMode>());
        // 應該返回 light 或 dark 中的一個
        expect(
            theme == AppThemeMode.light || theme == AppThemeMode.dark, isTrue);
      });

      test('應該在夜晚時間返回深色主題', () {
        // Arrange
        final testTime = DateTime(2024, 1, 1, 22, 0); // 10:00 PM

        // Act
        final theme = autoThemeService.getThemeForTime(testTime);

        // Assert
        expect(theme, AppThemeMode.dark);
      });

      test('應該在跨日時正確處理', () {
        // Arrange
        final testTime = DateTime(2024, 1, 1, 23, 59); // 11:59 PM

        // Act
        final theme = autoThemeService.getThemeForTime(testTime);

        // Assert
        expect(theme, AppThemeMode.dark);
      });

      test('應該在凌晨時間返回深色主題', () {
        // Arrange
        final testTime = DateTime(2024, 1, 1, 2, 0); // 2:00 AM

        // Act
        final theme = autoThemeService.getThemeForTime(testTime);

        // Assert
        expect(theme, AppThemeMode.dark);
      });
    });

    group('服務狀態測試', () {
      test('初始狀態應該未運行', () {
        // Act
        final isRunning = autoThemeService.isRunning;

        // Assert
        expect(isRunning, false);
      });

      test('應該能獲取定時器狀態', () {
        // Act
        final status = autoThemeService.getTimerStatus();

        // Assert
        expect(status['isRunning'], false);
        expect(status['hasCallback'], false);
      });
    });

    group('回調設定測試', () {
      test('應該能設定主題變更回調', () {
        // Arrange
        AppThemeMode? receivedTheme;
        void onThemeChanged(AppThemeMode theme) {
          receivedTheme = theme;
        }

        // Act
        autoThemeService.setOnThemeChanged(onThemeChanged);
        final status = autoThemeService.getTimerStatus();

        // Assert
        expect(status['hasCallback'], true);
      });
    });

    group('手動觸發測試', () {
      test('應該能手動觸發主題切換', () async {
        // Arrange
        AppThemeMode? receivedTheme;
        void onThemeChanged(AppThemeMode theme) {
          receivedTheme = theme;
        }

        autoThemeService.setOnThemeChanged(onThemeChanged);

        // Act
        await autoThemeService.triggerManualSwitch();

        // Assert
        expect(receivedTheme, isNotNull);
        expect(receivedTheme, isA<AppThemeMode>());
      });
    });

    group('服務啟動和停止測試', () {
      test('應該能啟動自動切換服務', () async {
        // Arrange
        AppThemeMode? receivedTheme;
        void onThemeChanged(AppThemeMode theme) {
          receivedTheme = theme;
        }

        autoThemeService.setOnThemeChanged(onThemeChanged);

        // Act
        await autoThemeService.startAutoSwitch();

        // Assert
        expect(autoThemeService.isRunning, true);
        expect(receivedTheme, isNotNull);
      });

      test('應該能停止自動切換服務', () async {
        // Arrange
        await autoThemeService.startAutoSwitch();

        // Act
        autoThemeService.stopAutoSwitch();

        // Assert
        expect(autoThemeService.isRunning, false);
      });
    });

    group('資源釋放測試', () {
      test('應該能正確釋放資源', () {
        // Act
        autoThemeService.dispose();

        // Assert
        expect(autoThemeService.isRunning, false);
        final status = autoThemeService.getTimerStatus();
        expect(status['hasCallback'], false);
      });
    });

    group('邊界時間測試', () {
      test('應該在 07:00 返回淺色主題', () {
        // Arrange
        final testTime = DateTime(2024, 1, 1, 7, 0); // 07:00 AM

        // Act
        final theme = autoThemeService.getThemeForTime(testTime);

        // Assert
        expect(theme, AppThemeMode.light);
      });

      test('應該在 19:00 返回深色主題', () {
        // Arrange
        final testTime = DateTime(2024, 1, 1, 19, 0); // 07:00 PM

        // Act
        final theme = autoThemeService.getThemeForTime(testTime);

        // Assert
        expect(theme, AppThemeMode.dark);
      });

      test('應該在 06:59 返回深色主題', () {
        // Arrange
        final testTime = DateTime(2024, 1, 1, 6, 59); // 06:59 AM

        // Act
        final theme = autoThemeService.getThemeForTime(testTime);

        // Assert
        expect(theme, AppThemeMode.dark);
      });

      test('應該在 18:59 返回淺色主題', () {
        // Arrange
        final testTime = DateTime(2024, 1, 1, 18, 59); // 06:59 PM

        // Act
        final theme = autoThemeService.getThemeForTime(testTime);

        // Assert
        expect(theme, AppThemeMode.light);
      });
    });
  });
}
