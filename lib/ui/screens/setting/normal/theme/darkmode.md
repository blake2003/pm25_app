# 深淺色主題切換 開發流程與規範

## 🚀 開發流程

### 流程圖
**flow chart TD**
  - A[App 啟動] --> B{本地是否有使用者主題設定?}
  - B -- 有 --> C[讀取偏好: light/dark/auto]
  - B -- 無 --> D[預設: light]
  - C --> E[設定 ThemeProvider.appThemeMode]
  - D --> E
  - E --> F[解析成 resolvedThemeMode（light/dark/auto）]
  - F --> G[以 resolvedThemeMode 建立 MaterialApp 主題]
  - G --> H[`設定頁：使用者切換主題`]
  - H --> I[更新 Provider.appThemeMode]
  - I --> J[立即解析 → 更新 resolvedThemeMode]
  - J --> K[重建 UI（listen/notifyListeners）]
  - K --> L[寫入 SharedPreferences: appThemeMode]
  - L --> M[下次啟動沿用設定]
  - E --> N{是否為 auto?}
  - N -- 否 --> O[結束]
  - N -- 是 --> P[依當前時間判斷 → light 或 dark]
  - P --> Q[計算下一個切換邊界 (dayStart/nightStart)]
  - Q --> R[啟動 Timer 定時切換]
  - R --> E

### 自動切換主題流程圖
**flow chart TD**
  - A[自動模式啟動] --> B[獲取當前時間]
  - B --> C[讀取自定義時間設定]
  - C --> D{是否有自定義設定?}
  - D -- 有 --> E[使用自定義時間]
  - D -- 無 --> F[使用預設時間 (07:00/19:00)]
  - E --> G[判斷當前時間區間]
  - F --> G
  - G --> H{當前時間在白天區間?}
  - H -- 是 --> I[設定為淺色主題]
  - H -- 否 --> J[設定為深色主題]
  - I --> K[計算下一個切換時間]
  - J --> K
  - K --> L[啟動定時器]
  - L --> M[等待到切換時間]
  - M --> N[觸發主題切換]
  - N --> O[重新計算下一個切換時間]
  - O --> L

### 狀態轉移圖
**stateDiagram-v2**
  - [*] --> Light
  - Light --> Dark: 使用者選「深色」
  - Light --> Auto: 使用者選「自動」
  - Dark --> Light: 使用者選「淺色」
  - Dark --> Auto: 使用者選「自動」
  - Auto --> Light: 07:00 到達 dayStart
  - Auto --> Dark: 19:00 到達 nightStart
  - Light --> Dark: 19:00 到達 nightStart
  - Dark --> Light: 07:00 到達 dayStart
  - Auto --> Manual: 使用者選「淺色」或「深色」
  - Manual --> Auto: 使用者選「自動」

