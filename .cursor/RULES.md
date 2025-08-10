# PM25 App 開發規範

## 📋 專案概述

本文件定義了 PM25 空氣品質監測應用程式的核心開發規範，專注於前端整體性的設計原則和架構規範。

**核心開發原則：**
- **需求分析階段**：充分理解用戶需求，站在用戶角度思考，分析需求是否存在缺漏，並與用戶討論完善需求
- **設計階段**：選擇最簡單的解決方案來滿足用戶需求，避免過度設計，進行架構設計和UI設計
- **測試驅動開發**：使用TDD(Test-Driven-Development)測試驅動開發，先依據需求寫測試，在進行開發
- **程式碼保持DRY原則**
- **使用 Provider 進行狀態管理**
- **靈活選擇 UI 框架：可選擇 Cupertino、Material Design 或混合使用**
- **會依據反饋持續更新設計**
- **使用 Python 實作後端服務**
- **依照情況選擇 "pm25_app/lib/core/loggers"中的檔案進行除錯**
- **知道該在何處建立正確的檔案並且進行分類**
- **會創建測試檔驗證新功能**

## 🚀 開發流程規範

### 完整開發流程
1. **需求分析階段**
   - 充分理解用戶需求，站在用戶角度思考
   - 分析需求是否存在缺漏，並與用戶討論完善需求
   - 確定功能範圍和技術可行性
   - 制定開發計劃和時間表

2. **設計階段**
   - 選擇最簡單的解決方案來滿足用戶需求，避免過度設計
   - 進行架構設計，確定模組劃分和依賴關係
   - 進行UI設計，遵循iOS設計規範
   - 設計資料模型和API接口

3. **測試設計階段**
   - 根據需求設計測試案例
   - 撰寫單元測試、Widget測試和整合測試
   - 確保測試覆蓋關鍵業務邏輯和邊界情況

4. **編碼實現階段**
   - 遵循TDD原則，先寫測試再實現功能
   - 保持程式碼簡潔，遵循DRY原則
   - 使用適當的設計模式和架構模式
   - 及時進行程式碼審查和重構

5. **測試驗證階段**
   - 執行所有測試，確保功能正確性
   - 進行整合測試，驗證組件間互動
   - 進行用戶驗收測試，確保符合需求

6. **部署和維護階段**
   - 部署到測試環境進行驗證
   - 收集用戶反饋並進行迭代優化
   - 監控應用程式性能和穩定性

### 開發流程檢查清單

#### 需求分析階段
- [ ] 需求是否清晰明確？
- [ ] 是否與用戶確認了需求細節？
- [ ] 技術可行性是否評估完成？
- [ ] 開發計劃是否制定完成？

#### 設計階段
- [ ] 架構設計是否合理？
- [ ] UI設計是否符合iOS規範？
- [ ] 資料模型是否設計完成？
- [ ] API接口是否定義清楚？

#### 測試設計階段
- [ ] 測試案例是否覆蓋完整？
- [ ] 單元測試是否撰寫完成？
- [ ] Widget測試是否設計完成？
- [ ] 整合測試是否規劃完成？

#### 編碼實現階段
- [ ] 是否遵循TDD原則？
- [ ] 程式碼是否符合規範？
- [ ] 是否進行了程式碼審查？
- [ ] 是否及時進行了重構？

#### 測試驗證階段
- [ ] 所有測試是否通過？
- [ ] 功能是否符合需求？
- [ ] 性能是否達到要求？
- [ ] 用戶體驗是否良好？

## 🏗️ 架構設計原則

### 專案結構
```
lib/
├── core/                    # 核心功能（全域為主）
│   ├── constants/          # 常數定義
│   ├── loggers/           # 日誌系統
│   ├── services/          # 核心服務
│   ├── storage/           # 本地儲存
│   └── utils/             # 工具函數
├── features/              # 功能模組
│   ├── aqi/              # 空氣品質功能
│   ├── auth/             # 認證功能
│   ├── news/             # 新聞功能
│   └── settings/         # 設定功能
├── models/               # 資料模型
├── ui/                   # 使用者介面
│   ├── screens/          # 頁面
│   ├── widgets/          # 可重用元件
│   └── extensions/       # UI 擴展
└── main.dart            # 應用程式入口
```

### 命名規範
- **檔案名稱**: snake_case (例: `auth_service.dart`)
- **類別名稱**: PascalCase (例: `AuthService`)
- **變數/函數**: camelCase (例: `userName`, `getUserData()`)
- **常數**: SCREAMING_SNAKE_CASE (例: `API_BASE_URL`)

