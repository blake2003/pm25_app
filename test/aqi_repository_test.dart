import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pm25_app/core/services/data_service.dart';
import 'package:pm25_app/features/aqi/aqi_record%EF%BC%BFmodel.dart';
import 'package:pm25_app/features/aqi/data/aqi_repository.dart';

@GenerateMocks([DataService])
import 'aqi_repository_test.mocks.dart';

void main() {
  group('AqiRepository', () {
    late MockDataService mockDataService;
    late AqiRepository repository;

    setUp(() {
      mockDataService = MockDataService();
      repository = AqiRepository(dataService: mockDataService);
    });

    test('getSiteAqi() 會呼叫 fetchSiteData() 並正確 parse', () async {
      final fakeRaw = [
        {
          'site': '台北',
          'county': '台北市',
          'pm2_5': '12',
          'datacreationdate': '2024-01-01T00:00:00',
          'itemunit': 'μg/m3',
        },
      ];
      when(mockDataService.fetchSiteData('台北'))
          .thenAnswer((_) async => fakeRaw);

      final result = await repository.getSiteAqi('台北');

      // 驗證 fetchSiteData 有被呼叫
      verify(mockDataService.fetchSiteData('台北')).called(1);

      // 驗證 parse 結果
      expect(result, isA<List<AqiRecord>>());
      expect(result.length, 1);
      expect(result.first.site, '台北');
      expect(result.first.county, '台北市');
      expect(result.first.pm25, 12);
      expect(
          result.first.datacreationdate, DateTime.parse('2024-01-01T00:00:00'));
      expect(result.first.itemunit, 'μg/m3');
    });
  });
}
