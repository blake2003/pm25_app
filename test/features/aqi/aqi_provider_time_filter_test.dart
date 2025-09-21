import 'package:flutter_test/flutter_test.dart';
import 'package:pm25_app/features/aqi/aqi_provider.dart';
import 'package:pm25_app/features/aqi/aqi_record＿model.dart';

void main() {
  group('AQIProvider 時間過濾測試', () {
    late AqiProvider provider;
    late List<AqiRecord> testRecords;

    setUp(() {
      provider = AqiProvider();

      // 建立測試資料：包含最近和較舊的記錄
      final now = DateTime.now();
      testRecords = [
        AqiRecord(
          site: '測試站點',
          county: '測試縣市',
          pm25: 15,
          datacreationdate: now.subtract(const Duration(minutes: 30)), // 30分鐘前
          itemunit: 'μg/m3',
        ),
        AqiRecord(
          site: '測試站點',
          county: '測試縣市',
          pm25: 20,
          datacreationdate: now.subtract(const Duration(hours: 2)), // 2小時前
          itemunit: 'μg/m3',
        ),
        AqiRecord(
          site: '測試站點',
          county: '測試縣市',
          pm25: 25,
          datacreationdate: now.subtract(const Duration(hours: 4)), // 4小時前
          itemunit: 'μg/m3',
        ),
        AqiRecord(
          site: '測試站點',
          county: '測試縣市',
          pm25: 30,
          datacreationdate: now.subtract(const Duration(hours: 6)), // 6小時前
          itemunit: 'μg/m3',
        ),
      ];
    });

    test('預設為3小時時間過濾', () {
      expect(provider.selectedTimeFilter, TimeFilterOption.threeHours);
    });

    test('可以切換時間過濾選項', () {
      expect(provider.selectedTimeFilter, TimeFilterOption.threeHours);

      provider.setTimeFilter(TimeFilterOption.oneHour);
      expect(provider.selectedTimeFilter, TimeFilterOption.oneHour);

      provider.setTimeFilter(TimeFilterOption.twelveHours);
      expect(provider.selectedTimeFilter, TimeFilterOption.twelveHours);
    });

    test('1小時過濾模式下只顯示最近1小時的資料', () {
      // 模擬載入資料
      provider.loadAqi('測試站點');

      // 手動設定測試資料
      provider.setTestData(testRecords);

      // 切換到1小時模式
      provider.setTimeFilter(TimeFilterOption.oneHour);

      expect(provider.selectedTimeFilter, TimeFilterOption.oneHour);
      expect(provider.filteredRecords.length, 1); // 只顯示1小時前的資料
      expect(provider.filteredRecordsCount, 1);
    });

    test('3小時過濾模式下只顯示最近3小時的資料', () {
      // 模擬載入資料
      provider.loadAqi('測試站點');

      // 手動設定測試資料
      provider.setTestData(testRecords);

      expect(provider.selectedTimeFilter, TimeFilterOption.threeHours);
      expect(provider.filteredRecords.length, 2); // 只顯示1小時和2小時前的資料
      expect(provider.filteredRecordsCount, 2);
    });

    test('6小時過濾模式下顯示最近6小時的資料', () {
      // 模擬載入資料
      provider.loadAqi('測試站點');

      // 手動設定測試資料
      provider.setTestData(testRecords);

      // 切換到6小時模式
      provider.setTimeFilter(TimeFilterOption.sixHours);

      expect(provider.selectedTimeFilter, TimeFilterOption.sixHours);
      expect(provider.filteredRecords.length, 3); // 顯示1、2、4小時前的資料
      expect(provider.filteredRecordsCount, 3);
    });

    test('全部資料模式下顯示所有資料', () {
      // 模擬載入資料
      provider.loadAqi('測試站點');

      // 手動設定測試資料
      provider.setTestData(testRecords);

      // 切換到全部資料模式
      provider.setTimeFilter(TimeFilterOption.twelveHours);

      expect(provider.selectedTimeFilter, TimeFilterOption.twelveHours);
      expect(provider.filteredRecords.length, 4); // 顯示所有資料
      expect(provider.filteredRecordsCount, 4);
    });

    test('isRecordInSelectedTimeRange 正確判斷記錄時間', () {
      final now = DateTime.now();
      final recentRecord = AqiRecord(
        site: '測試站點',
        county: '測試縣市',
        pm25: 15,
        datacreationdate: now.subtract(const Duration(hours: 1)),
        itemunit: 'μg/m3',
      );

      final oldRecord = AqiRecord(
        site: '測試站點',
        county: '測試縣市',
        pm25: 30,
        datacreationdate: now.subtract(const Duration(hours: 5)),
        itemunit: 'μg/m3',
      );

      // 預設3小時模式
      expect(provider.isRecordInSelectedTimeRange(recentRecord), isTrue);
      expect(provider.isRecordInSelectedTimeRange(oldRecord), isFalse);

      // 切換到6小時模式
      provider.setTimeFilter(TimeFilterOption.sixHours);
      expect(provider.isRecordInSelectedTimeRange(recentRecord), isTrue);
      expect(provider.isRecordInSelectedTimeRange(oldRecord), isTrue);

      // 切換到全部資料模式
      provider.setTimeFilter(TimeFilterOption.twelveHours);
      expect(provider.isRecordInSelectedTimeRange(recentRecord), isTrue);
      expect(provider.isRecordInSelectedTimeRange(oldRecord), isTrue);
    });

    test('時間範圍計算正確', () {
      // 模擬載入資料
      provider.loadAqi('測試站點');

      // 手動設定測試資料
      provider.setTestData(testRecords);

      final timeRange = provider.filteredRecordsTimeRange;
      expect(timeRange, isNotEmpty);
      expect(timeRange, isNot('暫無資料'));
    });

    test('可用的時間過濾選項包含所有選項', () {
      final availableFilters = provider.availableTimeFilters;
      expect(availableFilters.length, TimeFilterOption.values.length);
      expect(availableFilters, contains(TimeFilterOption.threeHours));
      expect(availableFilters, contains(TimeFilterOption.twelveHours));
    });

    test('時間範圍描述正確', () {
      expect(TimeFilterOption.oneHour.timeRangeDescription, '顯示最近1小時的資料');
      expect(TimeFilterOption.threeHours.timeRangeDescription, '顯示最近3小時的資料');
      expect(TimeFilterOption.twelveHours.timeRangeDescription, '顯示所有資料');
    });
  });
}
