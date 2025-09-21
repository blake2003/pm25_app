import 'package:flutter/material.dart';
import 'package:pm25_app/core/loggers/log.dart';
import 'package:pm25_app/features/aqi/aqi_record＿model.dart';
import 'package:pm25_app/features/aqi/data/aqi_repository.dart';

/// 時間過濾選項
enum TimeFilterOption {
  oneHour('1小時', Duration(hours: 1)),
  threeHours('3小時', Duration(hours: 4)),
  sixHours('6小時', Duration(hours: 7)),
  twelveHours('12小時', Duration(hours: 13));

  const TimeFilterOption(this.label, this.duration);

  final String label;
  final Duration? duration;

  /// 獲取時間範圍描述
  String get timeRangeDescription {
    if (duration == null) return '顯示所有資料';
    return '顯示最近$label的資料';
  }
}

class AqiProvider extends ChangeNotifier {
  AqiProvider({AqiRepository? repository})
      : _repo = repository ?? AqiRepository();

  final AqiRepository _repo;

  List<AqiRecord> _records = [];
  bool _loading = false;
  String? _error;
  TimeFilterOption _selectedTimeFilter = TimeFilterOption.threeHours; // 預設3小時

  List<AqiRecord> get records => _records;
  bool get isLoading => _loading;
  String? get error => _error;
  TimeFilterOption get selectedTimeFilter => _selectedTimeFilter;

  /// 切換時間過濾選項
  void setTimeFilter(TimeFilterOption option) {
    if (_selectedTimeFilter != option) {
      _selectedTimeFilter = option;
      final log = AppLogger('AqiProvider');
      log.i('切換時間過濾選項: ${option.label}');
      notifyListeners();
    }
  }

  /// 獲取所有可用的時間過濾選項
  List<TimeFilterOption> get availableTimeFilters => TimeFilterOption.values;

  /// 獲取根據時間過濾的資料
  List<AqiRecord> get filteredRecords {
    final log = AppLogger('AqiProvider');

    if (_records.isEmpty) {
      log.d('沒有原始資料可過濾');
      return [];
    }

    // 記錄原始資料的時間範圍
    final sortedRecords = List<AqiRecord>.from(_records)
      ..sort((a, b) => a.datacreationdate.compareTo(b.datacreationdate));

    if (sortedRecords.isNotEmpty) {
      final earliest = sortedRecords.first.datacreationdate;
      final latest = sortedRecords.last.datacreationdate;
      log.d('原始資料時間範圍: ${_formatTime(earliest)} - ${_formatTime(latest)}');
      log.d('過濾條件: ${_selectedTimeFilter.label}');
      if (_selectedTimeFilter.duration != null) {
        final filterTime =
            DateTime.now().subtract(_selectedTimeFilter.duration!);
        log.d('只顯示 ${_formatTime(filterTime)} 之後的資料');
      } else {
        log.d('顯示所有資料');
      }
    }

    List<AqiRecord> filteredRecords;

    if (_selectedTimeFilter.duration != null) {
      // 時間過濾模式：只顯示指定時間範圍內的資料
      final filterTime = DateTime.now().subtract(_selectedTimeFilter.duration!);
      filteredRecords = _records
          .where((record) => record.datacreationdate.isAfter(filterTime))
          .toList();
    } else {
      // 全部資料模式：顯示所有資料
      filteredRecords = List<AqiRecord>.from(_records);
    }

    log.d('過濾前資料數量: ${_records.length} 筆');
    log.d('過濾後資料數量: ${filteredRecords.length} 筆');

    // 如果過濾後資料太少，顯示警告
    if (_selectedTimeFilter.duration != null &&
        filteredRecords.length < _records.length * 0.3) {
      log.w('⚠️ 時間過濾後資料數量明顯減少，建議選擇更長的時間範圍或顯示全部資料');
    }

    return filteredRecords;
  }

  /// 獲取最近三個小時的資料（保持向後相容）
  @Deprecated('使用 filteredRecords 替代')
  List<AqiRecord> get recentThreeHoursRecords => filteredRecords;

  /// 獲取過濾後資料數量
  int get filteredRecordsCount => filteredRecords.length;

  /// 獲取過濾後資料的平均 PM2.5 值
  double get filteredRecordsAveragePm25 {
    if (filteredRecords.isEmpty) return 0.0;

    final total = filteredRecords
        .map((record) => record.pm25)
        .fold(0, (sum, pm25) => sum + pm25);

    return total / filteredRecords.length;
  }

  /// 獲取過濾後資料的時間範圍
  String get filteredRecordsTimeRange {
    if (filteredRecords.isEmpty) return '暫無資料';

    final sortedRecords = List<AqiRecord>.from(filteredRecords)
      ..sort((a, b) => a.datacreationdate.compareTo(b.datacreationdate));

    final earliest = sortedRecords.first.datacreationdate;
    final latest = sortedRecords.last.datacreationdate;

    return '${_formatTime(earliest)} - ${_formatTime(latest)}';
  }

  /// 獲取所有資料的時間範圍（用於除錯）
  String get allRecordsTimeRange {
    if (_records.isEmpty) return '暫無資料';

    final sortedRecords = List<AqiRecord>.from(_records)
      ..sort((a, b) => a.datacreationdate.compareTo(b.datacreationdate));

    final earliest = sortedRecords.first.datacreationdate;
    final latest = sortedRecords.last.datacreationdate;

    return '${_formatTime(earliest)} - ${_formatTime(latest)}';
  }

  /// 檢查記錄是否在選定的時間範圍內
  bool isRecordInSelectedTimeRange(AqiRecord record) {
    if (_selectedTimeFilter.duration == null) return true;

    final now = DateTime.now();
    final filterTime = now.subtract(_selectedTimeFilter.duration!);
    return record.datacreationdate.isAfter(filterTime);
  }

  /// 檢查記錄是否在最近三小時內（保持向後相容）
  @Deprecated('使用 isRecordInSelectedTimeRange 替代')
  bool isRecordRecent(AqiRecord record) {
    final now = DateTime.now();
    final threeHoursAgo = now.subtract(const Duration(hours: 3));
    return record.datacreationdate.isAfter(threeHoursAgo);
  }

  /// 獲取選定時間範圍的描述
  String get selectedTimeRangeDescription =>
      _selectedTimeFilter.timeRangeDescription;

  /// 測試用：設定測試資料
  @visibleForTesting
  void setTestData(List<AqiRecord> testRecords) {
    _records = testRecords;
    notifyListeners();
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
      log.i('資料時間範圍: $allRecordsTimeRange');

      // 檢查資料的時間分布
      if (data.isNotEmpty) {
        final now = DateTime.now();
        final threeHoursAgo = now.subtract(const Duration(hours: 3));
        final recentCount =
            data.where((r) => r.datacreationdate.isAfter(threeHoursAgo)).length;
        log.i('最近三小時內資料: $recentCount 筆');
        log.i('超過三小時資料: ${data.length - recentCount} 筆');

        // 根據選定的時間過濾檢查資料分布
        if (_selectedTimeFilter.duration != null) {
          final filterTime = now.subtract(_selectedTimeFilter.duration!);
          final filteredCount =
              data.where((r) => r.datacreationdate.isAfter(filterTime)).length;
          log.i('${_selectedTimeFilter.label}內資料: $filteredCount 筆');
          log.i(
              '超過${_selectedTimeFilter.label}資料: ${data.length - filteredCount} 筆');
        }
      }
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
