# AQI 時間過濾功能開發測試與設計規範

## 📋 功能概述

AQI 時間過濾功能允許使用者根據不同的時間範圍來篩選和查看空氣品質資料，提供靈活的資料檢視選項，滿足不同使用場景的需求。

## 🎯 需求分析

### 1. 功能需求

#### 1.1 核心需求
- **時間範圍選擇**: 支援多種預設時間範圍（1小時、3小時、6小時、12小時、24小時）
- **動態過濾**: 根據選擇的時間範圍獲取過去時間的資料
- **資料完整性**: 確保獲取的資料包含所有必要資訊
- **效能優化**: 避免不必要的資料處理和 UI 重建

#### 1.2 使用者需求
- **快速切換**: 使用者可以快速在不同時間範圍間切換
- **視覺回饋**: 清楚顯示當前選擇的時間範圍
- **資料標記**: 區分新舊資料，幫助使用者理解資料時效性
- **除錯資訊**: 在開發模式下提供詳細的過濾資訊

#### 1.3 技術需求
- **向後相容**: 保持與現有 API 的相容性
- **狀態管理**: 使用 Provider 進行狀態管理
- **響應式更新**: 時間範圍變更時自動更新 UI
- **錯誤處理**: 妥善處理資料獲取過程中的異常情況

### 2. 非功能需求

#### 2.1 效能需求
- **過濾速度**: 過濾操作應在 100ms 內完成
- **記憶體使用**: 避免過度複製資料，優化記憶體使用
- **UI 響應**: 過濾過程中保持 UI 響應性

#### 2.2 可用性需求
- **直觀操作**: 使用者可以直觀地選擇時間範圍
- **一致性**: 與 iOS 設計規範保持一致
- **無障礙**: 支援無障礙功能

## 🏗️ 架構設計

### 1. 核心架構

#### 1.1 資料流設計
```
使用者選擇時間範圍 → AqiProvider.setTimeFilter() → 更新過濾邏輯 → 重新計算 filteredRecords → 通知 UI 更新 → 重新渲染資料列表
```

#### 1.2 組件架構
```
AqiProvider (狀態管理)
├── TimeFilterOption (枚舉定義)
├── filteredRecords (計算屬性)
├── setTimeFilter() (方法)
└── isRecordInSelectedTimeRange() (方法)

AqiDataPage (UI 組件)
├── _showTimeFilterPicker() (選擇器)
├── _buildAqiRecordCard() (卡片渲染)
└── Consumer<AqiProvider> (狀態監聽)
```

### 2. 資料模型設計

#### 2.1 TimeFilterOption 枚舉
```dart
enum TimeFilterOption {
  oneHour('1小時', Duration(hours: 1)),
  threeHours('3小時', Duration(hours: 3)),
  sixHours('6小時', Duration(hours: 6)),
  twelveHours('12小時', Duration(hours: 12)),
  twentyFourHours('24小時', Duration(hours: 24)),
  allData('全部資料', null);
}
```

#### 2.2 過濾邏輯設計
```dart
List<AqiRecord> get filteredRecords {
  if (_selectedTimeFilter.duration != null) {
    final filterTime = DateTime.now().subtract(_selectedTimeFilter.duration!);
    return _records.where((record) => 
      record.datacreationdate.isAfter(filterTime)).toList();
  } else {
    return List<AqiRecord>.from(_records);
  }
}
```

## 🎨 UI/UX 設計規範

### 1. 設計原則

#### 1.1 一致性原則
- 遵循 iOS Human Interface Guidelines
- 使用 Cupertino 設計語言
- 保持與應用程式整體風格一致

#### 1.2 可用性原則
- 操作流程簡單直觀
- 提供清晰的視覺回饋
- 支援快速切換和取消操作

### 2. 介面設計

#### 2.1 導航欄按鈕設計
```dart
CupertinoButton(
  child: Row(
    children: [
      Icon(CupertinoIcons.clock_fill, size: 20),
      Text(selectedTimeFilter.label),
      Icon(CupertinoIcons.chevron_down, size: 12),
    ],
  ),
)
```

