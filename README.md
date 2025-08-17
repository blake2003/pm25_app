# PM25 空氣品質監測應用程式

## 📱 專案概述

PM25 空氣品質監測應用程式是一個基於 Flutter 開發的跨平台應用程式，專注於提供即時的空氣品質資訊。本專案採用現代化的架構設計，使用 Provider 進行狀態管理，並結合 Python 後端服務來提供完整的空氣品質監測解決方案。

### 🎯 專案目標
- 提供即時、準確的空氣品質資訊
- 以用戶體驗為中心，開發便於使用的應用程式
- 支援多平台部署（iOS、Android、Web）
- 提供個人化的空氣品質監測服務

## 🏗️ 技術架構

### 前端技術棧
- **框架**: Flutter 3.x
- **語言**: Dart
- **狀態管理**: Provider
- **UI 設計**: Cupertino (iOS 風格)
- **日誌系統**: 自定義 log.dart
- **本地儲存**: SharedPreferences

### 後端技術棧
- **語言**: Python
- **框架**: Flask
- **資料庫**: SQLite3
- **爬蟲**: 環保署 API 整合
- **API**: RESTful API

### 開發環境
- **作業系統**: macOS
- **模擬器**: iOS Simulator
- **IDE**: Cursor + MCP Tools
- **版本控制**: Git

## 📁 專案結構

```
pm25_app/
├── lib/
│   ├── core/                    # 核心功能（全域為主）
│   │   ├── constants/           # 常數定義
│   │   ├── loggers/             # 日誌系統
│   │   ├── services/            # 核心服務
│   │   ├── storage/             # 本地儲存
│   │   └── utils/               # 工具函數
│   ├── features/                # 功能模組
│   │   ├── aqi/                 # 空氣品質功能
│   │   ├── auth/                # 認證功能
│   │   ├── news/                # 新聞功能
│   │   └── settings/            # 設定功能
│   ├── models/                  # 資料模型
│   ├── ui/                      # 使用者介面
│   │   ├── screens/             # 頁面
│   │   ├── widgets/             # 可重用元件
│   │   └── extensions/          # UI 擴展
│   └── main.dart                # 應用程式入口
├── test/                        # 測試檔案
├── android/                     # Android 平台配置
├── ios/                         # iOS 平台配置
└── pubspec.yaml                 # 依賴管理
```

## 🚀 功能模組

### 1. 空氣品質監測 (AQI)
- **即時資料**: 顯示當前空氣品質指數
- **歷史趨勢**: 提供過去24小時的資料趨勢
- **多站點支援**: 支援多個監測站點
- **個人化設定**: 自定義關注的站點
- **站點管理**: 添加和刪除監測站點功能
- **Bug 修復**: 修復馬祖站點刪除後無法重新加入的問題
- **Bug 修復**: 修復第一個項目無法選擇的問題

### 2. 用戶認證 (Auth)
- **註冊/登入**: 支援電子郵件註冊和登入
- **密碼重設**: 忘記密碼功能
- **本地儲存**: 安全的認證資訊儲存
- **Firebase 整合**: 使用 Firebase Auth

### 3. 新聞資訊 (News)
- **即時新聞**: 空氣品質相關新聞
- **新聞快取**: 本地新聞快取機制
- **分類瀏覽**: 按主題分類的新聞
- **離線閱讀**: 支援離線新聞瀏覽

### 4. 設定功能 (Settings)
- **個人偏好**: 自定義應用程式設定
- **通知設定**: 空氣品質警報設定
- **語言設定**: 多語言支援
- **主題設定**: 深色/淺色主題

## 🛠️ 開發規範

### 核心開發原則
- **需求分析階段**: 充分理解用戶需求，站在用戶角度思考，分析需求是否存在缺漏
- **設計階段**: 選擇最簡單的解決方案來滿足用戶需求，避免過度設計
- **測試驅動開發**: 使用TDD(Test-Driven-Development)測試驅動開發，先依據需求寫測試，再進行開發
- **程式碼保持DRY原則**: 避免重複程式碼
- **使用 Provider 進行狀態管理**: 統一的狀態管理方案
- **靈活選擇 UI 框架**: 可選擇 Cupertino、Material Design 或混合使用
- **會依據反饋持續更新設計**: 持續改進和優化

### 程式碼編寫原則
- **DRY 原則**: 避免重複程式碼
- **單一職責**: 每個類別/函數只負責一個功能
- **模組化設計**: 清晰的模組分離
- **響應式設計**: 適配不同螢幕尺寸
- **測試覆蓋**: 所有功能必須撰寫對應的測試檔

