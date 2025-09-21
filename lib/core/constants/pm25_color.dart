import 'package:flutter/cupertino.dart';

/// PM2.5 顏色和等級常數
class PM25Color {
  /// 根據 PM2.5 數值獲取顏色
  ///
  /// [pm25] PM2.5 數值
  /// 返回對應的顏色
  static Color getPm25Color(int pm25) {
    if (pm25 <= 12) return CupertinoColors.systemGreen;
    if (pm25 <= 35) return CupertinoColors.systemYellow;
    if (pm25 <= 55) return CupertinoColors.systemOrange;
    if (pm25 <= 150) return CupertinoColors.systemRed;
    return CupertinoColors.systemPurple;
  }

  /// 根據 PM2.5 數值獲取等級
  ///
  /// [pm25] PM2.5 數值
  /// 返回對應的等級描述
  static String getPm25Level(int pm25) {
    if (pm25 <= 12) return '良好';
    if (pm25 <= 35) return '普通';
    if (pm25 <= 55) return '對敏感族群不健康';
    if (pm25 <= 150) return '對所有族群不健康';
    return '非常不健康';
  }

  /// 根據 PM2.5 數值獲取等級代碼
  ///
  /// [pm25] PM2.5 數值
  /// 返回等級代碼 (1-5)
  static int getPm25LevelCode(int pm25) {
    if (pm25 <= 12) return 1;
    if (pm25 <= 35) return 2;
    if (pm25 <= 55) return 3;
    if (pm25 <= 150) return 4;
    return 5;
  }

  /// 根據 PM2.5 數值獲取建議
  ///
  /// [pm25] PM2.5 數值
  /// 返回對應的建議
  static String getPm25Advice(int pm25) {
    if (pm25 <= 12) return '空氣品質良好，適合戶外活動';
    if (pm25 <= 35) return '空氣品質普通，一般民眾可正常活動';
    if (pm25 <= 55) return '敏感族群應減少戶外活動';
    if (pm25 <= 150) return '所有族群應減少戶外活動';
    return '應避免戶外活動，必要時請戴口罩';
  }

  /// 檢查 PM2.5 數值是否有效
  ///
  /// [pm25] PM2.5 數值
  /// 返回是否為有效數值
  static bool isValidPm25(int pm25) {
    return pm25 >= 0 && pm25 <= 500; // 假設有效範圍為 0-500
  }
}
