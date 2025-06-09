import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// 全域日誌系統設定：初始化 Logger 並監聽所有 Log 訊息
void setupGlobalLogging() {
  // 針對開發與生產環境，可以分別設定不同的日誌層級
  Logger.root.level = kDebugMode ? Level.ALL : Level.WARNING;

  Logger.root.onRecord.listen((record) {
    final logBuffer = StringBuffer();
    logBuffer.write('[${record.level.name}] ${record.time}: ${record.message}');

    // 如果有錯誤訊息，則一併輸出
    if (record.error != null) {
      logBuffer.write(' | ERROR: ${record.error}');
    }
    // 如果有堆疊追蹤，則一併輸出
    if (record.stackTrace != null) {
      logBuffer.write(' | STACK: ${record.stackTrace}');
    }

    // 使用 debugPrint 輸出完整日誌
    debugPrint(logBuffer.toString());

    // 當是嚴重錯誤時，可在這裡加入上傳遠端錯誤分析平台的邏輯
    if (record.level == Level.SEVERE) {
      // TODO: 將錯誤資訊上傳到遠端錯誤分析平台，例如 Firebase Crashlytics
      // FirebaseCrashlytics.instance.recordError(record.error, record.stackTrace, fatal: true);
    }
  });
}
