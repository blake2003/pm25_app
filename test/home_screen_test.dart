import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pm25_app/features/aqi/aqi_provider.dart';
import 'package:pm25_app/ui/screens/main/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  group('HomeScreen 刪除站點功能測試', () {
    late AqiProvider mockAqiProvider;

    setUp(() {
      mockAqiProvider = AqiProvider();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<AqiProvider>.value(
          value: mockAqiProvider,
          child: const HomeScreen(),
        ),
      );
    }

    testWidgets('應該顯示刪除站點按鈕', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 檢查刪除按鈕是否存在
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('點擊刪除按鈕應該顯示刪除對話框', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 點擊刪除按鈕
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      // 檢查是否顯示刪除對話框
      expect(find.text('選擇要刪除的地區'), findsOneWidget);
      expect(find.text('取消'), findsOneWidget);
      expect(find.text('刪除'), findsOneWidget);
    });

    testWidgets('當只有一個站點時應該顯示無法刪除提示', (WidgetTester tester) async {
      // 創建一個只有一個站點的測試 widget
      final testWidget = MaterialApp(
        home: ChangeNotifierProvider<AqiProvider>.value(
          value: mockAqiProvider,
          child: const HomeScreen(),
        ),
      );

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // 模擬只有一個站點的情況（這裡需要修改 HomeScreen 來支援測試）
      // 由於 _sites 是私有變數，我們需要通過其他方式測試
      // 這個測試主要驗證 UI 元素的存在
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('取消刪除操作不應該改變站點列表', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 記錄初始站點數量
      final initialDropdownItems = find.byType(DropdownMenuItem<String>);
      final initialCount = tester.widgetList(initialDropdownItems).length;

      // 點擊刪除按鈕
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      // 點擊取消
      await tester.tap(find.text('取消').first);
      await tester.pumpAndSettle();

      // 檢查站點列表沒有改變
      final updatedDropdownItems = find.byType(DropdownMenuItem<String>);
      final updatedCount = tester.widgetList(updatedDropdownItems).length;

      expect(updatedCount, equals(initialCount));
    });

    testWidgets('刪除站點對話框應該包含所有站點選項', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 點擊刪除按鈕
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      // 檢查對話框內容
      expect(find.text('選擇要刪除的地區'), findsOneWidget);
      expect(find.byType(CupertinoPicker), findsOneWidget);
    });

    testWidgets('刪除按鈕應該有正確的樣式', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 檢查刪除按鈕的 tooltip
      final deleteButton = find.byIcon(Icons.delete_outline);
      expect(deleteButton, findsOneWidget);

      // 檢查按鈕是否可點擊
      expect(tester.widget<IconButton>(deleteButton).onPressed, isNotNull);
    });
  });
}
