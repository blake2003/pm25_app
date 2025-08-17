import 'package:flutter/material.dart';

enum AppThemeMode { light, dark, system }

class AppColors {
  // 空气质量指数颜色
  static Color getAqiColor(double value) {
    if (value <= 15.4) return Colors.green;
    if (value <= 35.4) return Colors.yellow;
    if (value <= 54.4) return Colors.orange;
    if (value <= 150.4) return Colors.red;
    return Colors.purple;
  }

  // 淺色主題色彩
  static const Map<String, Color> lightTheme = {
    'background': Color(0xFFFFFFFF),
    'surface': Color(0xFFF5F5F5),
    'primary': Color(0xFF007AFF),
    'secondary': Color(0xFF5856D6),
    'success': Color(0xFF34C759),
    'warning': Color(0xFFFF9500),
    'error': Color(0xFFFF3B30),
    'onBackground': Color(0xFF000000),
    'onSurface': Color(0xFF1C1C1E),
    'onPrimary': Color(0xFFFFFFFF),
    'onSecondary': Color(0xFFFFFFFF),
    'textPrimary': Color(0xFF000000),
    'textSecondary': Color(0xFF8E8E93),
    'textTertiary': Color(0xFFC7C7CC),
    'label': Color(0xFF000000),
    'systemGrey': Color(0xFF8E8E93),
    'systemGrey2': Color(0xFFAEAEB2),
    'systemGrey3': Color(0xFFC7C7CC),
    'systemGrey4': Color(0xFFD1D1D6),
    'systemGrey5': Color(0xFFE5E5EA),
    'systemGrey6': Color(0xFFF2F2F7),
  };

  // 深色主題色彩
  static const Map<String, Color> darkTheme = {
    'background': Color(0xFF000000),
    'surface': Color(0xFF1C1C1E),
    'primary': Color(0xFF0A84FF),
    'secondary': Color(0xFF5E5CE6),
    'success': Color(0xFF30D158),
    'warning': Color(0xFFFF9F0A),
    'error': Color(0xFFFF453A),
    'onBackground': Color(0xFFFFFFFF),
    'onSurface': Color(0xFFFFFFFF),
    'onPrimary': Color(0xFF000000),
    'onSecondary': Color(0xFF000000),
    'textPrimary': Color(0xFFFFFFFF),
    'textSecondary': Color(0xFF8E8E93),
    'textTertiary': Color(0xFF48484A),
    'label': Color(0xFFFFFFFF),
    'systemGrey': Color(0xFF8E8E93),
    'systemGrey2': Color(0xFF636366),
    'systemGrey3': Color(0xFF48484A),
    'systemGrey4': Color(0xFF3A3A3C),
    'systemGrey5': Color(0xFF2C2C2E),
    'systemGrey6': Color(0xFF1C1C1E),
  };

  // 根據主題模式獲取色彩
  static Color getColor(String colorKey, AppThemeMode themeMode) {
    final colors = themeMode == AppThemeMode.dark ? darkTheme : lightTheme;
    return colors[colorKey] ?? colors['onBackground']!;
  }

  // 獲取文字顏色（根據主題模式）
  static Color getTextColor(String textType, AppThemeMode themeMode) {
    switch (textType) {
      case 'primary':
        return getColor('textPrimary', themeMode);
      case 'secondary':
        return getColor('textSecondary', themeMode);
      case 'tertiary':
        return getColor('textTertiary', themeMode);
      case 'label':
        return getColor('label', themeMode);
      default:
        return getColor('textPrimary', themeMode);
    }
  }

  // 獲取系統顏色（根據主題模式）
  static Color getSystemColor(String colorType, AppThemeMode themeMode) {
    switch (colorType) {
      case 'systemGrey':
        return getColor('systemGrey', themeMode);
      case 'systemGrey2':
        return getColor('systemGrey2', themeMode);
      case 'systemGrey3':
        return getColor('systemGrey3', themeMode);
      case 'systemGrey4':
        return getColor('systemGrey4', themeMode);
      case 'systemGrey5':
        return getColor('systemGrey5', themeMode);
      case 'systemGrey6':
        return getColor('systemGrey6', themeMode);
      default:
        return getColor('systemGrey', themeMode);
    }
  }
}