### 開發規範文件
- **[完整開發規範總覽](./docs/DEVELOPMENT_GUIDELINES.md)**: 詳細的開發規範和最佳實踐
- **[開發檢查清單](./docs/DEVELOPMENT_CHECKLIST.md)**: 開發過程中的檢查清單
- **[iOS 設計規範](./lib/.cursor/rules/ui/ios-style-rule.mdc)**: iOS 風格設計的完整規範
- **[日誌系統規範](./lib/.cursor/rules/log/log-rule.mdc)**: 日誌系統的詳細使用規範
- **[深色模式開發規範](./lib/ui/screens/setting/normal/darkmode.md)**: 深色模式功能的開發規範

### 日誌記錄規範
```dart
// 使用 log.dart 進行日誌記錄
log.d('debug message');    // 除錯資訊
log.i('info message');     // 一般資訊
log.w('warning message');  // 警告訊息
log.e('error message');    // 錯誤訊息
```

### 測試規範
- **單元測試**: 所有功能必須有對應的測試檔
- **測試覆蓋率**: 目標至少 80% 的程式碼覆蓋率
- **測試命名**: `xxx_test.dart` 格式
- **測試執行**: 使用 `flutter test` 執行

## 📦 依賴套件

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
```

### 開發依賴
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0     # 程式碼檢查
  mockito: ^5.4.0           # 測試模擬
```

## 🚀 快速開始

### 環境準備
1. 安裝 Flutter SDK (3.x 版本)
2. 安裝 Xcode (iOS 開發)
3. 安裝 Android Studio (Android 開發)
4. 設定 iOS Simulator

### 安裝步驟
```bash
# 1. 克隆專案
git clone <repository-url>
cd pm25_app

# 2. 安裝依賴
flutter pub get

# 3. 執行測試
flutter test

# 4. 啟動應用程式
flutter run
```

### iOS 模擬器運行
```bash
# 列出可用模擬器
flutter devices

# 在 iOS 模擬器上運行
flutter run -d "iPhone 15 Pro"
```

## 🧪 測試

### 執行測試
```bash
# 執行所有測試
flutter test

# 執行特定測試檔案
flutter test test/aqi_provider_test.dart

# 生成測試覆蓋率報告
flutter test --coverage
```

### 測試檔案結構
```
test/
├── features/
│   ├── aqi/
│   │   └── aqi_provider_test.dart
│   ├── auth/
│   │   └── auth_service_test.dart
│   └── news/
│       └── news_provider_test.dart
├── models/
│   └── aqi_record_test.dart
└── widget_test.dart
```

## 📱 UI/UX 設計

### 設計原則
- **iOS 風格**: 使用 Cupertino widgets
- **一致性**: 遵循 iOS Human Interface Guidelines
- **響應式**: 適配不同裝置尺寸
- **可訪問性**: 支援無障礙功能

### 設計規範
詳細的 iOS 風格設計規範請參考 `pm25_app/.cursor/rules/ui/ios-style-rule.mdc`

## 🔧 後端服務

### Python 後端
- **位置**: `../TW_Daily_News_Crawler/`
- **功能**: 新聞爬蟲和 API 服務
- **技術**: Flask + SQLite3
- **API**: RESTful API 設計

### 啟動後端服務
```bash
cd ../TW_Daily_News_Crawler/
python app.py
```

## 📊 效能優化

### 前端優化
- **圖片優化**: 使用適當的圖片格式和大小
- **列表優化**: 使用 ListView.builder 處理大量資料
- **記憶體管理**: 及時釋放資源
- **快取機制**: 本地資料快取

### 後端優化
- **資料庫索引**: 優化查詢效能
- **API 快取**: 減少重複請求
- **非同步處理**: 提高響應速度

## 🔒 安全性

### 資料安全
- **API 金鑰管理**: 使用環境變數
- **資料驗證**: 輸入驗證和清理
- **HTTPS**: 所有 API 請求使用 HTTPS
- **本地儲存**: 安全的認證資訊儲存

## 📈 版本控制

### Git 工作流程
- **主分支**: main
- **功能分支**: feature/功能名稱
- **修復分支**: fix/問題描述
- **發布分支**: release/版本號

### Commit 訊息規範
```
feat: 新增空氣品質監測功能
fix: 修復登入頁面載入問題
docs: 更新 README 文件
test: 新增 AQI Provider 測試
```

## 🤝 貢獻指南

### 開發流程
1. Fork 專案
2. 建立功能分支
3. 撰寫程式碼和測試
4. 提交 Pull Request
5. 程式碼審查
6. 合併到主分支

### 程式碼審查檢查清單
- [ ] 程式碼符合專案規範
- [ ] 新增功能有對應的測試
- [ ] 所有測試通過
- [ ] 程式碼有適當的註解
- [ ] UI 符合設計規範

## 📞 聯絡資訊

如有任何問題或建議，請聯繫開發團隊。

---

**最後更新**: 2024年12月  
**版本**: 1.0.0  
**開發團隊**: PM25 App 開發團隊


