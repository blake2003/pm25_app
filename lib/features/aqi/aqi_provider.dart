import 'package:flutter/material.dart';
import 'package:pm25_app/core/loggers/log.dart';
import 'package:pm25_app/features/aqi/aqi_record＿model.dart';
import 'package:pm25_app/features/aqi/data/aqi_repository.dart';

class AqiProvider extends ChangeNotifier {
  AqiProvider({AqiRepository? repository})
      : _repo = repository ?? AqiRepository();

  final AqiRepository _repo;

  List<AqiRecord> _records = [];
  bool _loading = false;
  String? _error;

  List<AqiRecord> get records => _records;
  bool get isLoading => _loading;
  String? get error => _error;

  /// 獲取最近三個小時的資料
  List<AqiRecord> get recentThreeHoursRecords {
    final now = DateTime.now();
    final threeHoursAgo = now.subtract(const Duration(hours: 3));

    return _records
        .where((record) => record.datacreationdate.isAfter(threeHoursAgo))
        .toList();
  }

  /// 獲取最近三個小時的資料數量
  int get recentThreeHoursCount => recentThreeHoursRecords.length;

  /// 獲取最近三個小時的平均 PM2.5 值
  double get recentThreeHoursAveragePm25 {
    if (recentThreeHoursRecords.isEmpty) return 0.0;

    final total = recentThreeHoursRecords
        .map((record) => record.pm25)
        .fold(0, (sum, pm25) => sum + pm25);

    return total / recentThreeHoursRecords.length;
  }

  /// 獲取最近三個小時的資料時間範圍
  String get recentThreeHoursTimeRange {
    if (recentThreeHoursRecords.isEmpty) return '暫無資料';

    final sortedRecords = List<AqiRecord>.from(recentThreeHoursRecords)
      ..sort((a, b) => a.datacreationdate.compareTo(b.datacreationdate));

    final earliest = sortedRecords.first.datacreationdate;
    final latest = sortedRecords.last.datacreationdate;

    return '${_formatTime(earliest)} - ${_formatTime(latest)}';
  }

  /// 格式化時間為 HH:mm 格式
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> loadAqi(String site) async {
    final log = AppLogger('AqiProvider');
    log.i('開始載入 $site 站點資料');

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _repo.getSiteAqi(site);
      _records = data;
      log.i('成功載入 $site 站點資料: ${data.length} 筆');
    } catch (e) {
      _records = [];
      _error = e.toString();
      log.e('載入 $site 站點資料失敗: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
