import 'package:flutter_test/flutter_test.dart';
import 'package:pm25_app/features/settings/theme/auto_theme/time_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('TimeProvider 測試', () {
    late TimeProvider timeProvider;

    setUp(() {
      // 初始化 SharedPreferences
      SharedPreferences.setMockInitialValues({});
      timeProvider = TimeProvider();
    });

    tearDown(() {
      // 清理 SharedPreferences
      SharedPreferences.setMockInitialValues({});
      timeProvider.dispose();
    });

    group('預設時間設定測試', () {
      test('應該返回預設的白天開始時間', () async {
        // Act
        final dayTime = await timeProvider.getDayStartTime();

        // Assert
        expect(dayTime['hour'], 7);
        expect(dayTime['minute'], 0);
      });

      test('應該返回預設的夜晚開始時間', () async {
        // Act
        final nightTime = await timeProvider.getNightStartTime();

        // Assert
        expect(nightTime['hour'], 19);
        expect(nightTime['minute'], 0);
      });

      test('應該返回預設時間設定', () {
        // Act
        final defaultTimes = timeProvider.getDefaultTimes();

        // Assert
        expect(defaultTimes['dayStart']!['hour'], 7);
        expect(defaultTimes['dayStart']!['minute'], 0);
        expect(defaultTimes['nightStart']!['hour'], 19);
        expect(defaultTimes['nightStart']!['minute'], 0);
      });
    });

    group('時間設定測試', () {
      test('應該能設定白天開始時間', () async {
        // Arrange
        const hour = 8;
        const minute = 30;

        // Act
        await timeProvider.setDayStartTime(hour, minute);
        final result = await timeProvider.getDayStartTime();

        // Assert
        expect(result['hour'], hour);
        expect(result['minute'], minute);
      });

      test('應該能設定夜晚開始時間', () async {
        // Arrange
        const hour = 20;
        const minute = 15;

        // Act
        await timeProvider.setNightStartTime(hour, minute);
        final result = await timeProvider.getNightStartTime();

        // Assert
        expect(result['hour'], hour);
        expect(result['minute'], minute);
      });

      test('應該驗證時間格式', () async {
        // Act & Assert
        expect(
          () => timeProvider.setDayStartTime(25, 0),
          throwsA(isA<ArgumentError>()),
        );
        expect(
          () => timeProvider.setDayStartTime(0, 60),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('主題模式判斷測試', () {
      test('應該能獲取當前主題模式', () async {
        // Act
        final themeMode = await timeProvider.getCurrentThemeMode();

        // Assert - 應該返回 'light' 或 'dark'
        expect(themeMode, isA<String>());
        expect(['light', 'dark'].contains(themeMode), true);
      });

      test('應該能計算下一個切換時間', () async {
        // Act
        final nextSwitchTime = await timeProvider.getNextSwitchTimeInSeconds();

        // Assert - 應該返回正整數
        expect(nextSwitchTime, isA<int>());
        expect(nextSwitchTime, greaterThan(0));
      });
    });

    group('重置功能測試', () {
      test('應該能重置為預設時間', () async {
        // Arrange - 先設定自定義時間
        await timeProvider.setDayStartTime(9, 30);
        await timeProvider.setNightStartTime(21, 45);

        // Act
        await timeProvider.resetToDefault();

        // Assert
        final dayTime = await timeProvider.getDayStartTime();
        final nightTime = await timeProvider.getNightStartTime();

        expect(dayTime['hour'], 7);
        expect(dayTime['minute'], 0);
        expect(nightTime['hour'], 19);
        expect(nightTime['minute'], 0);
      });
    });

    group('時間驗證測試', () {
      test('應該驗證有效的時間設定', () async {
        // Arrange
        await timeProvider.setDayStartTime(7, 0);
        await timeProvider.setNightStartTime(19, 0);

        // Act
        final isValid = await timeProvider.validateTimeSettings();

        // Assert
        expect(isValid, true);
      });

      test('應該驗證無效的時間設定', () async {
        // Arrange - 白天時間晚於夜晚時間
        await timeProvider.setDayStartTime(20, 0);
        await timeProvider.setNightStartTime(8, 0);

        // Act
        final isValid = await timeProvider.validateTimeSettings();

        // Assert
        expect(isValid, false);
      });
    });

    group('Provider 狀態測試', () {
      test('應該有正確的初始狀態', () async {
        // 等待初始化完成
        await Future.delayed(Duration(milliseconds: 100));

        // Assert
        expect(timeProvider.isLoading, false);
        expect(timeProvider.hasError, false);
        expect(timeProvider.errorMessage, null);
        expect(timeProvider.hasTimeChanges, false);
      });

      test('應該能刷新時間設定', () async {
        // Act
        await timeProvider.refreshTimeSettings();

        // Assert
        expect(timeProvider.dayStartTime, isNotNull);
        expect(timeProvider.nightStartTime, isNotNull);
        expect(timeProvider.dayStartTime!['hour'], 7);
        expect(timeProvider.nightStartTime!['hour'], 19);
      });

      test('應該標記時間變更狀態', () async {
        // Act
        await timeProvider.setDayStartTime(8, 30);

        // Assert
        expect(timeProvider.hasTimeChanges, true);
      });

      test('應該在完成時清除變更狀態', () async {
        // Arrange
        await timeProvider.setDayStartTime(8, 30);
        expect(timeProvider.hasTimeChanges, true);

        // Act
        timeProvider.completeTimeSettings();

        // Assert
        expect(timeProvider.hasTimeChanges, false);
      });
    });
  });
}
