# PM25 應用程式架構更新說明

## 📋 更新概述

根據開發團隊的建議和最佳實踐，對深色模式功能的架構設計進行了優化調整，主要變更包括：

1. **移除過度設計的 Model 類別**
2. **將 Service 更改為 Repository**
3. **簡化資料結構設計**
4. **優化 Provider 架構**

## 🔄 主要變更

### 1. 架構組件變更

#### 變更前
```
lib/features/settings/
├── theme_provider.dart          # 主題狀態管理
├── theme_service.dart           # 主題服務邏輯
└── models/
    └── theme_model.dart         # 主題資料模型
```

#### 變更後
```
lib/features/settings/
├── theme_provider.dart          # 主題狀態管理
└── theme_repository.dart        # 主題資料存取層
```

### 2. 設計原則調整

#### 避免過度設計
- **移除 Model 類別**: 對於簡單的設定資料，不強制使用 Model 類別
- **簡化資料結構**: 直接在 Provider 中管理狀態
- **減少複雜性**: 降低不必要的抽象層級

#### Repository 模式
- **正確的命名**: 使用 Repository 而非 Service 來封裝資料存取
- **職責明確**: Repository 專門負責 SharedPreferences 操作
- **符合架構原則**: 符合資料存取層的設計模式

## 🏗️ 新的架構設計

### 核心組件

#### 1. ThemeProvider
```dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  DateTime _lastUpdated = DateTime.now();
  final ThemeRepository _themeRepository;
  
  // Getters
  ThemeMode get themeMode => _themeMode;
  DateTime get lastUpdated => _lastUpdated;
  
  // 業務邏輯方法
  Future<void> loadTheme() async { /* 從 Repository 載入 */ }
  Future<void> toggleTheme(ThemeMode mode) async { /* 切換主題 */ }
}
```

#### 2. ThemeRepository
```dart
class ThemeRepository {
  static const String _themeKey = 'themeMode';
  static const String _lastUpdatedKey = 'themeLastUpdated';
  
  // 資料存取方法
  Future<Map<String, dynamic>> loadThemeSettings() async { /* 載入設定 */ }
  Future<void> saveThemeSettings(Map<String, dynamic> settings) async { /* 儲存設定 */ }
}
```

### 資料流設計

```
UI (設定頁面)
    ↓
ThemeProvider (狀態管理)
    ↓
ThemeRepository (資料存取)
    ↓
SharedPreferences (本地儲存)
```

## 📊 架構優勢

### 1. 簡化性
- **減少檔案數量**: 從 3 個檔案減少到 2 個檔案
- **降低複雜度**: 移除不必要的 Model 抽象層
- **提高可讀性**: 更直接的資料流和狀態管理

### 2. 正確性
- **命名準確**: Repository 更準確地描述資料存取職責
- **職責分離**: Provider 負責狀態，Repository 負責資料
- **架構一致**: 符合 Flutter 和 Dart 的最佳實踐

### 3. 可維護性
- **易於測試**: 更簡單的組件結構，更容易進行單元測試
- **易於擴展**: 清晰的職責分離，便於未來功能擴展
- **易於理解**: 新開發者更容易理解架構設計

## 🧪 測試架構調整

### 測試檔案結構
```
test/features/settings/
├── theme_provider_test.dart      # Provider 測試
├── theme_repository_test.dart    # Repository 測試
└── README.md                     # 測試說明
```

### 測試重點
- **Provider 測試**: 狀態管理和業務邏輯
- **Repository 測試**: 資料存取和錯誤處理
- **整合測試**: Provider + Repository 的整合

## 🔧 實作指南

### 1. 創建 Repository
```dart
// lib/features/settings/theme_repository.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pm25_app/core/loggers/log.dart';

class ThemeRepository {
  // 實作資料存取邏輯
}
```

### 2. 更新 Provider
```dart
// lib/features/settings/theme_provider.dart
import 'package:provider/provider.dart';
import 'package:pm25_app/features/settings/theme_repository.dart';

class ThemeProvider extends ChangeNotifier {
  // 實作狀態管理邏輯
}
```

### 3. 配置主應用程式
```dart
// lib/main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (context) => ThemeProvider()),
  ],
  child: MyApp(),
)
```

## 📝 開發規範更新

### 命名規範
- **Repository**: 使用 `Repository` 後綴，負責資料存取
- **Provider**: 使用 `Provider` 後綴，負責狀態管理
- **檔案命名**: 使用 `snake_case` 格式

### 程式碼組織
- **避免過度設計**: 對於簡單資料，不強制使用 Model
- **職責分離**: 明確區分狀態管理和資料存取
- **錯誤處理**: 在 Repository 層處理資料存取錯誤

### 測試策略
- **單元測試**: 分別測試 Provider 和 Repository
- **整合測試**: 測試完整的資料流
- **Mock 測試**: 使用 Mock 隔離依賴

## 🎯 品質保證

### 程式碼審查重點
- [ ] 架構設計是否簡潔合理
- [ ] 職責分離是否明確
- [ ] 錯誤處理是否適當
- [ ] 測試覆蓋是否充分
- [ ] 命名是否準確

### 效能考量
- **記憶體使用**: 簡化的架構減少記憶體佔用
- **啟動時間**: 減少檔案載入時間
- **維護成本**: 降低長期維護成本

## 📈 預期效果

### 開發效率提升
- **減少開發時間**: 簡化的架構減少開發工作量
- **提高程式碼品質**: 更清晰的職責分離
- **降低錯誤率**: 減少複雜性，降低出錯機率

### 團隊協作改善
- **統一架構**: 團隊成員更容易理解和使用
- **減少爭議**: 明確的設計原則減少架構爭議
- **提高可維護性**: 更容易進行程式碼維護和更新

## 🔄 後續計劃

### 短期目標
- [ ] 完成深色模式功能的實作
- [ ] 撰寫完整的測試案例
- [ ] 進行程式碼審查和優化

### 長期目標
- [ ] 將此架構模式推廣到其他功能模組
- [ ] 建立完整的架構文檔
- [ ] 持續優化和改進架構設計

---

**更新時間**: 2025年08月  
**版本**: 2.0.0  
**適用範圍**: PM25 應用程式架構設計更新 