import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/foundation.dart'; // kDebugMode
import 'package:logging/logging.dart';

class AppLogger {
  factory AppLogger(String name) =>
      _cache.putIfAbsent(name, () => AppLogger._internal(name));

  AppLogger._internal(this._name) : _logger = Logger(_name);

  final String _name;
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

    // ---------- ❶ 建立各層級對應的彩色筆 ----------
    final levelPens = {
      Level.FINE: AnsiPen()..blue(),
      Level.INFO: AnsiPen()..green(),
      Level.WARNING: AnsiPen()..yellow(bold: true),
      Level.SEVERE: AnsiPen()..red(bold: true),
      Level.SHOUT: AnsiPen()..red(bg: true, bold: true),
    };

    // ---------- ❷ 監聽日誌 ----------
    Logger.root.onRecord.listen((rec) {
      ansiColorDisabled = !kDebugMode;
      final time = rec.time.toIso8601String().substring(11, 23); // HH:mm:ss.SSS
      final pen = levelPens[rec.level] ?? AnsiPen();
      final line = pen('[${rec.level.name.padRight(7)}] $time '
          '${rec.loggerName}: ${rec.message}');
      if (kDebugMode) {
        // 開發環境：彩色文字
        debugPrint(line);
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
