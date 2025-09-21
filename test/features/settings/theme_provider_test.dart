import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pm25_app/core/constants/theme/theme_colors.dart';
import 'package:pm25_app/features/settings/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeProvider Tests', () {
    late ThemeProvider themeProvider;

    setUp(() {
      // 初始化 SharedPreferences 模擬
      SharedPreferences.setMockInitialValues({});
      themeProvider = ThemeProvider();
    });

    tearDown(() {
      // 清理 SharedPreferences
      SharedPreferences.setMockInitialValues({});
    });

    group('初始化測試', () {
      test('應該使用預設主題模式', () {
        expect(themeProvider.themeMode, AppThemeMode.auto);
        expect(themeProvider.isAutoTheme, true);
        expect(themeProvider.isLightTheme, false);
        expect(themeProvider.isDarkTheme, false);
      });

      test('應該提供正確的 Flutter ThemeMode', () {
        // 自動模式會根據當前時間返回 light 或 dark
        expect(themeProvider.flutterThemeMode, isA<ThemeMode>());
      });

      test('應該提供正確的主題描述', () {
        expect(themeProvider.currentThemeDescription, '自動');
      });
    });

    group('主題模式檢查測試', () {
      test('預設應該是自動主題', () {
        // Assert
        expect(themeProvider.isLightTheme, false);
        expect(themeProvider.isDarkTheme, false);
        expect(themeProvider.isAutoTheme, true);
        expect(themeProvider.flutterThemeMode, isA<ThemeMode>());
        expect(themeProvider.currentThemeDescription, '自動');
      });
    });

    group('主題模式枚舉測試', () {
      test('AppThemeMode 應該包含正確的值', () {
        expect(AppThemeMode.values.length, 3);
        expect(AppThemeMode.values.contains(AppThemeMode.light), true);
        expect(AppThemeMode.values.contains(AppThemeMode.dark), true);
        expect(AppThemeMode.values.contains(AppThemeMode.auto), true);
      });

      test('AppColors.getThemeModeDescription 應該返回正確的描述', () {
        expect(AppColors.getThemeModeDescription(AppThemeMode.light), '淺色');
        expect(AppColors.getThemeModeDescription(AppThemeMode.dark), '深色');
        expect(AppColors.getThemeModeDescription(AppThemeMode.auto), '自動');
      });
    });

    group('色彩系統測試', () {
      test('應該能獲取淺色主題色彩', () {
        final color = AppColors.getColor('primary', AppThemeMode.light);
        expect(color, isA<Color>());
        expect(color.value, isNot(0));
      });

      test('應該能獲取深色主題色彩', () {
        final color = AppColors.getColor('primary', AppThemeMode.dark);
        expect(color, isA<Color>());
        expect(color.value, isNot(0));
      });

      test('應該能獲取文字色彩', () {
        final color = AppColors.getTextColor('primary', AppThemeMode.light);
        expect(color, isA<Color>());
        expect(color.value, isNot(0));
      });

      test('應該能獲取系統色彩', () {
        final color =
            AppColors.getSystemColor('systemGrey', AppThemeMode.light);
        expect(color, isA<Color>());
        expect(color.value, isNot(0));
      });
    });

    group('對比度檢查測試', () {
      test('應該能檢查對比度是否符合 WCAG AA 標準', () {
        final foreground = Colors.black;
        final background = Colors.white;

        final isCompliant = AppColors.isWcagAACompliant(foreground, background);
        expect(isCompliant, isA<bool>());
      });

      test('黑白對比應該符合 WCAG AA 標準', () {
        final foreground = Colors.black;
        final background = Colors.white;

        final isCompliant = AppColors.isWcagAACompliant(foreground, background);
        expect(isCompliant, true);
      });
    });

    group('自動切換功能測試', () {
      test('應該能獲取自動切換服務狀態', () {
        // Act
        final status = themeProvider.getAutoSwitchStatus();

        // Assert
        expect(status, isA<Map<String, dynamic>>());
        expect(status['isRunning'], isA<bool>());
        expect(status['hasCallback'], isA<bool>());
      });

      test('應該能檢查自動切換是否正在運行', () {
        // Act
        final isRunning = themeProvider.isAutoSwitchRunning;

        // Assert
        expect(isRunning, isA<bool>());
      });

      test('應該能手動觸發自動切換', () async {
        // Act
        await themeProvider.triggerAutoSwitch();

        // Assert - 不應該拋出異常
        expect(true, true);
      });

      test('應該能正確釋放資源', () {
        // Act
        themeProvider.dispose();

        // Assert - 不應該拋出異常
        expect(true, true);
      });
    });

    group('主題切換整合測試', () {
      test('切換到自動模式應該啟動自動切換服務', () async {
        // Arrange
        await themeProvider.toggleTheme(AppThemeMode.light);

        // Act
        await themeProvider.toggleTheme(AppThemeMode.auto);

        // Assert
        expect(themeProvider.isAutoTheme, true);
        expect(themeProvider.isAutoSwitchRunning, true);
      });

      test('切換到手動模式應該停止自動切換服務', () async {
        // Arrange
        await themeProvider.toggleTheme(AppThemeMode.auto);

        // Act
        await themeProvider.toggleTheme(AppThemeMode.light);

        // Assert
        expect(themeProvider.isLightTheme, true);
        expect(themeProvider.isAutoSwitchRunning, false);
      });
    });
  });
}
