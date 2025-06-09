// error_handler.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

/// 全域錯誤處理：攔截 Flutter 以及 Dart 層級的未捕捉錯誤
void setupGlobalErrorHandlers() {
  FlutterError.onError = (FlutterErrorDetails details) {
    Logger('GlobalError')
        .severe('Unhandled Flutter error', details.exception, details.stack);
  };

  runZonedGuarded(() {
    // 此區塊可以放任何需要在 runApp 前執行的邏輯
  }, (error, stackTrace) {
    Logger('GlobalError').severe('Unhandled Dart error', error, stackTrace);
  });
}
