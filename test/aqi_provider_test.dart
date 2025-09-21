import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pm25_app/features/aqi/aqi_provider.dart';
import 'package:pm25_app/features/aqi/aqi_record%EF%BC%BFmodel.dart';
import 'package:pm25_app/features/aqi/data/aqi_repository.dart';

@GenerateMocks([AqiRepository])
import 'aqi_provider_test.mocks.dart';

void main() {
  group('AqiProvider', () {
    late MockAqiRepository mockRepo;
    late AqiProvider provider;

    setUp(() {
      mockRepo = MockAqiRepository();
      provider = AqiProvider(repository: mockRepo);
    });

    test('狀態流轉：loading → data', () async {
      final fakeData = [
        AqiRecord(
          site: '金門',
          county: '金門縣',
          pm25: 7,
          datacreationdate: DateTime.parse('2025-06-09T17:00:00'),
          itemunit: 'μg/m3',
        ),
      ];
      when(mockRepo.getSiteAqi('金門')).thenAnswer((_) async => fakeData);

      final states = <bool>[];
      provider.addListener(() {
        states.add(provider.isLoading);
      });

      final future = provider.loadAqi('金門');
      expect(provider.isLoading, true); // loading
      await future;
      expect(states, containsAll([true, false]));
      expect(provider.isLoading, false);
      expect(provider.records, fakeData);
      expect(provider.error, isNull);
    });

    test('狀態流轉：loading → error', () async {
      when(mockRepo.getSiteAqi('土城'))
          .thenAnswer((_) async => throw Exception('error'));

      final states = <bool>[];
      provider.addListener(() {
        states.add(provider.isLoading);
      });

      // 這裡不要 await，直接呼叫
      final future = provider.loadAqi('土城');
      // 立刻檢查 loading 狀態
      expect(provider.isLoading, true); // loading
      await future;
      expect(states, containsAll([true, false]));
      expect(provider.isLoading, false);
      expect(provider.records, isEmpty);
      expect(provider.error, isNotNull);
    });

    group('最近三個小時資料功能', () {
      test('應該正確計算最近三個小時的資料數量', () async {
        final now = DateTime.now();
        final fakeData = [
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
            pm25: 15,
            datacreationdate: now.subtract(const Duration(hours: 2)),
            itemunit: 'μg/m3',
          ),
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 20,
            datacreationdate: now.subtract(const Duration(hours: 4)), // 超過3小時
            itemunit: 'μg/m3',
          ),
        ];

        when(mockRepo.getSiteAqi('金門')).thenAnswer((_) async => fakeData);
        await provider.loadAqi('金門');

        expect(provider.filteredRecordsCount, 2);
        expect(provider.filteredRecordsAveragePm25, 12.5); // (10 + 15) / 2
      });

      test('當沒有最近三個小時的資料時應該返回0', () async {
        final now = DateTime.now();
        final fakeData = [
          AqiRecord(
            site: '金門',
            county: '金門縣',
            pm25: 10,
            datacreationdate: now.subtract(const Duration(hours: 5)), // 超過3小時
            itemunit: 'μg/m3',
          ),
        ];

        when(mockRepo.getSiteAqi('金門')).thenAnswer((_) async => fakeData);
        await provider.loadAqi('金門');

        expect(provider.filteredRecordsCount, 0);
        expect(provider.filteredRecordsAveragePm25, 0.0);
        expect(provider.filteredRecordsTimeRange, '暫無資料');
      });

      test('應該正確格式化時間範圍', () async {
        final now = DateTime.now();
        final fakeData = [
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
            pm25: 15,
            datacreationdate:
                now.subtract(const Duration(hours: 2, minutes: 45)), // 2.75小時前
            itemunit: 'μg/m3',
          ),
        ];

        when(mockRepo.getSiteAqi('金門')).thenAnswer((_) async => fakeData);
        await provider.loadAqi('金門');

        // 由於時間是動態的，我們只檢查格式是否正確
        final timeRange = provider.filteredRecordsTimeRange;
        expect(timeRange, isNot('暫無資料'));
        expect(timeRange, contains(' - '));
      });
    });
  });
}
