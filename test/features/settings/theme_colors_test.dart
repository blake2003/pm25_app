import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pm25_app/core/constants/app_colors.dart';

void main() {
  group('主題顏色測試', () {
    test('深色主題文字顏色應該有足夠對比度', () {
      // 測試主要文字顏色
      final primaryTextColor =
          AppColors.getTextColor('primary', AppThemeMode.dark);
      expect(primaryTextColor, equals(const Color(0xFFFFFFFF))); // 白色

      // 測試次要文字顏色
      final secondaryTextColor =
          AppColors.getTextColor('secondary', AppThemeMode.dark);
      expect(secondaryTextColor, equals(const Color(0xFF8E8E93))); // 淺灰色

      // 測試標籤文字顏色
      final labelTextColor = AppColors.getTextColor('label', AppThemeMode.dark);
      expect(labelTextColor, equals(const Color(0xFFFFFFFF))); // 白色
    });

    test('淺色主題文字顏色應該有足夠對比度', () {
      // 測試主要文字顏色
      final primaryTextColor =
          AppColors.getTextColor('primary', AppThemeMode.light);
      expect(primaryTextColor, equals(const Color(0xFF000000))); // 黑色

      // 測試次要文字顏色
      final secondaryTextColor =
          AppColors.getTextColor('secondary', AppThemeMode.light);
      expect(secondaryTextColor, equals(const Color(0xFF8E8E93))); // 灰色

      // 測試標籤文字顏色
      final labelTextColor =
          AppColors.getTextColor('label', AppThemeMode.light);
      expect(labelTextColor, equals(const Color(0xFF000000))); // 黑色
    });

    test('系統顏色應該根據主題模式正確返回', () {
      // 測試深色主題的系統灰色
      final darkSystemGrey =
          AppColors.getSystemColor('systemGrey', AppThemeMode.dark);
      expect(darkSystemGrey, equals(const Color(0xFF8E8E93)));

      // 測試淺色主題的系統灰色
      final lightSystemGrey =
          AppColors.getSystemColor('systemGrey', AppThemeMode.light);
      expect(lightSystemGrey, equals(const Color(0xFF8E8E93)));

      // 測試深色主題的 systemGrey5
      final darkSystemGrey5 =
          AppColors.getSystemColor('systemGrey5', AppThemeMode.dark);
      expect(darkSystemGrey5, equals(const Color(0xFF2C2C2E)));

      // 測試淺色主題的 systemGrey5
      final lightSystemGrey5 =
          AppColors.getSystemColor('systemGrey5', AppThemeMode.light);
      expect(lightSystemGrey5, equals(const Color(0xFFE5E5EA)));
    });

    test('getColor 方法應該正確返回顏色', () {
      // 測試深色主題背景色
      final darkBackground =
          AppColors.getColor('background', AppThemeMode.dark);
      expect(darkBackground, equals(const Color(0xFF000000))); // 黑色

      // 測試淺色主題背景色
      final lightBackground =
          AppColors.getColor('background', AppThemeMode.light);
      expect(lightBackground, equals(const Color(0xFFFFFFFF))); // 白色

      // 測試不存在的顏色應該返回預設值
      final fallbackColor =
          AppColors.getColor('nonexistent', AppThemeMode.dark);
      expect(
          fallbackColor, equals(const Color(0xFFFFFFFF))); // 應該返回 onBackground
    });
  });
}
