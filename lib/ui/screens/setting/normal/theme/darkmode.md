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
│       
├── ui/
│   └── screens/
│       └── setting/
│           └── normal/
│               ├── darkmode.dart        # 深色模式設定頁面
│               └── darkmode.md          # 開發規範文件
└── main.dart                            # 應用程式入口點
```

### 資料結構設計
```dart
// lib/features/settings/theme_provider.dart
enum ThemeMode { light, dark, system }

// 直接在 Provider 中定義資料結構，避免過度設計
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  DateTime _lastUpdated = DateTime.now();
  
  // Getters
  ThemeMode get themeMode => _themeMode;
  DateTime get lastUpdated => _lastUpdated;
  
  // 更新主題設定
  void _updateTheme(ThemeMode mode) {
    _themeMode = mode;
    _lastUpdated = DateTime.now();
    notifyListeners();
  }
}
```

### Provider 架構設計
```dart
// lib/features/settings/theme_provider.dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  DateTime _lastUpdated = DateTime.now();
  final ThemeRepository _themeRepository;
  final log = AppLogger('ThemeProvider');
  
  ThemeProvider({ThemeRepository? themeRepository}) 
    : _themeRepository = themeRepository ?? ThemeRepository();
  
  // Getters
  ThemeMode get themeMode => _themeMode;
  DateTime get lastUpdated => _lastUpdated;
  
  // 載入主題設定
  Future<void> loadTheme() async {
    try {
      log.i('開始載入主題設定');
      final settings = await _themeRepository.loadThemeSettings();
      _themeMode = settings['themeMode'] ?? ThemeMode.system;
      _lastUpdated = settings['lastUpdated'] ?? DateTime.now();
      notifyListeners();
      log.i('主題設定載入完成: $_themeMode');
    } catch (e, stack) {
      log.e('主題設定載入失敗', e, stack);
      // 使用預設設定
      _themeMode = ThemeMode.system;
      _lastUpdated = DateTime.now();
      notifyListeners();
    }
  }
  
  // 切換主題
  Future<void> toggleTheme(ThemeMode mode) async {
    try {
      log.i('切換主題: $_themeMode -> $mode');
      _themeMode = mode;
      _lastUpdated = DateTime.now();
      notifyListeners();
      
      await _themeRepository.saveThemeSettings({
        'themeMode': mode,
        'lastUpdated': _lastUpdated,
      });
      log.i('主題切換完成並已儲存');
    } catch (e, stack) {
      log.e('主題切換失敗', e, stack);
      rethrow;
    }
  }
}
```

## 🎨 UI/UX 設計規範

### 色彩系統設計
```dart
// lib/core/constants/app_colors.dart
class AppColors {
  // 淺色主題色彩
  static const lightTheme = {
    'background': Color(0xFFFFFFFF),
    'surface': Color(0xFFF5F5F5),
    'primary': Color(0xFF007AFF),
    'secondary': Color(0xFF5856D6),
    'success': Color(0xFF34C759),
    'warning': Color(0xFFFF9500),
    'error': Color(0xFFFF3B30),
    'onBackground': Color(0xFF000000),
    'onSurface': Color(0xFF1C1C1E),
    'onPrimary': Color(0xFFFFFFFF),
    'onSecondary': Color(0xFFFFFFFF),
  };
  
  // 深色主題色彩
  static const darkTheme = {
    'background': Color(0xFF000000),
    'surface': Color(0xFF1C1C1E),
    'primary': Color(0xFF0A84FF),
    'secondary': Color(0xFF5E5CE6),
    'success': Color(0xFF30D158),
    'warning': Color(0xFFFF9F0A),
    'error': Color(0xFFFF453A),
    'onBackground': Color(0xFFFFFFFF),
    'onSurface': Color(0xFFFFFFFF),
    'onPrimary': Color(0xFF000000),
    'onSecondary': Color(0xFF000000),
  };
  