### 測試規範對照表
**命名規則**
- 單元測試 ID：UT-xxx（provider/儲存/轉換）
- 小型整合測試 ID：IT-xxx（Widget + Provider）
- 端對端/場景測試 ID：ST-xxx（啟動→切換→重啟）

 | 需求編號 | 測試 ID   | 類型         | 前置條件 / Fixture                                   | 測試步驟 (Steps)                        | 期望結果 (Assert)                                 | 覆蓋重點         |
  |----------|-----------|--------------|------------------------------------------------------|------------------------------------------|---------------------------------------------------|------------------|
  | R1       | UT-001    | Unit         | SharedPreferences 為空                                | loadTheme()                              | themeMode == ThemeMode.light                     | 預設值           |
  | R2       | UT-002    | Unit         | 已初始化 Provider                                      | toggleTheme(ThemeMode.dark)              | themeMode == ThemeMode.dark                       | 狀態變更         |
  |          | UT-003    | Unit         | 同上                                                  | toggleTheme(ThemeMode.light)             | themeMode == ThemeMode.light                      | 狀態變更         |
  |          | UT-004    | Unit         | 同上                                                  | toggleTheme(ThemeMode.auto)            | themeMode == ThemeMode.auto                     | 狀態變更         |
  | R3       | IT-101    | Integration  | 包含 MaterialApp(themeMode: provider.themeMode) 的測試 Widget | 點擊「深色模式」選項                     | find.byType(Icon/Color/Key(...dark...)) 存在      | UI 重建          |
  | R4       | UT-005    | Unit         | 切到 dark 後新建 provider 並 loadTheme()             | 讀取偏好                                 | 新 provider 的 themeMode == dark                  | 儲存/讀取        |
  | R5       | ST-201    | Scenario     | 首次切 light，模擬重啟（棄舊樹，重建 app）           | 再次進入 app                              | themeMode == light，UI 為淺色                     | 啟動流程         |
  | R6       | UT-006    | Unit         | 手動寫入 themeMode=unknown                           | loadTheme()                              | themeMode == light                              | 錯誤處理         |
  | R7       | IT-102    | Integration  | 使用 Clock/FakeAsync                                 | 記錄 toggleTheme()→首個重建完成時間      | 小於 100ms                                        | 效能             |
  | R8      | IT-107    | Integration  | 切換主題（light/dark/auto 任一）                     | 監控 Frame rebuild 次數                    | rebuild 次數 ≤ 2                                   | 重建次數上限      |
  | R9      | IT-108    | Integration  | 切換主題前後於主執行緒插入 heavy work（模擬）        | 觀察 UI 響應與卡頓                         | 無明顯掉幀、UI 不卡頓                               | 主執行緒空轉      |
  | R10       | IT-103    | Integration  | 模擬 MediaQuery.platformBrightness 變更               | 將 app 設為 Dark，變更系統明暗         | UI 跟著改                                         | 系統事件         |
  | R11       | IT-104    | Integration  | 設定頁有三種選項（light/dark/auto）                | 逐一點擊三項並返回                        | 畫面主題與選項同步                                | 可用性           |
  | R12      | ST-202    | Scenario     | 隨機連續切換 100 次（fuzz）                          | 監聽例外/日誌                             | 無未捕捉例外、無 frame drop 明顯異常               | 穩定性           |
  | R13      | IT-105    | Integration  | 提供暗/淺色主題色票                                  | 驗證主要文字/按鈕/連結對比                | 對比度達 WCAG AA                                  | 可存取性         |
  | R14      | UT-008    | Unit         | auto 模式，policy=07:00/19:00                        | now=10:00 / now=20:00                        | 10:00 → themeMode == light；20:00 → themeMode == dark         | Auto 判斷         |
  | R15      | UT-009    | Unit         | auto 模式                                            | now=18:30 → 下一邊界=19:00                    | Timer 在 19:00 觸發 → themeMode == dark                   | Auto 定時切換     |
  | R16      | UT-010    | Unit         | auto 模式，policy=07:00/19:00，now=23:59/00:01，模擬時區變更 | now=23:59/now=00:01，切換時區（如 UTC+8→UTC+9） | 23:59→themeMode==dark，00:01→themeMode==light，時區變更後依新當地時間判斷 | 跨日/跨時區判斷 |
  | R17      | IT-106    | Integration  | 設定頁輸入新時間（如 08:00/20:00）                   | 更新偏好後切換                                 | themeMode 依新時間判斷                                 | Auto 調整時間     |
  | R18      | ST-203    | Scenario     | 上次設 auto，現在時間=夜間                           | 重啟 App                                       | 直接解析為 dark，無需等待                              | Auto 啟動沿用     |
  | R19      | UT-011    | Unit         | 自動切換時間設定                                      | 設定自定義時間 08:00/20:00                     | 自動切換使用自定義時間                              | 自定義時間設定     |
  | R20      | UT-012    | Unit         | 時區變更處理                                          | 模擬時區從 UTC+8 變更為 UTC+9                 | 自動切換時間相應調整                                | 時區適應性        |
  | R21      | IT-109    | Integration  | 自動切換效能測試                                      | 監控自動切換的記憶體使用和 CPU 佔用           | 記憶體使用穩定，CPU 佔用 < 5%                        | 效能監控          |
  | R22      | ST-204    | Scenario     | 長時間運行測試                                        | 連續運行 24 小時，觀察自動切換穩定性           | 無記憶體洩漏，切換準時                              | 穩定性測試        |

