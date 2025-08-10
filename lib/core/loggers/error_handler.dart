// error_handler.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pm25_app/core/loggers/log.dart';

/// 全域錯誤處理：攔截 Flutter 以及 Dart 層級的未捕捉錯誤
void setupGlobalErrorHandlers() {
  final log = AppLogger('GlobalError');

  FlutterError.onError = (FlutterErrorDetails details) {
    log.e('Unhandled Flutter error', details.exception, details.stack);
  };

  runZonedGuarded(() {
    // 此區塊可以放任何需要在 runApp 前執行的邏輯
  }, (error, stackTrace) {
    log.e('Unhandled Dart error', error, stackTrace);
  });
}
