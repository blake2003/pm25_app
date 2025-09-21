import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pm25_app/core/constants/theme/theme_colors.dart';

/// 應用程式主題配置管理
/// 集中管理所有主題相關的配置，提供完整的 Material 和 Cupertino 主題支援
class AppTheme {
  // 淺色主題配置
  static ThemeData buildLightTheme([AppThemeMode? resolvedThemeMode]) {
    // 使用解析後的主題模式，如果沒有提供則使用淺色主題
    final themeMode = resolvedThemeMode ?? AppThemeMode.light;

    return ThemeData(
      // 基礎配置
      brightness: Brightness.light,
      useMaterial3: true,

      // 色彩配置
      primaryColor: AppColors.getColor('primary', themeMode),
      scaffoldBackgroundColor: AppColors.getColor('background', themeMode),

      // AppBar 主題
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.getColor('surface', themeMode),
        foregroundColor: AppColors.getColor('onSurface', themeMode),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.getColor('textPrimary', themeMode),
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: AppColors.getColor('primary', themeMode),
        ),
      ),

      // 卡片主題
      cardTheme: CardThemeData(
        color: AppColors.getColor('card', themeMode),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // 文字主題
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: AppColors.getColor('textPrimary', themeMode),
          fontSize: 34,
          fontWeight: FontWeight.w700,
        ),
        displayMedium: TextStyle(
          color: AppColors.getColor('textPrimary', themeMode),
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        displaySmall: TextStyle(
          color: AppColors.getColor('textPrimary', themeMode),
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color: AppColors.getColor('textPrimary', themeMode),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: AppColors.getColor('textPrimary', themeMode),
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: AppColors.getColor('textPrimary', themeMode),
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.getColor('textPrimary', themeMode),
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: AppColors.getColor('textPrimary', themeMode),
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: AppColors.getColor('textSecondary', themeMode),
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: AppColors.getColor('label', themeMode),
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: AppColors.getColor('label', themeMode),
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: TextStyle(
          color: AppColors.getColor('label', themeMode),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),

      // 按鈕主題
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.getColor('primary', themeMode),
          foregroundColor: AppColors.getColor('onPrimary', themeMode),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // 輸入框主題
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.getColor('surface', themeMode),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.getColor('border', themeMode),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.getColor('border', themeMode),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.getColor('primary', themeMode),
            width: 2,
          ),
        ),
        labelStyle: TextStyle(
          color: AppColors.getColor('textSecondary', themeMode),
        ),
      ),

      // 分割線主題
      dividerTheme: DividerThemeData(
        color: AppColors.getColor('separator', themeMode),
        thickness: 0.5,
        space: 1,
      ),

      // 圖示主題
      iconTheme: IconThemeData(
        color: AppColors.getColor('primary', themeMode),
        size: 24,
      ),
    );
  }

  // 深色主題配置
  static ThemeData buildDarkTheme([AppThemeMode? resolvedThemeMode]) {
    // 使用解析後的主題模式，如果沒有提供則使用深色主題
    final themeMode = resolvedThemeMode ?? AppThemeMode.dark;

    return ThemeData(
      // 基礎配置
      brightness: Brightness.dark,
      useMaterial3: true,

      // 色彩配置
      primaryColor: AppColors.getColor('primary', themeMode),
      scaffoldBackgroundColor: AppColors.getColor('background', themeMode),

      // AppBar 主題
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.getColor('surface', themeMode),
        foregroundColor: AppColors.getColor('onSurface', themeMode),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.getColor('textPrimary', themeMode),
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: AppColors.getColor('primary', themeMode),
        ),
      ),

      // 卡片主題
      cardTheme: CardThemeData(
        color: AppColors.getColor('card', themeMode),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // 文字主題
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: AppColors.getColor('textPrimary', themeMode),
          fontSize: 34,
          fontWeight: FontWeight.w700,
        ),
        displayMedium: TextStyle(
          color: AppColors.getColor('textPrimary', themeMode),
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        displaySmall: TextStyle(
          color: AppColors.getColor('textPrimary', themeMode),
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color: AppColors.getColor('textPrimary', themeMode),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: AppColors.getColor('textPrimary', themeMode),
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: AppColors.getColor('textPrimary', themeMode),
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.getColor('textPrimary', themeMode),
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: AppColors.getColor('textPrimary', themeMode),
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: AppColors.getColor('textSecondary', themeMode),
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: AppColors.getColor('label', themeMode),
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: AppColors.getColor('label', themeMode),
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: TextStyle(
          color: AppColors.getColor('label', themeMode),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),

      // 按鈕主題
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.getColor('primary', themeMode),
          foregroundColor: AppColors.getColor('onPrimary', themeMode),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // 輸入框主題
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.getColor('surface', themeMode),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.getColor('border', themeMode),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.getColor('border', themeMode),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.getColor('primary', themeMode),
            width: 2,
          ),
        ),
        labelStyle: TextStyle(
          color: AppColors.getColor('textSecondary', themeMode),
        ),
      ),

      // 分割線主題
      dividerTheme: DividerThemeData(
        color: AppColors.getColor('separator', themeMode),
        thickness: 0.5,
        space: 1,
      ),

      // 圖示主題
      iconTheme: IconThemeData(
        color: AppColors.getColor('primary', themeMode),
        size: 24,
      ),
    );
  }

  /// Cupertino 淺色主題配置
  /// 提供 iOS 原生風格的主題配置
  static CupertinoThemeData buildCupertinoLightTheme() {
    return CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.getColor('primary', AppThemeMode.light),
      scaffoldBackgroundColor:
          AppColors.getColor('background', AppThemeMode.light),
      textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(
          color: AppColors.getColor('textPrimary', AppThemeMode.light),
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
        actionTextStyle: TextStyle(
          color: AppColors.getColor('primary', AppThemeMode.light),
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        tabLabelTextStyle: TextStyle(
          color: AppColors.getColor('textSecondary', AppThemeMode.light),
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  /// Cupertino 深色主題配置
  /// 提供 iOS 原生風格的深色主題配置
  static CupertinoThemeData buildCupertinoDarkTheme() {
    return CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.getColor('primary', AppThemeMode.dark),
      scaffoldBackgroundColor:
          AppColors.getColor('background', AppThemeMode.dark),
      textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(
          color: AppColors.getColor('textPrimary', AppThemeMode.dark),
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
        actionTextStyle: TextStyle(
          color: AppColors.getColor('primary', AppThemeMode.dark),
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        tabLabelTextStyle: TextStyle(
          color: AppColors.getColor('textSecondary', AppThemeMode.dark),
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  /// 根據主題模式獲取對應的 Cupertino 主題
  ///
  /// [themeMode] 主題模式
  /// 返回對應的 Cupertino 主題配置
  static CupertinoThemeData getCupertinoTheme(AppThemeMode themeMode) {
    switch (themeMode) {
      case AppThemeMode.light:
        return buildCupertinoLightTheme();
      case AppThemeMode.dark:
        return buildCupertinoDarkTheme();
      case AppThemeMode.auto:
        // 自動模式需要根據當前時間判斷，但這裡無法獲取當前時間
        // 因此返回淺色主題作為預設，實際的主題判斷會在 ThemeProvider 中處理
        return buildCupertinoLightTheme();
    }
  }

  /// 根據主題模式和解析後的主題獲取對應的 Cupertino 主題
  /// 這個方法用於處理自動模式，需要傳入解析後的主題模式
  ///
  /// [themeMode] 主題模式
  /// [resolvedThemeMode] 可選的解析後主題模式，用於自動模式
  /// 返回對應的 Cupertino 主題配置
  static CupertinoThemeData getCupertinoThemeWithResolved(
      AppThemeMode themeMode,
      [AppThemeMode? resolvedThemeMode]) {
    // 如果是自動模式且有解析後的主題模式，使用解析後的主題模式
    final actualThemeMode =
        (themeMode == AppThemeMode.auto && resolvedThemeMode != null)
            ? resolvedThemeMode
            : themeMode;
    return getCupertinoTheme(actualThemeMode);
  }
}