## 🔄 狀態管理規範

### Provider 使用原則
- 使用 `ChangeNotifierProvider` 進行狀態管理
- 避免在 build 方法中建立 Provider
- 使用 `Consumer` 或 `context.watch<T>()` 監聽狀態變化
- 使用 `context.read<T>()` 呼叫方法

### Provider 結構要求
```dart
class ExampleProvider extends ChangeNotifier {
  // 私有狀態變數
  List<Data> _data = [];
  bool _isLoading = false;
  String? _error;

  // 公開 getter
  List<Data> get data => _data;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // 業務邏輯方法
  Future<void> loadData() async {
    // 實作邏輯
  }
}
```

## 🎨 UI/UX 設計規範

> **📋 詳細規範：** iOS 風格設計的完整規範請參考 [ui/ios-style-rule.mdc](./rules/ui/ios-style-rule.mdc)

### 核心設計原則
- **靈活選擇 UI 框架：可選擇 Cupertino、Material Design 或混合使用**
- **會依據反饋持續更新設計**
- 遵循 iOS Human Interface Guidelines
- 保持 iOS 原生體驗的一致性
- 響應式設計適配不同 iOS 裝置

### 設計要求
- 靈活使用各種設計套件，滿足ui設計需求
- 例如使用 `CupertinoPageScaffold`、`CupertinoNavigationBar` 等 Cupertino widgets
- 使用 `CupertinoColors` 系統色彩
- 遵循 iOS 字體層級系統
- 支援深色模式

### 框架選擇指南

| 功能類型 | 推薦框架 | 原因 |
|---------|---------|------|
| 導航和頁面結構 | Material Design | 更靈活的佈局選項 |
| 表單輸入 | Cupertino | iOS 原生輸入體驗 |
| 列表和卡片 | 混合使用 | 根據內容複雜度選擇 |
| 對話框和彈窗 | Cupertino | iOS 原生對話體驗 |
| 按鈕和互動 | 混合使用 | 根據上下文選擇 |

## 📝 日誌與註解規範

> **📋 詳細規範：** 日誌系統的詳細使用規範請參考 [log/log-rule.mdc](./rules/log/log-rule.mdc)

### 日誌使用原則
- **依照情況選擇 "pm25_app/lib/core/loggers"中的檔案進行除錯**
- 使用 `AppLogger` 進行統一日誌管理
- 簡短描述問題，便於快速定位
- 適當使用日誌層級：DEBUG、INFO、WARNING、ERROR

### 日誌層級使用指南

| 層級 | 使用場景 | 範例 |
|------|----------|------|
| **DEBUG** | 詳細的除錯資訊，僅開發環境 | `log.d('API 請求參數: $params')` |
| **INFO** | 一般資訊，記錄重要操作 | `log.i('用戶登入成功: ${user.email}')` |
| **WARNING** | 警告資訊，可能影響功能 | `log.w('網路連線緩慢，重試中...')` |
| **ERROR** | 錯誤資訊，需要關注 | `log.e('API 請求失敗', error, stackTrace)` |

### 日誌範例
```dart
class DataService {
  final log = AppLogger('DataService');
  
  Future<void> fetchData() async {
    try {
      log.i('API 請求開始');
      // 實作邏輯
      log.i('資料獲取成功: ${data.length} 筆');
    } catch (e, stack) {
      log.e('網路請求失敗: $e', e, stack);
    }
  }
}
```

## 📦 套件使用規範