  // 根據主題模式獲取色彩
  static Color getColor(String colorKey, ThemeMode themeMode) {
    final colors = themeMode == ThemeMode.dark ? darkTheme : lightTheme;
    return colors[colorKey] ?? colors['onBackground']!;
  }
}
```

### 主題切換頁面設計
```dart
// lib/ui/screens/setting/normal/darkmode.dart
class DarkModeSettingsScreen extends StatelessWidget {
  const DarkModeSettingsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('深色模式'),
      ),
      child: SafeArea(
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return ListView(
              children: [
                _buildThemeOption(
                  context,
                  themeProvider,
                  ThemeMode.light,
                  '淺色模式',
                  '使用淺色主題',
                  CupertinoIcons.sun_max,
                ),
                _buildThemeOption(
                  context,
                  themeProvider,
                  ThemeMode.dark,
                  '深色模式',
                  '使用深色主題',
                  CupertinoIcons.moon,
                ),
                _buildThemeOption(
                  context,
                  themeProvider,
                  ThemeMode.system,
                  '跟隨系統',
                  '自動跟隨系統設定',
                  CupertinoIcons.settings,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildThemeOption(
    BuildContext context,
    ThemeProvider themeProvider,
    ThemeMode mode,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = themeProvider.themeMode == mode;
    
    return CupertinoListTile(
      leading: Icon(
        icon,
        color: isSelected ? CupertinoColors.activeBlue : CupertinoColors.systemGrey,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: isSelected 
        ? const Icon(CupertinoIcons.check_mark, color: CupertinoColors.activeBlue)
        : null,
      onTap: () => themeProvider.toggleTheme(mode),
    );
  }
}
```

## 🔧 實作指南

### 1. Repository 層實作
```dart
// lib/features/settings/theme_repository.dart
class ThemeRepository {
  static const String _themeKey = 'themeMode';
  static const String _lastUpdatedKey = 'themeLastUpdated';
  final log = AppLogger('ThemeRepository');
  
  // 載入主題設定
  Future<Map<String, dynamic>> loadThemeSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeString = prefs.getString(_themeKey);
      final lastUpdatedString = prefs.getString(_lastUpdatedKey);
      
      ThemeMode themeMode;
      try {
        themeMode = ThemeMode.values.firstWhere(
          (e) => e.toString() == 'ThemeMode.$themeString'
        );
      } catch (e) {
        log.w('無效的主題設定，使用預設值: $themeString');
        themeMode = ThemeMode.system;
      }
      
      DateTime lastUpdated;
      if (lastUpdatedString != null) {
        lastUpdated = DateTime.parse(lastUpdatedString);
      } else {
        lastUpdated = DateTime.now();
      }
      
      return {
        'themeMode': themeMode,
        'lastUpdated': lastUpdated,
      };
    } catch (e, stack) {
      log.e('載入主題設定失敗', e, stack);
      return {
        'themeMode': ThemeMode.system,
        'lastUpdated': DateTime.now(),
      };
    }
  }
  
  // 儲存主題設定
  Future<void> saveThemeSettings(Map<String, dynamic> settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeMode = settings['themeMode'] as ThemeMode;
      final lastUpdated = settings['lastUpdated'] as DateTime;
      
      await prefs.setString(_themeKey, themeMode.toString().split('.').last);
      await prefs.setString(_lastUpdatedKey, lastUpdated.toIso8601String());
      log.i('主題設定儲存成功');
    } catch (e, stack) {
      log.e('儲存主題設定失敗', e, stack);
      rethrow;
    }
  }
}
```

### 2. 應用程式主題配置

#### 2.1 主題配置檔案
```dart
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:pm25_app/core/constants/app_colors.dart';
import 'package:pm25_app/features/settings/theme_provider.dart';

class AppTheme {
  // 淺色主題配置
  static ThemeData buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.getColor('primary', ThemeMode.light),
      scaffoldBackgroundColor: AppColors.getColor('background', ThemeMode.light),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.getColor('surface', ThemeMode.light),
        foregroundColor: AppColors.getColor('onSurface', ThemeMode.light),
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: AppColors.getColor('surface', ThemeMode.light),
        elevation: 2,
      ),
      // 其他主題配置...
    );
  }
  
  // 深色主題配置
  static ThemeData buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.getColor('primary', ThemeMode.dark),
      scaffoldBackgroundColor: AppColors.getColor('background', ThemeMode.dark),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.getColor('surface', ThemeMode.dark),
        foregroundColor: AppColors.getColor('onSurface', ThemeMode.dark),
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: AppColors.getColor('surface', ThemeMode.dark),
        elevation: 2,
      ),
      // 其他主題配置...
    );
  }
}
```

#### 2.2 簡化的 main.dart
```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pm25_app/core/theme/app_theme.dart';
import 'package:pm25_app/features/settings/theme_provider.dart';
import 'package:pm25_app/ui/screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider()..loadTheme(),
        ),
        // 其他 Provider...
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'PM25 App',
            theme: AppTheme.buildLightTheme(),
            darkTheme: AppTheme.buildDarkTheme(),
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
```

## 📝 程式碼規範

### 命名規範
- **檔案名稱**: `snake_case` (例: `theme_provider.dart`)
- **類別名稱**: `PascalCase` (例: `ThemeProvider`)
- **變數/函數**: `camelCase` (例: `themeMode`, `toggleTheme()`)
- **常數**: `SCREAMING_SNAKE_CASE` (例: `THEME_KEY`)

### 日誌使用規範
```dart
// 使用 AppLogger 進行日誌記錄
final log = AppLogger('ThemeProvider');