## 📝 設計原則說明

### 架構設計考量
- **避免過度設計**: 對於簡單的設定資料，不強制使用 Model 類別
- **Repository 模式**: 使用 Repository 封裝 SharedPreferences 操作，符合資料存取層的設計原則
- **Provider 整合**: 直接在 Provider 中管理狀態，簡化資料流
- **靈活配置**: 支援多 Provider 配置，便於擴展
- **單一職責原則**: 將主題配置邏輯從 main.dart 分離到專門的 AppTheme 類別
- **可維護性**: 主題配置集中管理，便於維護和擴展
- **可測試性**: 主題配置邏輯可以獨立測試

## 🏗️ 架構設計

### 核心組件架構
```
lib/
├── core/
│   ├── constants/
│   │   └── app_colors.dart              # 應用程式色彩定義
│   ├── theme/
│   │   └── app_theme.dart               # 主題配置管理
│   └── loggers/
│       └── theme_log.dart               # 主題相關日誌
├── features/
│   └── settings/
│       ├── theme_provider.dart          # 主題狀態管理
│       ├── theme_repository.dart        # 主題資料存取層
│       ├── auto_theme_service.dart      # 自動切換服務
│       └── time_schedule_manager.dart   # 時間排程管理
├── ui/
│   └── screens/
│       └── setting/
│           └── normal/
│               ├── darkmode.dart        # 深色模式設定頁面
│               └── darkmode.md          # 開發規範文件
└── main.dart                            # 應用程式入口點
```

## 🔧 核心組件

### 1. 主題色彩系統 (`app_colors.dart`)
- **AppThemeMode 枚舉**: 定義 light、dark、auto 三種主題模式
- **色彩映射**: 為淺色和深色主題定義完整的色彩系統
- **getColor 方法**: 根據主題模式動態獲取對應色彩

### 2. 主題配置管理 (`app_theme.dart`)
- **buildLightTheme()**: 淺色主題配置
- **buildDarkTheme()**: 深色主題配置
- **集中管理**: 將主題配置從 main.dart 分離，提高可維護性

### 3. 主題狀態管理 (`theme_provider.dart`)
- **ChangeNotifier**: 實現狀態管理和 UI 更新
- **主題切換**: 支援三種主題模式的切換
- **Flutter 整合**: 提供 flutterThemeMode 屬性與 Flutter 的 ThemeMode 整合
- **錯誤處理**: 完整的錯誤處理和日誌記錄
- **自動切換**: 整合自動切換服務

### 4. 主題資料存取層 (`theme_repository.dart`)
- **SharedPreferences**: 本地儲存主題設定
- **資料驗證**: 輸入驗證和錯誤處理
- **Repository 模式**: 封裝資料存取邏輯
- **時間設定儲存**: 儲存自定義的自動切換時間

### 5. 自動切換服務 (`auto_theme_service.dart`)
- **時間判斷**: 根據當前時間判斷應該使用的主題
- **定時器管理**: 管理自動切換的定時器
- **時區處理**: 處理時區變更的情況
- **效能優化**: 優化記憶體使用和 CPU 佔用

### 6. 時間排程管理 (`time_schedule_manager.dart`)
- **時間設定**: 管理白天和夜晚的切換時間
- **預設值**: 提供預設的切換時間（07:00/19:00）
- **自定義設定**: 支援使用者自定義切換時間
- **時區適應**: 自動適應時區變更

