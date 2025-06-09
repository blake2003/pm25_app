import 'package:flutter/material.dart';

class AppColors {
  // 空气质量指数颜色
  static Color getAqiColor(double value) {
    if (value <= 15.4) return Colors.green;
    if (value <= 35.4) return Colors.yellow;
    if (value <= 54.4) return Colors.orange;
    if (value <= 150.4) return Colors.red;
    return Colors.purple;
  }
}
