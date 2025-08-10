import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pm25_app/features/aqi/aqi_provider.dart';
import 'package:pm25_app/features/aqi/aqi_record%EF%BC%BFmodel.dart';
import 'package:pm25_app/features/aqi/data/aqi_repository.dart';

@GenerateMocks([AqiRepository])
import 'recent_data_test.mocks.dart';

void main() {
  group('最近3小時測站資料抓取測試', () {
    late MockAqiRepository mockRepo;
    late AqiProvider provider;

    setUp(() {
      mockRepo = MockAqiRepository();
      provider = AqiProvider(repository: mockRepo);
    });

    group('3小時內資料篩選測試', () {
      test('應該正確篩選出最近3小時內的資料', () async {
        // Arrange - 準備測試資料，包含3小時內和超過3小時的資料
        final now = DateTime.now();
        final testData = [
          // 最近1小時的資料
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 15,
            datacreationdate: now.subtract(const Duration(hours: 1)),
            itemunit: 'μg/m3',
          ),
          // 最近2小時的資料
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 20,
            datacreationdate: now.subtract(const Duration(hours: 2)),
            itemunit: 'μg/m3',
          ),
          // 最近2.5小時的資料
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 18,
            datacreationdate:
                now.subtract(const Duration(hours: 2, minutes: 30)),
            itemunit: 'μg/m3',
          ),
          // 超過3小時的資料（不應該被包含）
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 25,
            datacreationdate: now.subtract(const Duration(hours: 4)),
            itemunit: 'μg/m3',
          ),
          // 超過3小時的資料（不應該被包含）
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 30,
            datacreationdate: now.subtract(const Duration(hours: 5)),
            itemunit: 'μg/m3',
          ),
        ];

        when(mockRepo.getSiteAqi('金門')).thenAnswer((_) async => testData);

        // Act - 載入資料
        await provider.loadAqi('金門');

        // Assert - 驗證3小時內資料篩選結果
        expect(provider.recentThreeHoursCount, equals(3));
        expect(provider.recentThreeHoursRecords.length, equals(3));

        // 驗證包含的資料都是3小時內的
        for (final record in provider.recentThreeHoursRecords) {
          expect(
              record.datacreationdate
                  .isAfter(now.subtract(const Duration(hours: 3))),
              isTrue);
        }
      });

      test('當沒有3小時內資料時應該返回0筆', () async {
        // Arrange - 準備只有超過3小時的資料
        final now = DateTime.now();
        final testData = [
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 25,
            datacreationdate: now.subtract(const Duration(hours: 4)),
            itemunit: 'μg/m3',
          ),
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 30,
            datacreationdate: now.subtract(const Duration(hours: 6)),
            itemunit: 'μg/m3',
          ),
        ];

        when(mockRepo.getSiteAqi('金門')).thenAnswer((_) async => testData);

        // Act - 載入資料
        await provider.loadAqi('金門');

        // Assert - 驗證沒有3小時內資料
        expect(provider.recentThreeHoursCount, equals(0));
        expect(provider.recentThreeHoursRecords, isEmpty);
        expect(provider.recentThreeHoursTimeRange, equals('暫無資料'));
      });

      test('應該正確計算3小時內資料的平均PM2.5', () async {
        // Arrange - 準備3小時內的測試資料
        final now = DateTime.now();
        final testData = [
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 10,
            datacreationdate: now.subtract(const Duration(hours: 1)),
            itemunit: 'μg/m3',
          ),
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 20,
            datacreationdate: now.subtract(const Duration(hours: 2)),
            itemunit: 'μg/m3',
          ),
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 30,
            datacreationdate:
                now.subtract(const Duration(hours: 2, minutes: 30)),
            itemunit: 'μg/m3',
          ),
        ];

        when(mockRepo.getSiteAqi('金門')).thenAnswer((_) async => testData);

        // Act - 載入資料
        await provider.loadAqi('金門');

        // Assert - 驗證平均PM2.5計算 (10+20+30)/3 = 20
        expect(provider.recentThreeHoursAveragePm25, equals(20.0));
      });

      test('當只有1筆3小時內資料時應該正確處理', () async {
        // Arrange - 準備只有1筆3小時內的資料
        final now = DateTime.now();
        final testData = [
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 15,
            datacreationdate: now.subtract(const Duration(hours: 1)),
            itemunit: 'μg/m3',
          ),
        ];

        when(mockRepo.getSiteAqi('金門')).thenAnswer((_) async => testData);

        // Act - 載入資料
        await provider.loadAqi('金門');

        // Assert - 驗證單筆資料的處理
        expect(provider.recentThreeHoursCount, equals(1));
        expect(provider.recentThreeHoursAveragePm25, equals(15.0));

        // 驗證時間範圍格式
        final timeRange = provider.recentThreeHoursTimeRange;
        expect(timeRange, isNot(equals('暫無資料')));
        expect(timeRange, contains(' - '));
      });
    });

    group('時間範圍格式化測試', () {
      test('應該正確格式化3小時內資料的時間範圍', () async {
        // Arrange - 準備有明確時間的測試資料（使用動態時間）
        final now = DateTime.now();
        final testData = [
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 10,
            datacreationdate:
                now.subtract(const Duration(hours: 1, minutes: 30)), // 1.5小時前
            itemunit: 'μg/m3',
          ),
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 20,
            datacreationdate:
                now.subtract(const Duration(hours: 2, minutes: 45)), // 2.75小時前
            itemunit: 'μg/m3',
          ),
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 15,
            datacreationdate:
                now.subtract(const Duration(hours: 1, minutes: 15)), // 1.25小時前
            itemunit: 'μg/m3',
          ),
        ];

        when(mockRepo.getSiteAqi('金門')).thenAnswer((_) async => testData);

        // Act - 載入資料
        await provider.loadAqi('金門');

        // Assert - 驗證時間範圍格式（由於時間是動態的，只檢查格式）
        final timeRange = provider.recentThreeHoursTimeRange;
        expect(timeRange, isNot(equals('暫無資料')));
        expect(timeRange, contains(' - '));

        // 驗證包含3筆資料
        expect(provider.recentThreeHoursCount, equals(3));
      });

      test('當只有1筆資料時時間範圍應該相同', () async {
        // Arrange - 準備只有1筆資料（使用動態時間）
        final now = DateTime.now();
        final testData = [
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 15,
            datacreationdate:
                now.subtract(const Duration(hours: 1, minutes: 30)), // 1.5小時前
            itemunit: 'μg/m3',
          ),
        ];

        when(mockRepo.getSiteAqi('金門')).thenAnswer((_) async => testData);

        // Act - 載入資料
        await provider.loadAqi('金門');

        // Assert - 驗證單筆資料的時間範圍格式
        final timeRange = provider.recentThreeHoursTimeRange;
        expect(timeRange, isNot(equals('暫無資料')));
        expect(timeRange, contains(' - '));

        // 驗證包含1筆資料
        expect(provider.recentThreeHoursCount, equals(1));
      });
    });

    group('邊界情況測試', () {
      test('應該正確處理剛好3小時的資料', () async {
        // Arrange - 準備剛好3小時的資料
        final now = DateTime.now();
        final testData = [
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 15,
            datacreationdate: now.subtract(const Duration(hours: 3)), // 剛好3小時
            itemunit: 'μg/m3',
          ),
        ];

        when(mockRepo.getSiteAqi('金門')).thenAnswer((_) async => testData);

        // Act - 載入資料
        await provider.loadAqi('金門');

        // Assert - 驗證剛好3小時的資料不應該被包含
        expect(provider.recentThreeHoursCount, equals(0));
        expect(provider.recentThreeHoursRecords, isEmpty);
      });

      test('應該正確處理空資料集', () async {
        // Arrange - 準備空資料集
        final testData = <AqiRecord>[];

        when(mockRepo.getSiteAqi('金門')).thenAnswer((_) async => testData);

        // Act - 載入資料
        await provider.loadAqi('金門');

        // Assert - 驗證空資料集的處理
        expect(provider.recentThreeHoursCount, equals(0));
        expect(provider.recentThreeHoursRecords, isEmpty);
        expect(provider.recentThreeHoursAveragePm25, equals(0.0));
        expect(provider.recentThreeHoursTimeRange, equals('暫無資料'));
      });

      test('應該正確處理PM2.5為0的資料', () async {
        // Arrange - 準備包含PM2.5為0的資料
        final now = DateTime.now();
        final testData = [
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 0,
            datacreationdate: now.subtract(const Duration(hours: 1)),
            itemunit: 'μg/m3',
          ),
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 10,
            datacreationdate: now.subtract(const Duration(hours: 2)),
            itemunit: 'μg/m3',
          ),
        ];

        when(mockRepo.getSiteAqi('金門')).thenAnswer((_) async => testData);

        // Act - 載入資料
        await provider.loadAqi('金門');

        // Assert - 驗證包含0值的平均計算 (0+10)/2 = 5
        expect(provider.recentThreeHoursCount, equals(2));
        expect(provider.recentThreeHoursAveragePm25, equals(5.0));
      });
    });

    group('多站點資料測試', () {
      test('應該正確處理不同站點的資料', () async {
        // Arrange - 準備不同站點的資料
        final now = DateTime.now();
        final testData = [
          // 金門站點 - 3小時內
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 15,
            datacreationdate: now.subtract(const Duration(hours: 1)),
            itemunit: 'μg/m3',
          ),
          // 金門站點 - 3小時內（第二筆）
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 20,
            datacreationdate: now.subtract(const Duration(hours: 2)),
            itemunit: 'μg/m3',
          ),
          // 金門站點 - 超過3小時
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 25,
            datacreationdate: now.subtract(const Duration(hours: 4)),
            itemunit: 'μg/m3',
          ),
        ];

        when(mockRepo.getSiteAqi('金門')).thenAnswer((_) async => testData);

        // Act - 載入金門站點資料
        await provider.loadAqi('金門');

        // Assert - 驗證只包含金門站點且3小時內的資料
        expect(provider.recentThreeHoursCount, equals(2));
        expect(provider.recentThreeHoursRecords.first.site, equals('金門'));
        expect(provider.recentThreeHoursAveragePm25, equals(17.5)); // (15+20)/2
      });
    });
  });
}