### 7. 使用者介面 (`darkmode.dart`)
- **Cupertino 風格**: 使用 iOS 原生設計風格
- **三種選項**: 淺色模式、深色模式、自動模式
- **即時反饋**: 選中狀態的視覺反饋
- **無障礙支援**: 符合 WCAG AA 標準的對比度

### 8. 自動切換設定頁面 (`auto_theme_settings.dart`)
- **時間設定**: 允許使用者設定白天和夜晚的切換時間
- **預覽功能**: 預覽不同時間的主題效果
- **時區顯示**: 顯示當前時區資訊
- **重置功能**: 重置為預設時間設定

## 📝 程式碼規範

### 命名規範
- **檔案名稱**: `snake_case` (例: `theme_provider.dart`)
- **類別名稱**: `PascalCase` (例: `ThemeProvider`)
- **變數/函數**: `camelCase` (例: `themeMode`, `toggleTheme()`)
- **常數**: `SCREAMING_SNAKE_CASE` (例: `THEME_KEY`)

### 自動切換相關命名
- **時間設定**: `dayStartTime`, `nightStartTime`
- **定時器**: `autoSwitchTimer`
- **服務**: `AutoThemeService`
- **管理器**: `TimeScheduleManager`

## 🧪 測試規範

### 測試檔案結構
```
test/
├── features/
│   └── settings/
│       ├── theme_provider_test.dart
│       ├── theme_repository_test.dart
│       ├── auto_theme_service_test.dart
│       └── time_schedule_manager_test.dart
└── ui/
    └── screens/
        └── setting/
            └── normal/
                └── darkmode_test.dart
```

### 測試命名規範
- **單元測試**: `test('應該能切換到深色模式', () async { ... })`
- **Widget 測試**: `testWidgets('應該顯示主題選項', (WidgetTester tester) async { ... })`
- **整合測試**: `test('主題切換應該在100ms內完成', () async { ... })`
- **自動切換測試**: `test('應該在指定時間自動切換主題', () async { ... })`

### 測試覆蓋要求
- **程式碼覆蓋率**: 至少 80%
- **關鍵路徑覆蓋**: 100%
- **錯誤處理覆蓋**: 100%
- **自動切換覆蓋**: 100%

### 自動切換測試案例
```dart
group('自動切換測試', () {
  test('應該在白天時間使用淺色主題', () async {
    // Arrange
    final service = AutoThemeService();
    final testTime = DateTime(2025, 1, 1, 10, 0); // 10:00 AM
    
    // Act
    final theme = service.getThemeForTime(testTime);
    
    // Assert
    expect(theme, AppThemeMode.light);
  });
  
  test('應該在夜晚時間使用深色主題', () async {
    // Arrange
    final service = AutoThemeService();
    final testTime = DateTime(2025, 1, 1, 22, 0); // 10:00 PM
    
    // Act
    final theme = service.getThemeForTime(testTime);
    
    // Assert
    expect(theme, AppThemeMode.dark);
  });
  
  test('應該在跨日時正確處理', () async {
    // Arrange
    final service = AutoThemeService();
    final testTime = DateTime(2025, 1, 1, 23, 59); // 11:59 PM
    
    // Act
    final theme = service.getThemeForTime(testTime);
    
    // Assert
    expect(theme, AppThemeMode.dark);
  });
});
```

## 🔒 安全性規範

### 資料儲存安全
- 使用 `SharedPreferences` 進行本地儲存
- 敏感資料不應儲存在本地
- 定期清理過期的設定資料
- 時間設定資料的加密儲存

### 時區安全
- 驗證時區資料的有效性
- 處理時區變更的異常情況
- 防止時區相關的記憶體洩漏

## 📱 效能優化

### 主題切換效能
- 主題切換應在 100ms 內完成
- 使用 `ChangeNotifier` 進行狀態管理
- 避免不必要的 UI 重建

