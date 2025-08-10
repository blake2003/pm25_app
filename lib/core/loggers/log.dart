import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/foundation.dart'; // kDebugMode
import 'package:logging/logging.dart';

class AppLogger {
  factory AppLogger(String name) =>
      _cache.putIfAbsent(name, () => AppLogger._internal(name));

  AppLogger._internal(String name) : _logger = Logger(name);

  final Logger _logger;

  /* ------------------------------------------------------------------ */
  /* static helpers                                                     */
  /* ------------------------------------------------------------------ */
  static final _cache = <String, AppLogger>{};
  static bool _initialized = false;

  // 快捷呼叫
  void d(Object? msg) => _logger.fine(msg);
  void i(Object? msg) => _logger.info(msg);
  void w(Object? msg) => _logger.warning(msg);
  void e(Object? msg, [Object? err, StackTrace? st]) =>
      _logger.severe(msg, err, st);

  /// 在 main() 中最早呼叫一次
  static void init() {
    if (_initialized) return;
    _initialized = true;

    Logger.root.level = kDebugMode ? Level.ALL : Level.WARNING;
    hierarchicalLoggingEnabled = true;

    // 測試 ANSI 顏色支援
    print('=== 日誌系統初始化 ===');
    print('kDebugMode: $kDebugMode');
    print('ansiColorDisabled: $ansiColorDisabled');
    print('日誌層級: ${kDebugMode ? 'ALL' : 'WARNING'}');
    print('========================');

    // ---------- ❷ 監聽日誌 ----------
    Logger.root.onRecord.listen((rec) {
      final time = rec.time.toIso8601String().substring(11, 19); // HH:mm:ss
      final line =
          '[${rec.level.name}] $time ${rec.loggerName}: ${rec.message}';

      if (kDebugMode) {
        // 開發環境：純文字輸出
        print(line);
      }

      // SEVERE 以上可上傳遠端
      if (rec.level >= Level.SEVERE) {
        _upload(rec);
      }
    });
  }

  static Future<void> _upload(LogRecord r) async {
    // TODO: Crashlytics / Sentry / 自建 API
  }
}