#### 2.2 時間選擇器設計
```dart
CupertinoActionSheet(
  title: Text('選擇時間範圍'),
  message: Text('選擇要顯示的資料時間範圍'),
  actions: availableTimeFilters.map((option) => 
    CupertinoActionSheetAction(
      child: Row(
        children: [
          Text(option.label),
          if (option == selectedTimeFilter)
            Icon(CupertinoIcons.check_mark),
        ],
      ),
    ),
  ).toList(),
)
```

#### 2.3 資料卡片設計
- **新資料**: 正常顯示，無特殊標記
- **舊資料**: 在「全部資料」模式下標記「較舊」標籤
- **時間資訊**: 清楚顯示資料的檢測時間

### 3. 互動設計

#### 3.1 操作流程
1. 使用者點擊右上角時鐘按鈕
2. 彈出時間範圍選擇器
3. 使用者選擇時間範圍
4. 系統自動過濾並更新顯示
5. 提供視覺回饋確認操作成功

#### 3.2 錯誤處理
- 無資料時顯示適當的空狀態
- 過濾失敗時顯示錯誤訊息
- 網路問題時提供重試選項

## 🧪 測試規範

### 1. 測試策略

#### 1.1 測試分類
- **單元測試**: 測試過濾邏輯和狀態管理
- **Widget 測試**: 測試 UI 組件渲染和互動
- **整合測試**: 測試完整的使用者流程
- **效能測試**: 測試過濾效能和記憶體使用

#### 1.2 測試覆蓋率目標
- 程式碼覆蓋率: ≥ 90%
- 分支覆蓋率: ≥ 95%
- 功能覆蓋率: 100%

### 2. 測試案例設計

#### 2.1 單元測試案例

##### 2.1.1 時間過濾邏輯測試
```dart
test('1小時過濾模式下只顯示最近1小時的資料', () {
  // Arrange: 設定測試資料
  final now = DateTime.now();
  final testRecords = [
    AqiRecord(datacreationdate: now.subtract(Duration(minutes: 30))), // 30分鐘前
    AqiRecord(datacreationdate: now.subtract(Duration(hours: 2))),    // 2小時前
  ];
  
  // Act: 設定1小時過濾並載入資料
  provider.setTimeFilter(TimeFilterOption.oneHour);
  provider.setTestData(testRecords);
  
  // Assert: 驗證只顯示30分鐘前的資料
  expect(provider.filteredRecords.length, 1);
  expect(provider.filteredRecords.first.datacreationdate, 
         now.subtract(Duration(minutes: 30)));
});
```

##### 2.1.2 狀態管理測試
```dart
test('切換時間過濾選項時正確更新狀態', () {
  // Arrange: 初始狀態
  expect(provider.selectedTimeFilter, TimeFilterOption.threeHours);
  
  // Act: 切換到1小時
  provider.setTimeFilter(TimeFilterOption.oneHour);
  
  // Assert: 驗證狀態更新
  expect(provider.selectedTimeFilter, TimeFilterOption.oneHour);
});
```

##### 2.1.3 邊界條件測試
```dart
test('空資料時的過濾行為', () {
  // Arrange: 空資料
  provider.setTestData([]);
  
  // Act: 設定各種過濾選項
  provider.setTimeFilter(TimeFilterOption.oneHour);
  
  // Assert: 驗證返回空列表
  expect(provider.filteredRecords, isEmpty);
});
```

#### 2.2 Widget 測試案例

##### 2.2.1 UI 渲染測試
```dart
testWidgets('時間過濾按鈕正確顯示當前選項', (tester) async {
  // Arrange: 建立測試環境
  await tester.pumpWidget(
    MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => AqiProvider(),
        child: AqiDataPage(),
      ),
    ),
  );
  
  // Assert: 驗證按鈕顯示預設選項
  expect(find.text('3小時'), findsOneWidget);
  expect(find.byIcon(CupertinoIcons.clock_fill), findsOneWidget);
});
```

