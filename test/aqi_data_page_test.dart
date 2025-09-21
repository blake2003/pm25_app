import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pm25_app/features/aqi/aqi_provider.dart';
import 'package:pm25_app/features/aqi/aqi_record%EF%BC%BFmodel.dart';
import 'package:pm25_app/ui/screens/main/pages/aqi_data_page.dart';
import 'package:provider/provider.dart';

import 'aqi_data_page_test.mocks.dart';

@GenerateMocks([AqiProvider])
void main() {
  group('AqiDataPage', () {
    late MockAqiProvider mockAqiProvider;

    setUp(() {
      mockAqiProvider = MockAqiProvider();
    });

    /// 測試載入狀態顯示
    testWidgets('顯示載入指示器當 AQI 資料正在加載時', (WidgetTester tester) async {
      // 設置 mock 物件返回載入狀態
      when(mockAqiProvider.isLoading).thenReturn(true);
      when(mockAqiProvider.error).thenReturn(null);
      when(mockAqiProvider.filteredRecords).thenReturn([]);

      await tester.pumpWidget(
        CupertinoApp(
          home: ChangeNotifierProvider<AqiProvider>.value(
            value: mockAqiProvider,
            child: const AqiDataPage(),
          ),
        ),
      );

      // 驗證載入指示器顯示
      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
    });

    /// 測試錯誤狀態顯示
    testWidgets('顯示錯誤訊息當載入 AQI 資料失敗時', (WidgetTester tester) async {
      const errorMessage = '網路連線失敗';

      // 設置 mock 物件返回錯誤狀態
      when(mockAqiProvider.isLoading).thenReturn(false);
      when(mockAqiProvider.error).thenReturn(errorMessage);
      when(mockAqiProvider.filteredRecords).thenReturn([]);

      await tester.pumpWidget(
        CupertinoApp(
          home: ChangeNotifierProvider<AqiProvider>.value(
            value: mockAqiProvider,
            child: const AqiDataPage(),
          ),
        ),
      );

      // 驗證錯誤訊息顯示
      expect(find.text('載入資料失敗'), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
      expect(
          find.byIcon(CupertinoIcons.exclamationmark_circle), findsOneWidget);
    });

    /// 測試空資料狀態顯示
    testWidgets('顯示暫無資料訊息當沒有 AQI 資料時', (WidgetTester tester) async {
      // 設置 mock 物件返回空資料
      when(mockAqiProvider.isLoading).thenReturn(false);
      when(mockAqiProvider.error).thenReturn(null);
      when(mockAqiProvider.recentThreeHoursRecords).thenReturn([]);

      await tester.pumpWidget(
        CupertinoApp(
          home: ChangeNotifierProvider<AqiProvider>.value(
            value: mockAqiProvider,
            child: const AqiDataPage(),
          ),
        ),
      );

      // 驗證空資料訊息顯示
      expect(find.text('暫無資料'), findsOneWidget);
      expect(find.text('目前沒有最近三小時的 AQI 資料'), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.doc_text), findsWidgets);
    });

    /// 測試資料列表顯示
    testWidgets('正確顯示 AQI 資料列表', (WidgetTester tester) async {
      // 創建測試資料
      final testRecords = [
        AqiRecord(
          site: '金門',
          county: '金門縣',
          pm25: 25,
          datacreationdate: DateTime(2024, 1, 15, 10, 30),
          itemunit: 'μg/m³',
        ),
        AqiRecord(
          site: '馬祖',
          county: '連江縣',
          pm25: 18,
          datacreationdate: DateTime(2024, 1, 15, 11, 0),
          itemunit: 'μg/m³',
        ),
      ];

      // 設置 mock 物件返回測試資料
      when(mockAqiProvider.isLoading).thenReturn(false);
      when(mockAqiProvider.error).thenReturn(null);
      when(mockAqiProvider.filteredRecords).thenReturn(testRecords);
      when(mockAqiProvider.filteredRecordsTimeRange)
          .thenReturn('10:30 - 11:00');

      await tester.pumpWidget(
        CupertinoApp(
          home: ChangeNotifierProvider<AqiProvider>.value(
            value: mockAqiProvider,
            child: const AqiDataPage(),
          ),
        ),
      );

      // 驗證資料顯示
      expect(find.text('最近三小時資料'), findsOneWidget);
      expect(find.text('共 2 筆資料'), findsOneWidget);
      expect(find.text('10:30 - 11:00'), findsOneWidget);

      // 驗證第一筆資料
      expect(find.text('記錄 #1'), findsOneWidget);
      expect(find.text('金門'), findsOneWidget);
      expect(find.text('金門縣'), findsOneWidget);
      expect(find.text('25 μg/m³'), findsOneWidget);

      // 驗證第二筆資料
      expect(find.text('記錄 #2'), findsOneWidget);
      expect(find.text('馬祖'), findsOneWidget);
      expect(find.text('連江縣'), findsOneWidget);
      expect(find.text('18 μg/m³'), findsOneWidget);
    });

    /// 測試 PM2.5 等級顯示
    testWidgets('正確顯示不同 PM2.5 等級的標籤', (WidgetTester tester) async {
      // 創建不同等級的測試資料
      final testRecords = [
        AqiRecord(
          site: '站點1',
          county: '縣市1',
          pm25: 10, // 良好等級
          datacreationdate: DateTime.now(),
          itemunit: 'μg/m³',
        ),
        AqiRecord(
          site: '站點2',
          county: '縣市2',
          pm25: 25, // 普通等級
          datacreationdate: DateTime.now(),
          itemunit: 'μg/m³',
        ),
        AqiRecord(
          site: '站點3',
          county: '縣市3',
          pm25: 50, // 對敏感族群不健康
          datacreationdate: DateTime.now(),
          itemunit: 'μg/m³',
        ),
      ];

      when(mockAqiProvider.isLoading).thenReturn(false);
      when(mockAqiProvider.error).thenReturn(null);
      when(mockAqiProvider.filteredRecords).thenReturn(testRecords);
      when(mockAqiProvider.filteredRecordsTimeRange).thenReturn('測試時間');

      await tester.pumpWidget(
        CupertinoApp(
          home: ChangeNotifierProvider<AqiProvider>.value(
            value: mockAqiProvider,
            child: const AqiDataPage(),
          ),
        ),
      );

      // 驗證不同等級標籤顯示
      expect(find.text('良好'), findsOneWidget);
      expect(find.text('普通'), findsOneWidget);
      expect(find.text('對敏感族群不健康'), findsOneWidget);
    });

    /// 測試頁面標題顯示
    testWidgets('顯示正確的頁面標題', (WidgetTester tester) async {
      when(mockAqiProvider.isLoading).thenReturn(false);
      when(mockAqiProvider.error).thenReturn(null);
      when(mockAqiProvider.recentThreeHoursRecords).thenReturn([]);

      await tester.pumpWidget(
        CupertinoApp(
          home: ChangeNotifierProvider<AqiProvider>.value(
            value: mockAqiProvider,
            child: const AqiDataPage(),
          ),
        ),
      );

      // 驗證頁面標題
      expect(find.text('AQI 資料檢視'), findsOneWidget);
      expect(find.byType(CupertinoNavigationBar), findsOneWidget);
    });
  });
}