### 核心依賴
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0          # 狀態管理
  http: ^1.1.0              # 網路請求
  shared_preferences: ^2.2.0 # 本地儲存
  firebase_core: ^2.15.0    # Firebase 核心
  firebase_auth: ^4.7.2     # Firebase 認證

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0     # 程式碼檢查
```

### 套件選擇原則
- 優先使用官方套件
- 檢查套件維護狀態和更新頻率
- 避免功能重複的套件
- 考慮套件大小對應用程式的影響

## 🧪 測試規範

### 測試策略
- 為每個新功能創建對應的測試檔
- 測試檔命名：`{feature_name}_{component_type}_test.dart`
- 目標至少 80% 的程式碼覆蓋率
- 使用 AAA 模式 (Arrange-Act-Assert)

### 測試分類
1. **單元測試**：測試個別函數和類別
2. **Widget 測試**：測試 UI 組件的渲染和互動
3. **整合測試**：測試多個組件之間的互動

### dart單元測試規範
- 所有功能必須撰寫對應的測試檔，檔案放置於 `test/` 目錄下，並依功能模組分類。
- 測試檔命名規則：`xxx_test.dart`，與被測試檔案對應。
- 使用 `flutter test` 執行單元測試，確保每次提交前所有測試皆通過。
- 測試內容需涵蓋：
  - 關鍵邏輯與狀態變化
  - UI 元件渲染與互動
  - Provider 狀態管理流程
  - 例外與錯誤處理
- 測試程式需加上簡明註解，說明測試目的與預期結果。
- 新增功能或修正 bug 時，必須同步新增或更新相關測試。
- 測試失敗時，需優先修復後再進行其他開發。

### python單元測試規範
- 所有功能必須撰寫對應的測試檔，檔案放置於 `test/` 目錄下，並依功能模組分類。
- 測試檔命名規則：`test_xxx.py`，與被測試檔案對應。
- 使用 `python test_xxx.py` 執行單元測試，確保每次提交前所有測試皆通過。
- 測試內容需涵蓋：
  - 關鍵邏輯與狀態變化
  - 測試程式需加上簡明註解，說明測試目的與預期結果。
  - 新增功能或修正 bug 時，必須同步新增或更新相關測試。
  - 測試失敗時，需優先修復後再進行其他開發。

## 🔒 安全性規範

### 基本原則
- 使用環境變數管理 API 金鑰
- 驗證所有使用者輸入
- 適當處理敏感資料
- 遵循最小權限原則

### API 安全
```dart
class ApiConfig {
  static const String apiKey = String.fromEnvironment('API_KEY');
  static const String baseUrl = String.fromEnvironment('API_BASE_URL');
}
```

## 📱 效能優化

### 基本原則
- 使用 `ListView.builder` 處理大量資料
- 適當的圖片格式和大小
- 及時釋放資源（dispose 方法）
- 避免不必要的 setState 呼叫

## 🐍 後端整合

### API 設計原則
- 使用標準的 RESTful API 設計
- 統一的 JSON 響應格式
- 適當的 HTTP 狀態碼
- 完善的錯誤處理機制

### 錯誤處理
```dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  
  ApiException(this.message, [this.statusCode]);
  
  @override
  String toString() => 'ApiException: $message (${statusCode ?? 'unknown'})';
}
```

## 📚 程式碼品質

### 基本要求
- 遵循 Dart 官方風格指南
- 使用 `flutter_lints` 進行靜態分析
- 保持函數簡潔，單一職責原則
- 適當的註解和文件

### 版本控制
- 使用語義化版本號
- 清晰的 commit 訊息
- 功能分支開發
- 程式碼審查流程

## 🚀 部署規範

### 環境配置
```dart
class AppConfig {
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );
}
```

### CI/CD 基本要求
- 自動化測試執行
- 程式碼品質檢查
- 自動化建置和部署

## 🔄 問題解決與迭代優化

### 問題解決
- 使用測試驗證新功能，確保新功能可以運行，並符合需求
- 全面閱讀相關程式碼，理解 **dart** 和 **python** 的工作原理，並進行相關的測試調整
- 根據用戶的反饋分析問題的原因，提出解決問題的思路
- 確保每次程式碼變更不會破壞現有功能，且盡可能保持最小的改動

### 迭代優化
- 與用戶保持密切溝通，根據用戶的反饋調整功能和設計，確保應用符合用戶需求
- 在需求不確定時，主動詢問用戶以澄清需求或技術細節
- 每次迭代都需要更新README.md文件，包括功能說明和優化建議

## 📋 相關規範文件

- **iOS 設計規範**: [ui/ios-style-rule.mdc](./rules/ui/ios-style-rule.mdc)
- **日誌系統規範**: [log/log-rule.mdc](./rules/log/log-rule.mdc)
- **Null Safety 修復指南**: [NULL_SAFETY_FIX_GUIDE.md](../NULL_SAFETY_FIX_GUIDE.md)
- **新聞功能實作總結**: [ui/screens/news/IMPLEMENTATION_SUMMARY.md](./lib/ui/screens/news/IMPLEMENTATION_SUMMARY.md)

---

**最後更新**: 2025年08月  
**版本**: 6.0.0  
**更新內容**: 整合最新日誌規範和設計規範，更新UI框架選擇策略和測試規範 