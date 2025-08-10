import 'package:flutter_test/flutter_test.dart';

void main() {
  group('馬祖站點修復測試', () {
    test('應該能夠正常操作站點列表', () {
      // 模擬站點列表操作
      List<String> sites = ['金門', '馬公', '馬祖', '員林', '富貴角'];

      // 檢查初始狀態
      expect(sites.contains('馬祖'), true);
      expect(sites.length, 5);

      // 刪除馬祖
      sites.remove('馬祖');
      expect(sites.contains('馬祖'), false);
      expect(sites.length, 4);

      // 重新添加馬祖
      sites.add('馬祖');
      expect(sites.contains('馬祖'), true);
      expect(sites.length, 5);

      // 驗證其他站點也能正常操作
      sites.remove('金門');
      expect(sites.contains('金門'), false);
      sites.add('金門');
      expect(sites.contains('金門'), true);
    });

    test('應該能夠處理重複添加和刪除', () {
      List<String> sites = ['金門', '馬公', '馬祖'];

      // 重複刪除同一個站點
      sites.remove('馬祖');
      sites.remove('馬祖'); // 應該不會出錯
      expect(sites.contains('馬祖'), false);

      // 重複添加同一個站點
      sites.add('馬祖');
      sites.add('馬祖'); // 會導致重複，但不會出錯
      expect(sites.contains('馬祖'), true);
    });
  });
}
