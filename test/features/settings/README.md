# 深色模式測試文件說明

## 📋 測試文件概述

`darkmode_test.dart` 是根據 `darkmode.md` 規範創建的完整測試文件，涵蓋了深色模式切換功能的所有測試需求。

## 🎯 測試覆蓋範圍

### 單元測試 (UT)
- **UT-001**: 預設值測試 - 驗證初始化時使用 system 預設值
- **UT-002**: 深色模式切換測試
- **UT-003**: 淺色模式切換測試  
- **UT-004**: 跟隨系統模式切換測試
- **UT-005**: 儲存/讀取測試 - 驗證設定持久化
- **UT-006**: 錯誤處理測試 - 驗證無效值回退機制

### 整合測試 (IT)
- **IT-101**: UI 重建測試 - 驗證主題切換時 UI 正確重建
- **IT-102**: 效能測試 - 確保主題切換在 100ms 內完成
- **IT-103**: 系統事件測試 - 驗證跟隨系統模式響應
- **IT-104**: 可用性測試 - 驗證三種主題選項的可用性
- **IT-105**: 可存取性測試 - 驗證對比度符合 WCAG AA 標準

### 場景測試 (ST)
- **ST-201**: 啟動流程測試 - 驗證重啟後設定保持
- **ST-202**: 穩定性測試 - 驗證連續切換的穩定性

### 額外測試
- **狀態轉移測試**: 驗證所有主題間的正確轉移
- **主題色彩測試**: 驗證深色和淺色主題的色彩規範

## 🏗️ 測試架構

### 假設的 ThemeProvider
```dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  DateTime _lastUpdated = DateTime.now();
  
  ThemeMode get themeMode => _themeMode;
  DateTime get lastUpdated => _lastUpdated;
  
  Future<void> loadTheme() async { /* 從 Repository 讀取 */ }
  Future<void> toggleTheme(ThemeMode mode) async { /* 切換主題並儲存 */ }
  void setThemeForTesting(ThemeMode mode) { /* 測試用方法 */ }
}
```

### 測試輔助函數
- `_calculateContrastRatio()`: 計算色彩對比度
- `_getRelativeLuminance()`: 計算相對亮度
- `_getSRGBComponent()`: sRGB 分量轉換

## 🚀 執行測試

### 執行所有深色模式測試
```bash
cd pm25_app
flutter test test/features/settings/darkmode_test.dart
```

### 執行特定測試群組
```bash
# 執行單元測試
flutter test test/features/settings/darkmode_test.dart --name="單元測試"

# 執行整合測試
flutter test test/features/settings/darkmode_test.dart --name="整合測試"

# 執行場景測試
flutter test test/features/settings/darkmode_test.dart --name="場景測試"
```

## 📊 測試結果驗證

### 預期測試結果
- ✅ 所有單元測試通過
- ✅ 所有整合測試通過
- ✅ 所有場景測試通過
- ✅ 效能測試符合要求 (< 100ms)
- ✅ 可存取性測試符合 WCAG AA 標準

### 日誌輸出
測試會輸出詳細的日誌資訊，包括：
- 測試通過狀態
- 效能數據
- 對比度數值
- 色彩資訊

## 🔧 實際實現時的修改

當實際實現 ThemeProvider 時，需要：

1. **替換假設的 ThemeProvider**:
   ```dart
   // 將假設的 ThemeProvider 替換為實際實現
   import 'package:pm25_app/features/settings/theme_provider.dart';
   ```

2. **添加 SharedPreferences 依賴**:
   ```dart
   // 在 pubspec.yaml 中添加
   shared_preferences: ^2.2.2
   ```

3. **實現 Repository 層**:
   ```dart
   // 創建 ThemeRepository 封裝 SharedPreferences 操作
   class ThemeRepository {
     Future<Map<String, dynamic>> loadThemeSettings() async { /* 實作 */ }
     Future<void> saveThemeSettings(Map<String, dynamic> settings) async { /* 實作 */ }
   }
   ```

4. **添加 Mock 測試**:
   ```dart
   // 使用 mockito 進行 Repository 測試
   @GenerateMocks([SharedPreferences])
   import 'theme_repository_test.mocks.dart';
   ```

## 📝 測試維護

### 新增測試
當添加新功能時，請：
1. 在適當的測試群組中添加新測試
2. 更新測試 ID 編號
3. 添加相應的日誌輸出

### 更新測試
當修改功能時，請：
1. 更新對應的測試案例
2. 確保測試仍然覆蓋所有邊界情況
3. 驗證測試結果

## 🎯 測試目標

這個測試文件確保：
- ✅ 功能正確性：所有主題切換功能正常工作
- ✅ 資料持久化：設定正確儲存和讀取
- ✅ UI 響應性：主題切換時 UI 立即更新
- ✅ 效能要求：切換速度符合要求
- ✅ 穩定性：連續操作不會出現異常
- ✅ 可存取性：符合無障礙設計標準

---

**最後更新**: 2025年01月  
**版本**: 1.0.0  
**適用範圍**: PM25 應用程式深色模式測試規範 