# 深淺色主題切換 開發流程與規範

## 🚀 開發流程

### 流程圖
**flow chart TD**
  - A[App 啟動] --> B{本地是否有使用者主題設定?}
  - B -- 有 --> C[讀取偏好: light/dark/system]
  - B -- 無 --> D[預設: system]
  - C --> E[設定 ThemeProvider.themeMode]
  - D --> E
  - E --> F[以 themeMode 建立 MaterialApp 主題]
  - F --> G[`設定頁：使用者切換主題`]
  - G --> H[更新 ThemeProvider.themeMode]
  - H --> I[立即重建 UI（listen/notifyListeners）]
  - I --> J[寫入 SharedPreferences: themeMode]
  - J --> K[（`下次啟動沿用設定`）]

### 狀態轉移圖
**stateDiagram-v2**
  - [*] --> System
  - System --> Light: 使用者選「淺色」
  - System --> Dark: 使用者選「深色」
  - Light --> Dark: 使用者選「深色」
  - Light --> System: 使用者選「跟隨系統」
  - Dark --> Light: 使用者選「淺色」
  - Dark --> System: 使用者選「跟隨系統」

### 測試規範對照表
**命名規則**
- 單元測試 ID：UT-xxx（provider/儲存/轉換）
- 小型整合測試 ID：IT-xxx（Widget + Provider）
- 端對端/場景測試 ID：ST-xxx（啟動→切換→重啟）

 | 需求編號 | 測試 ID   | 類型         | 前置條件 / Fixture                                   | 測試步驟 (Steps)                        | 期望結果 (Assert)                                 | 覆蓋重點         |
  |----------|-----------|--------------|------------------------------------------------------|------------------------------------------|---------------------------------------------------|------------------|
  | R1       | UT-001    | Unit         | SharedPreferences 為空                               | loadTheme()                              | themeMode == ThemeMode.system                     | 預設值           |
  | R2       | UT-002    | Unit         | 已初始化 Provider                                    | toggleTheme(ThemeMode.dark)              | themeMode == ThemeMode.dark                       | 狀態變更         |
  |          | UT-003    | Unit         | 同上                                                 | toggleTheme(ThemeMode.light)             | themeMode == ThemeMode.light                      | 狀態變更         |
  |          | UT-004    | Unit         | 同上                                                 | toggleTheme(ThemeMode.system)            | themeMode == ThemeMode.system                     | 狀態變更         |
  | R3       | IT-101    | Integration  | 包含 MaterialApp(themeMode: provider.themeMode) 的測試 Widget | 點擊「深色模式」選項                     | find.byType(Icon/Color/Key(...dark...)) 存在      | UI 重建          |
  | R4       | UT-005    | Unit         | 切到 dark 後新建 provider 並 loadTheme()             | 讀取偏好                                 | 新 provider 的 themeMode == dark                  | 儲存/讀取        |
  | R5       | ST-201    | Scenario     | 首次切 light，模擬重啟（棄舊樹，重建 app）           | 再次進入 app                              | themeMode == light，UI 為淺色                     | 啟動流程         |
  | R6       | UT-006    | Unit         | 手動寫入 themeMode=unknown                           | loadTheme()                              | themeMode == system                              | 錯誤處理         |
  | R7       | IT-102    | Integration  | 使用 Clock/FakeAsync                                 | 記錄 toggleTheme()→首個重建完成時間      | 小於 100ms                                        | 效能             |
  | R8       | IT-103    | Integration  | 模擬 MediaQuery.platformBrightness 變更               | 將 app 設為 system，變更系統明暗         | UI 跟著改                                         | 系統事件         |
  | R9       | IT-104    | Integration  | 設定頁有三種選項（light/dark/system）                | 逐一點擊三項並返回                        | 畫面主題與選項同步                                | 可用性           |
  | R10      | ST-202    | Scenario     | 隨機連續切換 100 次（fuzz）                          | 監聽例外/日誌                             | 無未捕捉例外、無 frame drop 明顯異常               | 穩定性           |
  | R11      | IT-105    | Integration  | 提供暗/淺色主題色票                                  | 驗證主要文字/按鈕/連結對比                | 對比度達 WCAG AA                                  | 可存取性         |

  <!--
  設計邏輯說明：
  - 本表格依據需求與測試規範，將深淺色主題切換的所有核心驗證點以「需求編號、測試ID、類型、前置條件、步驟、期望結果、覆蓋重點」方式完整列出。
  - 涵蓋單元測試、整合測試、情境測試，確保功能正確、UI即時反應、資料持久化、效能、穩定性與可存取性。
  - 每一項測試皆對應一個明確的驗證目標，便於後續撰寫自動化測試與人工驗證。
  - 表格可直接用於測試計畫、開發自查與需求追蹤。
  -->
