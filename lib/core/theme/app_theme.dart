import 'package:flutter/material.dart';
import 'package:pm25_app/core/constants/app_colors.dart';

//更改背景顏色
class AppTheme {
  // 淺色主題配置
  static ThemeData buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.getColor('primary', AppThemeMode.light),
      scaffoldBackgroundColor:
          AppColors.getColor('background', AppThemeMode.light),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.getColor('surface', AppThemeMode.light),
        foregroundColor: AppColors.getColor('onSurface', AppThemeMode.light),
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.getColor('surface', AppThemeMode.light),
        elevation: 2,
      ),
      // 其他主題配置...
    );
  }

  // 深色主題配置
  static ThemeData buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.getColor('primary', AppThemeMode.dark),
      scaffoldBackgroundColor:
          AppColors.getColor('background', AppThemeMode.dark),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.getColor('surface', AppThemeMode.dark),
        foregroundColor: AppColors.getColor('onSurface', AppThemeMode.dark),
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.getColor('surface', AppThemeMode.dark),
        elevation: 2,
      ),
      // 其他主題配置...
    );
  }
}
