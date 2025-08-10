import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pm25_app/features/aqi/aqi_provider.dart';
import 'package:pm25_app/ui/screens/main/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  group('站點管理功能測試', () {
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

    testWidgets('應該能夠刪除馬祖站點並重新添加', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 檢查初始站點列表包含馬祖
      expect(find.text('馬祖'), findsOneWidget);

      // 點擊刪除按鈕
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      // 選擇馬祖進行刪除
      await tester.tap(find.text('刪除').last);
      await tester.pumpAndSettle();

      // 確認刪除
      await tester.tap(find.text('刪除').last);
      await tester.pumpAndSettle();

      // 檢查馬祖已被刪除
      expect(find.text('馬祖'), findsNothing);

      // 點擊添加按鈕
      await tester.tap(find.byIcon(Icons.add_location));
      await tester.pumpAndSettle();

      // 檢查馬祖在可添加列表中
      expect(find.text('馬祖'), findsOneWidget);
    });

    testWidgets('刪除站點後應該能重新添加', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 記錄初始站點數量
      final initialDropdownItems = find.byType(DropdownMenuItem<String>);
      final initialCount = tester.widgetList(initialDropdownItems).length;

      // 刪除一個站點
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();
      await tester.tap(find.text('刪除').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('刪除').last);
      await tester.pumpAndSettle();

      // 檢查站點數量減少
      final afterDeleteDropdownItems = find.byType(DropdownMenuItem<String>);
      final afterDeleteCount =
          tester.widgetList(afterDeleteDropdownItems).length;
      expect(afterDeleteCount, lessThan(initialCount));

      // 添加一個站點
      await tester.tap(find.byIcon(Icons.add_location));
      await tester.pumpAndSettle();
      await tester.tap(find.text('確定').last);
      await tester.pumpAndSettle();

      // 檢查站點數量增加
      final afterAddDropdownItems = find.byType(DropdownMenuItem<String>);
      final afterAddCount = tester.widgetList(afterAddDropdownItems).length;
      expect(afterAddCount, greaterThan(afterDeleteCount));
    });

    testWidgets('站點列表應該正確更新', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 檢查初始站點
      expect(find.text('金門'), findsOneWidget);
      expect(find.text('馬公'), findsOneWidget);
      expect(find.text('馬祖'), findsOneWidget);
      expect(find.text('員林'), findsOneWidget);
      expect(find.text('富貴角'), findsOneWidget);

      // 刪除馬祖
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();
      await tester.tap(find.text('刪除').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('刪除').last);
      await tester.pumpAndSettle();

      // 檢查馬祖已被刪除
      expect(find.text('馬祖'), findsNothing);

      // 添加馬祖回來
      await tester.tap(find.byIcon(Icons.add_location));
      await tester.pumpAndSettle();
      await tester.tap(find.text('確定').last);
      await tester.pumpAndSettle();

      // 檢查馬祖重新出現
      expect(find.text('馬祖'), findsOneWidget);
    });
  });
}