// 正確的日誌使用
log.i('主題切換開始: ${oldMode} -> ${newMode}');
log.d('載入主題設定: $settings');
log.w('使用預設主題設定');
log.e('主題切換失敗', error, stackTrace);
```

### 錯誤處理規範
```dart
// 使用 try-catch 進行錯誤處理
try {
  await themeProvider.toggleTheme(ThemeMode.dark);
} catch (e, stack) {
  log.e('主題切換失敗', e, stack);
  // 顯示錯誤訊息給使用者
  _showErrorDialog(context, '主題切換失敗，請稍後再試');
}
```

## 🧪 測試規範

### 測試檔案結構
```
test/
├── features/
│   └── settings/
│       ├── theme_provider_test.dart
│       ├── theme_repository_test.dart
│       
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

### 測試覆蓋要求
- **程式碼覆蓋率**: 至少 80%
- **關鍵路徑覆蓋**: 100%
- **錯誤處理覆蓋**: 100%

## 🔒 安全性規範

### 資料儲存安全
- 使用 `SharedPreferences` 進行本地儲存
- 敏感資料不應儲存在本地
- 定期清理過期的設定資料

### 輸入驗證
```dart
// 驗證主題模式值
ThemeMode validateThemeMode(String value) {
  try {
    return ThemeMode.values.firstWhere(
      (e) => e.toString() == 'ThemeMode.$value'
    );
  } catch (e) {
    log.w('無效的主題模式值: $value，使用預設值');
    return ThemeMode.system;
  }
}

// Repository 中的驗證
class ThemeRepository {
  // ... 其他程式碼 ...
  
  ThemeMode _validateThemeMode(String? themeString) {
    if (themeString == null) return ThemeMode.system;
    
    try {
      return ThemeMode.values.firstWhere(
        (e) => e.toString() == 'ThemeMode.$themeString'
      );
    } catch (e) {
      log.w('無效的主題設定，使用預設值: $themeString');
      return ThemeMode.system;
    }
  }
}
```

## 📱 效能優化

### 主題切換效能
- 主題切換應在 100ms 內完成
- 使用 `ChangeNotifier` 進行狀態管理
- 避免不必要的 UI 重建

### 記憶體管理
```dart
// 在 dispose 方法中清理資源
@override
void dispose() {
  // 清理資源
  super.dispose();
}
```

## 🔄 版本控制

### Commit 訊息規範
```
feat(theme): 新增深色模式切換功能

- 實作 ThemeProvider 狀態管理
- 新增主題設定頁面
- 完成主題切換測試

Closes #123
```

### 分支命名規範
- `feature/theme-dark-mode` - 新功能分支
- `fix/theme-switch-bug` - 修復分支
- `test/theme-coverage` - 測試分支

## 📚 文檔維護

### 更新檢查清單
- [ ] 更新 API 文檔
- [ ] 更新測試文檔
- [ ] 更新使用者指南
- [ ] 更新開發者指南

### 版本記錄
```markdown
## [1.0.0] - 2025-01-XX
### 新增
- 深色模式切換功能
- 主題設定頁面
- 完整的測試覆蓋

### 修復
- 主題切換效能優化
- 錯誤處理改進
```

## 🔧 實際實現指南

### 實現步驟

1. **創建主題配置檔案**:
   ```dart
   // 創建 lib/core/theme/app_theme.dart
   import 'package:flutter/material.dart';
   import 'package:pm25_app/core/constants/app_colors.dart';
   import 'package:pm25_app/features/settings/theme_provider.dart';
   ```

2. **創建 Repository**:
   ```dart
   // 創建 lib/features/settings/theme_repository.dart
   import 'package:shared_preferences/shared_preferences.dart';
   import 'package:pm25_app/core/loggers/log.dart';
   ```

3. **添加 SharedPreferences 依賴**:
   ```dart
   // 在 pubspec.yaml 中添加
   shared_preferences: ^2.2.2
   ```

4. **實現 Provider**:
   ```dart
   // 創建 lib/features/settings/theme_provider.dart
   import 'package:provider/provider.dart';
   import 'package:pm25_app/features/settings/theme_repository.dart';
   ```

5. **添加測試**:
   ```dart
   // 使用 mockito 進行 Repository 測試
   @GenerateMocks([SharedPreferences])
   import 'theme_repository_test.mocks.dart';
   ```

6. **更新主應用程式**:
   ```dart
   // 在 lib/main.dart 中配置 Provider 和主題
   import 'package:pm25_app/core/theme/app_theme.dart';
   
   MultiProvider(
     providers: [
       ChangeNotifierProvider(create: (context) => ThemeProvider()),
     ],
     child: MyApp(),
   )
   ```

### 依賴管理
```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.5
  shared_preferences: ^2.2.2

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

### 發布前檢查
- [ ] 所有測試通過
- [ ] 程式碼審查完成
- [ ] 效能測試達標
- [ ] 安全性掃描通過
- [ ] 文檔更新完成

---

**最後更新**: 2025年08月  
**版本**: 1.0.0  
**適用範圍**: PM25 應用程式深色模式開發規範