##### 2.2.2 互動測試
```dart
testWidgets('點擊時間過濾按鈕顯示選擇器', (tester) async {
  // Arrange: 建立測試環境
  await tester.pumpWidget(/* ... */);
  
  // Act: 點擊時間過濾按鈕
  await tester.tap(find.byType(CupertinoButton));
  await tester.pumpAndSettle();
  
  // Assert: 驗證選擇器彈出
  expect(find.text('選擇時間範圍'), findsOneWidget);
  expect(find.text('1小時'), findsOneWidget);
  expect(find.text('全部資料'), findsOneWidget);
});
```

##### 2.2.3 選擇器互動測試
```dart
testWidgets('選擇時間範圍後正確更新顯示', (tester) async {
  // Arrange: 建立測試環境並顯示選擇器
  await tester.pumpWidget(/* ... */);
  await tester.tap(find.byType(CupertinoButton));
  await tester.pumpAndSettle();
  
  // Act: 選擇1小時選項
  await tester.tap(find.text('1小時'));
  await tester.pumpAndSettle();
  
  // Assert: 驗證按鈕文字更新
  expect(find.text('1小時'), findsOneWidget);
});
```

#### 2.3 整合測試案例

##### 2.3.1 完整流程測試
```dart
testWidgets('完整時間過濾流程測試', (tester) async {
  // Arrange: 建立測試環境
  final provider = AqiProvider();
  await tester.pumpWidget(
    MaterialApp(
      home: ChangeNotifierProvider.value(
        value: provider,
        child: AqiDataPage(),
      ),
    ),
  );
  
  // Act: 執行完整流程
  await tester.tap(find.byType(CupertinoButton));
  await tester.pumpAndSettle();
  await tester.tap(find.text('6小時'));
  await tester.pumpAndSettle();
  
  // Assert: 驗證結果
  expect(provider.selectedTimeFilter, TimeFilterOption.sixHours);
  expect(find.text('6小時'), findsOneWidget);
});
```

### 3. 效能測試

#### 3.1 過濾效能測試
```dart
test('大量資料過濾效能測試', () {
  // Arrange: 建立大量測試資料
  final now = DateTime.now();
  final testRecords = List.generate(1000, (index) => 
    AqiRecord(datacreationdate: now.subtract(Duration(hours: index))));
  
  // Act: 執行過濾操作
  final stopwatch = Stopwatch()..start();
  provider.setTestData(testRecords);
  provider.setTimeFilter(TimeFilterOption.oneHour);
  final filteredRecords = provider.filteredRecords;
  stopwatch.stop();
  
  // Assert: 驗證效能要求
  expect(stopwatch.elapsedMilliseconds, lessThan(100));
  expect(filteredRecords.length, greaterThan(0));
});
```

#### 3.2 記憶體使用測試
```dart
test('過濾操作記憶體使用測試', () {
  // Arrange: 記錄初始記憶體使用
  final initialMemory = ProcessInfo.currentRss;
  
  // Act: 執行多次過濾操作
  for (int i = 0; i < 100; i++) {
    provider.setTimeFilter(TimeFilterOption.values[i % 6]);
  }
  
  // Assert: 驗證記憶體使用合理
  final finalMemory = ProcessInfo.currentRss;
  final memoryIncrease = finalMemory - initialMemory;
  expect(memoryIncrease, lessThan(10 * 1024 * 1024)); // 10MB
});
```

## 🔧 實作指南

### 1. 開發流程

#### 1.1 開發階段
1. **需求確認**: 確認時間過濾需求和使用場景
2. **設計階段**: 設計 UI 和資料流
3. **測試設計**: 撰寫測試案例
4. **實作階段**: 實作核心功能
5. **測試驗證**: 執行測試並修正問題
6. **整合測試**: 與其他功能整合測試

#### 1.2 程式碼品質要求
- 遵循 Dart 官方風格指南
- 使用 flutter_lints 進行靜態分析
- 保持函數簡潔，單一職責原則
- 適當的註解和文件

