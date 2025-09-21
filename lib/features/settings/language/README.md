# 多語言切換功能實現

## 📋 功能概述

本模組實現了 PM25 應用程式的多語言切換功能，支援英文和繁體中文，並提供完整的語言管理機制。

## 🏗️ 架構設計

### 檔案結構
```
lib/features/settings/language/
├── language_constants.dart      # 語言常數定義
├── language_provider.dart       # Provider 狀態管理
├── language_repository.dart     # 資料存取層
└── README.md                   # 說明文件

lib/core/services/
└── language_service.dart       # 語言服務

lib/core/constants/language/
├── language_constants.dart     # 語言常數
└── l10n/                      # 本地化資源
    ├── app_en.arb             # 英文翻譯
    ├── app_zh.arb             # 中文翻譯（fallback）
    └── app_zh_TW.arb          # 繁體中文翻譯

lib/ui/widgets/
└── language_selector.dart     # 語言選擇器組件

lib/ui/screens/setting/normal/language/
└── language_settings_screen.dart  # 語言設定頁面
```

## 🔧 核心組件

### 1. LanguageConstants
定義支援的語言清單和相關常數：
- 支援語言：英文 (en)、繁體中文 (zh_TW)
- 預設語言：繁體中文
- 語言資訊模型：LanguageInfo

### 2. LanguageService
核心語言服務，負責：
- 語言偏好設定的儲存和載入
- Locale 物件的生成
- 語言切換的底層實現

### 3. LanguageRepository
資料存取層，提供：
- 統一的資料存取介面
- 錯誤處理和日誌記錄
- 與 LanguageService 的整合

### 4. LanguageProvider
狀態管理，提供：
- 語言狀態的統一管理
- 語言切換的業務邏輯
- UI 狀態的更新通知

## 🎨 UI 組件

### 1. LanguageSelector
簡潔的語言選擇器，提供：
- 對話框形式的語言選擇
- 即時語言切換
- 載入狀態顯示

### 2. SimpleLanguageSelector
設定頁面專用的語言選擇器：
- 卡片式設計
- 單選按鈕介面
- 即時狀態更新

### 3. LanguageSettingsScreen
完整的語言設定頁面：
- 當前語言資訊顯示
- 進階設定選項
- 支援語言清單

## 📝 翻譯資源

### ARB 檔案結構
- `app_en.arb`: 英文翻譯模板
- `app_zh.arb`: 中文翻譯（fallback）
- `app_zh_TW.arb`: 繁體中文翻譯

### 支援的翻譯鍵值
- `appTitle`: 應用程式標題
- `home`: 首頁
- `settings`: 設定
- `language`: 語言
- `theme`: 主題
- `airQuality`: 空氣品質
- `news`: 新聞
- `selectLanguage`: 選擇語言
- `english`: 英文
- `chineseTraditional`: 繁體中文
- `cancel`: 取消
- `confirm`: 確認
- `languageChanged`: 語言切換成功

## 🚀 使用方法

### 1. 基本使用
```dart
// 在 Widget 中使用
Consumer<LanguageProvider>(
  builder: (context, languageProvider, child) {
    return Text(languageProvider.currentLanguage);
  },
)

// 切換語言
context.read<LanguageProvider>().changeLanguage('en');
```

### 2. 語言選擇器
```dart
// 簡潔版
LanguageSelector()

// 設定頁面版
SimpleLanguageSelector()
```

### 3. 語言設定頁面
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const LanguageSettingsScreen(),
  ),
);
```

## 🧪 測試

### 測試檔案
- `test/features/settings/language/language_provider_test.dart`

### 測試覆蓋範圍
- 語言切換功能
- 錯誤處理
- 狀態管理
- 邊界情況

### 執行測試
```bash
flutter test test/features/settings/language/
```

## 🔄 開發流程

### 1. 新增語言
1. 在 `LanguageConstants` 中新增語言資訊
2. 建立對應的 ARB 翻譯檔案
3. 更新 `supportedLocales` 清單
4. 測試語言切換功能

### 2. 新增翻譯
1. 在 `app_en.arb` 中新增英文翻譯
2. 在各語言 ARB 檔案中新增對應翻譯
3. 執行 `flutter gen-l10n` 重新生成
4. 更新 UI 使用新的翻譯鍵值

### 3. 修改語言邏輯
1. 修改 `LanguageService` 的底層實現
2. 更新 `LanguageProvider` 的業務邏輯
3. 調整 UI 組件的顯示邏輯
4. 更新相關測試

## 📊 效能考量

### 1. 記憶體管理
- 語言資源按需載入
- 及時釋放不使用的資源
- 避免記憶體洩漏

### 2. 載入優化
- 快取已載入的翻譯資源
- 預載入常用語言
- 延遲載入非必要資源

### 3. 狀態更新
- 最小化不必要的重建
- 使用適當的 Provider 監聽
- 避免過度的狀態更新

## 🔒 安全性

### 1. 輸入驗證
- 驗證語言代碼的有效性
- 檢查翻譯內容的安全性
- 防止惡意輸入

### 2. 資料保護
- 加密敏感的語言設定
- 保護使用者隱私
- 安全的資料傳輸

## 🐛 常見問題

### 1. 翻譯不顯示
- 檢查 ARB 檔案格式
- 確認 gen-l10n 已執行
- 驗證 AppLocalizations 導入

### 2. 語言切換失敗
- 檢查語言代碼是否支援
- 確認 SharedPreferences 權限
- 查看錯誤日誌

### 3. UI 不更新
- 確認 Provider 監聽正確
- 檢查 notifyListeners 呼叫
- 驗證 Consumer 使用

## 📚 相關文件

- [國際化開發規範](./lang_rule.md)
- [主要開發規範](../../../.cursor/RULES.md)
- [iOS 設計規範](../../../.cursor/rules/ui/ios-style-rule.mdc)
- [日誌系統規範](../../../.cursor/rules/log/log-rule.mdc)

---

**最後更新**: 2025年01月  
**版本**: 1.0.0  
**適用範圍**: PM25 應用程式多語言功能