### 自動切換效能
- 定時器使用最小間隔（1分鐘檢查一次）
- 避免頻繁的時間計算
- 優化記憶體使用，防止洩漏
- CPU 佔用控制在 5% 以下

### 記憶體管理
```dart
// 在 dispose 方法中清理資源
@override
void dispose() {
  _autoSwitchTimer?.cancel();
  _autoSwitchTimer = null;
  super.dispose();
}
```

## 🔄 版本控制

### Commit 訊息規範
```
feat(theme): 新增自動切換主題功能

- 實作 AutoThemeService 自動切換服務
- 新增時間排程管理器
- 完成自動切換測試

Closes #123
```

### 分支命名規範
- `feature/auto-theme-switch` - 自動切換功能分支
- `fix/auto-switch-timer` - 自動切換修復分支
- `test/auto-switch-coverage` - 自動切換測試分支

## 📚 文檔維護

### 更新檢查清單
- [ ] 更新 API 文檔
- [ ] 更新測試文檔
- [ ] 更新使用者指南
- [ ] 更新開發者指南
- [ ] 更新自動切換功能說明

### 版本記錄
```markdown
## [2.0.0] - 2025-01-XX
### 新增
- 自動切換主題功能
- 時間排程管理器
- 自定義切換時間設定
- 時區適應功能

### 修復
- 自動切換效能優化
- 記憶體洩漏修復
- 時區變更處理改進
```

## 🔧 實際實現指南

### 實現步驟

1. **創建自動切換服務**:
   ```dart
   // 創建 lib/features/settings/auto_theme_service.dart
   import 'dart:async';
   import 'package:pm25_app/core/loggers/log.dart';
   import 'package:pm25_app/core/constants/theme_colors.dart';
   ```

2. **創建時間排程管理器**:
   ```dart
   // 創建 lib/features/settings/time_schedule_manager.dart
   import 'package:pm25_app/core/loggers/log.dart';
   ```

3. **更新主題提供者**:
   ```dart
   // 更新 lib/features/settings/theme_provider.dart
   import 'package:pm25_app/features/settings/auto_theme_service.dart';
   ```

4. **創建自動切換設定頁面**:
   ```dart
   // 創建 lib/ui/screens/setting/normal/theme/auto_theme_settings.dart
   import 'package:flutter/cupertino.dart';
   ```

5. **添加測試**:
   ```dart
   // 創建自動切換相關測試
   test('應該在指定時間自動切換主題', () async { ... });
   ```

6. **更新主應用程式**:
   ```dart
   // 在 lib/main.dart 中配置自動切換服務
   import 'package:pm25_app/features/settings/auto_theme_service.dart';
   ```

### 依賴管理
```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.5
  shared_preferences: ^2.2.2
  timezone: ^0.9.2  # 時區處理

dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  build_runner: ^2.4.8
```

## 🎯 品質保證

### 程式碼審查檢查清單
- [ ] 程式碼符合命名規範
- [ ] 日誌記錄完整
- [ ] 錯誤處理適當
- [ ] 測試覆蓋充分
- [ ] 效能要求達標
- [ ] 安全性檢查通過
- [ ] 自動切換邏輯正確
- [ ] 時區處理完善
- [ ] 記憶體管理良好

### 發布前檢查
- [ ] 所有測試通過
- [ ] 程式碼審查完成
- [ ] 效能測試達標
- [ ] 安全性掃描通過
- [ ] 文檔更新完成
- [ ] 自動切換功能驗證
- [ ] 長時間運行測試通過

## 🔮 未來改進

### 短期改進
- [ ] 支援多個時區的自動切換
- [ ] 添加地理位置感知的切換
- [ ] 支援自定義切換動畫

### 長期改進
- [ ] 機器學習優化的切換時間
- [ ] 支援季節性主題切換
- [ ] 整合系統亮度感知

---

**最後更新**: 2025年08月  
**版本**: 2.0.0  
**適用範圍**: PM25 應用程式深色模式開發規範（含自動切換功能）