### 2. 實作要點

#### 2.1 狀態管理
```dart
class AqiProvider extends ChangeNotifier {
  TimeFilterOption _selectedTimeFilter = TimeFilterOption.threeHours;
  
  // 公開 getter
  TimeFilterOption get selectedTimeFilter => _selectedTimeFilter;
  
  // 狀態更新方法
  void setTimeFilter(TimeFilterOption option) {
    if (_selectedTimeFilter != option) {
      _selectedTimeFilter = option;
      notifyListeners();
    }
  }
}
```

#### 2.2 過濾邏輯
```dart
List<AqiRecord> get filteredRecords {
  if (_selectedTimeFilter.duration != null) {
    final filterTime = DateTime.now().subtract(_selectedTimeFilter.duration!);
    return _records.where((record) => 
      record.datacreationdate.isAfter(filterTime)).toList();
  } else {
    return List<AqiRecord>.from(_records);
  }
}
```

#### 2.3 UI 實作
```dart
void _showTimeFilterPicker(BuildContext context, AqiProvider aqiProvider) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      title: const Text('選擇時間範圍'),
      actions: aqiProvider.availableTimeFilters.map((option) =>
        CupertinoActionSheetAction(
          onPressed: () {
            aqiProvider.setTimeFilter(option);
            Navigator.pop(context);
          },
          child: Text(option.label),
        ),
      ).toList(),
    ),
  );
}
```

### 3. 錯誤處理

#### 3.1 異常情況處理
```dart
List<AqiRecord> get filteredRecords {
  try {
    if (_records.isEmpty) return [];
    
    if (_selectedTimeFilter.duration != null) {
      final filterTime = DateTime.now().subtract(_selectedTimeFilter.duration!);
      return _records.where((record) => 
        record.datacreationdate.isAfter(filterTime)).toList();
    } else {
      return List<AqiRecord>.from(_records);
    }
  } catch (e, stack) {
    log.e('時間過濾失敗', e, stack);
    return _records; // 發生錯誤時返回原始資料
  }
}
```

#### 3.2 日誌記錄
```dart
void setTimeFilter(TimeFilterOption option) {
  if (_selectedTimeFilter != option) {
    final log = AppLogger('AqiProvider');
    log.i('切換時間過濾選項: ${option.label}');
    
    _selectedTimeFilter = option;
    notifyListeners();
    
    log.d('過濾後資料數量: ${filteredRecords.length} 筆');
  }
}
```

## 📊 驗收標準

### 1. 功能驗收標準
- [ ] 支援所有預設時間範圍選項
- [ ] 過濾邏輯正確，資料準確
- [ ] UI 互動流暢，響應及時
- [ ] 狀態管理正確，無記憶體洩漏
- [ ] 錯誤處理完善，異常情況妥善處理

### 2. 效能驗收標準
- [ ] 過濾操作在 100ms 內完成
- [ ] 記憶體使用合理，無明顯洩漏
- [ ] UI 響應性良好，無卡頓現象
- [ ] 大量資料處理效能可接受

### 3. 品質驗收標準
- [ ] 測試覆蓋率 ≥ 90%
- [ ] 程式碼通過靜態分析
- [ ] 符合 iOS 設計規範
- [ ] 無障礙功能支援

## 🔄 維護與迭代

### 1. 監控指標
- 過濾操作的平均響應時間
- 記憶體使用情況
- 使用者操作成功率
- 錯誤發生頻率

### 2. 迭代優化
- 根據使用者反饋優化 UI/UX
- 根據效能監控結果優化過濾邏輯
- 根據使用數據調整預設選項
- 新增更多時間範圍選項

### 3. 版本相容性
- 保持 API 向後相容
- 平滑升級策略
- 資料遷移方案
- 回滾機制

---

**文件版本**: 1.0.0  
**最後更新**: 2025年1月  
**適用範圍**: AQI 時間過濾功能開發  
**參考規範**: RULES.md, iOS 設計規範, 測試規範
