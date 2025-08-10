import 'package:flutter_test/flutter_test.dart';
import 'package:pm25_app/core/services/data_service.dart';

void main() {
  group('DataService', () {
    final dataService = DataService();

    test('fetchSiteData 能抓到資料', () async {
      // 這裡用一個已知存在的 site 名稱，例如「台北」
      final result = await dataService.fetchSiteData('金門');
      expect(result, isA<List<dynamic>>());
      expect(result.isNotEmpty, true, reason: '應該要有資料被抓取下來');
      // 可以額外驗證資料內容
      expect(result.first['site'], '金門');
    });
  });
}
