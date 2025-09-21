import 'package:flutter/material.dart';
import 'package:pm25_app/core/constants/language/l10n/app_localizations.dart';

/// 應用程式主題模式枚舉
enum AppThemeMode {
  light,
  dark,
  auto;

  @override
  String toString() {
    switch (this) {
      case AppThemeMode.light:
        return '淺色';
      case AppThemeMode.dark:
        return '深色';
      case AppThemeMode.auto:
        return '自動';
    }
  }

  /// 獲取本地化的主題模式描述
  ///
  /// [context] BuildContext 用於獲取本地化
  /// 返回對應的本地化描述
  String getLocalizedDescription(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    switch (this) {
      case AppThemeMode.light:
        return localizations?.light ?? '淺色';
      case AppThemeMode.dark:
        return localizations?.dark ?? '深色';
      case AppThemeMode.auto:
        return localizations?.auto ?? '自動';
    }
  }
}

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
    // 基礎色彩
    'background': Color(0xFFF2F2F7), // iOS Light Gray Background
    'surface': Color(0xFFFFFFFF), // iOS White Surface
    'card': Color(0xFFFFFFFF), // Card Background

    // 主要色彩
    'primary': Color(0xFF007AFF), // iOS Blue
    'secondary': Color(0xFF5856D6), // iOS Purple
    'success': Color(0xFF34C759), // iOS Green
    'warning': Color(0xFFFF9500), // iOS Orange
    'error': Color(0xFFFF3B30), // iOS Red

    // 文字色彩
    'onBackground': Color(0xFF000000), // Black on Light Background
    'onSurface': Color(0xFF1C1C1E), // Dark Gray on Surface
    'onPrimary': Color(0xFFFFFFFF), // White on Primary
    'onSecondary': Color(0xFFFFFFFF), // White on Secondary
    'textPrimary': Color(0xFF000000), // Primary Text
    'textSecondary': Color(0xFF8E8E93), // Secondary Text
    'textTertiary': Color(0xFFC7C7CC), // Tertiary Text
    'label': Color(0xFF000000), // Label Text

    // 系統灰色系
    'systemGrey': Color(0xFF8E8E93), // System Grey
    'systemGrey2': Color(0xFFAEAEB2), // System Grey 2
    'systemGrey3': Color(0xFFC7C7CC), // System Grey 3
    'systemGrey4': Color(0xFFD1D1D6), // System Grey 4
    'systemGrey5': Color(0xFFE5E5EA), // System Grey 5
    'systemGrey6': Color(0xFFF2F2F7), // System Grey 6

    // 分隔線和邊框
    'separator': Color(0xFFC6C6C8), // Separator Color
    'border': Color(0xFFC7C7CC), // Border Color

    // 特殊狀態
    'disabled': Color(0xFFC7C7CC), // Disabled State
    'overlay': Color(0x80000000), // Overlay Color
  };

  // 深色主題色彩
  static const Map<String, Color> darkTheme = {
    // 基礎色彩
    'background': Color(0xFF000000), // iOS Black Background
    'surface': Color(0xFF1C1C1E), // iOS Dark Surface
    'card': Color(0xFF2C2C2E), // Card Background

    // 主要色彩
    'primary': Color(0xFF0A84FF), // iOS Blue (Dark)
    'secondary': Color(0xFF5E5CE6), // iOS Purple (Dark)
    'success': Color(0xFF30D158), // iOS Green (Dark)
    'warning': Color(0xFFFF9F0A), // iOS Orange (Dark)
    'error': Color(0xFFFF453A), // iOS Red (Dark)

    // 文字色彩
    'onBackground': Color(0xFFFFFFFF), // White on Dark Background
    'onSurface': Color(0xFFFFFFFF), // White on Surface
    'onPrimary': Color(0xFF000000), // Black on Primary
    'onSecondary': Color(0xFF000000), // Black on Secondary
    'textPrimary': Color(0xFFFFFFFF), // Primary Text
    'textSecondary': Color(0xFF8E8E93), // Secondary Text
    'textTertiary': Color(0xFF48484A), // Tertiary Text
    'label': Color(0xFFFFFFFF), // Label Text

    // 系統灰色系
    'systemGrey': Color(0xFF8E8E93), // System Grey
    'systemGrey2': Color(0xFF636366), // System Grey 2
    'systemGrey3': Color(0xFF48484A), // System Grey 3
    'systemGrey4': Color(0xFF3A3A3C), // System Grey 4
    'systemGrey5': Color(0xFF2C2C2E), // System Grey 5
    'systemGrey6': Color(0xFF1C1C1E), // System Grey 6

    // 分隔線和邊框
    'separator': Color(0xFF38383A), // Separator Color
    'border': Color(0xFF38383A), // Border Color

    // 特殊狀態
    'disabled': Color(0xFF48484A), // Disabled State
    'overlay': Color(0x80FFFFFF), // Overlay Color
  };

  /// 根據主題模式獲取色彩
  ///
  /// [colorKey] 色彩鍵值
  /// [themeMode] 主題模式
  /// [resolvedThemeMode] 可選的解析後主題模式，用於自動模式
  /// 返回對應主題的色彩，如果找不到則返回預設色彩
  static Color getColor(String colorKey, AppThemeMode themeMode,
      [AppThemeMode? resolvedThemeMode]) {
    // 如果是自動模式且有解析後的主題模式，使用解析後的主題模式
    final actualThemeMode =
        (themeMode == AppThemeMode.auto && resolvedThemeMode != null)
            ? resolvedThemeMode
            : themeMode;

    final colors =
        actualThemeMode == AppThemeMode.dark ? darkTheme : lightTheme;
    return colors[colorKey] ?? colors['onBackground']!;
  }

  /// 獲取文字顏色（根據主題模式）
  ///
  /// [textType] 文字類型：primary, secondary, tertiary, label
  /// [themeMode] 主題模式
  /// [resolvedThemeMode] 可選的解析後主題模式，用於自動模式
  /// 返回對應的文字色彩
  static Color getTextColor(String textType, AppThemeMode themeMode,
      [AppThemeMode? resolvedThemeMode]) {
    switch (textType) {
      case 'primary':
        return getColor('textPrimary', themeMode, resolvedThemeMode);
      case 'secondary':
        return getColor('textSecondary', themeMode, resolvedThemeMode);
      case 'tertiary':
        return getColor('textTertiary', themeMode, resolvedThemeMode);
      case 'label':
        return getColor('label', themeMode, resolvedThemeMode);
      default:
        return getColor('textPrimary', themeMode, resolvedThemeMode);
    }
  }

  /// 獲取系統顏色（根據主題模式）
  ///
  /// [colorType] 系統顏色類型
  /// [themeMode] 主題模式
  /// [resolvedThemeMode] 可選的解析後主題模式，用於自動模式
  /// 返回對應的系統色彩
  static Color getSystemColor(String colorType, AppThemeMode themeMode,
      [AppThemeMode? resolvedThemeMode]) {
    switch (colorType) {
      case 'systemGrey':
        return getColor('systemGrey', themeMode, resolvedThemeMode);
      case 'systemGrey2':
        return getColor('systemGrey2', themeMode, resolvedThemeMode);
      case 'systemGrey3':
        return getColor('systemGrey3', themeMode, resolvedThemeMode);
      case 'systemGrey4':
        return getColor('systemGrey4', themeMode, resolvedThemeMode);
      case 'systemGrey5':
        return getColor('systemGrey5', themeMode, resolvedThemeMode);
      case 'systemGrey6':
        return getColor('systemGrey6', themeMode, resolvedThemeMode);
      default:
        return getColor('systemGrey', themeMode, resolvedThemeMode);
    }
  }

  /// 獲取主題模式描述文字
  ///
  /// [themeMode] 主題模式
  /// 返回對應的中文描述
  static String getThemeModeDescription(AppThemeMode themeMode) {
    switch (themeMode) {
      case AppThemeMode.light:
        return '淺色';
      case AppThemeMode.dark:
        return '深色';
      case AppThemeMode.auto:
        return '自動';
    }
  }

  /// 獲取本地化的主題模式描述文字
  ///
  /// [themeMode] 主題模式
  /// [context] BuildContext 用於獲取本地化
  /// 返回對應的本地化描述
  static String getLocalizedThemeModeDescription(
      AppThemeMode themeMode, BuildContext context) {
    return themeMode.getLocalizedDescription(context);
  }

  /// 檢查色彩對比度是否符合 WCAG AA 標準
  ///
  /// [foreground] 前景色彩
  /// [background] 背景色彩
  /// 返回是否符合 AA 標準（對比度 >= 4.5:1）
  static bool isWcagAACompliant(Color foreground, Color background) {
    // 簡化的對比度計算
    final luminance1 = foreground.computeLuminance();
    final luminance2 = background.computeLuminance();

    final brightest = luminance1 > luminance2 ? luminance1 : luminance2;
    final darkest = luminance1 > luminance2 ? luminance2 : luminance1;

    final contrast = (brightest + 0.05) / (darkest + 0.05);
    return contrast >= 4.5;
  }
}
