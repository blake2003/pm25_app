import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:pm25_app/core/loggers/log.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _log = AppLogger('SettingsScreen');
  var logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  // 設定狀態
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = '繁體中文';
  String _selectedTheme = '自動';

  // 語言選項
  final List<String> _languages = [
    '繁體中文',
    'English',
    '日本語',
    '한국어',
  ];

  // 主題選項
  final List<String> _themes = [
    '自動',
    '淺色',
    '深色',
  ];

  @override
  void initState() {
    super.initState();
    _log.i('設定頁面初始化');
    _loadSettings();
  }

  /// 載入設定
  Future<void> _loadSettings() async {
    // TODO: 從 SharedPreferences 載入設定
    _log.d('載入使用者設定');
    logger.i('載入使用者設定');
    logger.d("Debug log");
  }

  /// 儲存設定
  Future<void> _saveSettings() async {
    // TODO: 儲存到 SharedPreferences
    _log.w('儲存使用者設定');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('設定'),
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        border: null,
      ),
      child: SafeArea(
        child: ListView(
          children: [
            _buildSectionHeader('一般設定'),
            _buildGeneralSettings(),
            _buildSectionHeader('通知設定'),
            _buildNotificationSettings(),
            _buildSectionHeader('關於'),
            _buildAboutSection(),
          ],
        ),
      ),
    );
  }

  /// 建立區段標題
  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.systemGrey.resolveFrom(context),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// 建立一般設定區段
  Widget _buildGeneralSettings() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.separator.resolveFrom(context),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          // 語言設定
          _buildSettingsRow(
            icon: CupertinoIcons.globe,
            title: '語言',
            subtitle: _selectedLanguage,
            onTap: () => _showLanguagePicker(),
          ),

          _buildDivider(),

          // 主題設定
          _buildSettingsRow(
            icon: CupertinoIcons.paintbrush,
            title: '主題',
            subtitle: _selectedTheme,
            onTap: () => _showThemePicker(),
          ),

          _buildDivider(),

          // 深色模式
          _buildSwitchRow(
            icon: CupertinoIcons.moon,
            title: '深色模式',
            subtitle: '使用深色主題',
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
              _saveSettings();
              _log.i('深色模式設定變更: $value');
            },
          ),
        ],
      ),
    );
  }

  /// 建立通知設定區段
  Widget _buildNotificationSettings() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.separator.resolveFrom(context),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          // 通知開關
          _buildSwitchRow(
            icon: CupertinoIcons.bell,
            title: '推播通知',
            subtitle: '接收空氣品質提醒',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              _saveSettings();
              _log.i('通知設定變更: $value');
            },
          ),

          _buildDivider(),

          // 通知設定（僅在通知開啟時顯示）
          if (_notificationsEnabled) ...[
            _buildSettingsRow(
              icon: CupertinoIcons.settings,
              title: '通知設定',
              subtitle: '自訂通知內容',
              onTap: () {
                _log.d('開啟通知設定頁面');
                // TODO: 導航到詳細通知設定頁面
              },
            ),
          ],
        ],
      ),
    );
  }

  /// 建立關於區段
  Widget _buildAboutSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.separator.resolveFrom(context),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          // 版本資訊
          _buildSettingsRow(
            icon: CupertinoIcons.info_circle,
            title: '版本',
            subtitle: '1.0.0',
            onTap: () {
              _log.d('查看版本詳細資訊');
              _showVersionInfo();
            },
          ),

          _buildDivider(),

          // 隱私政策
          _buildSettingsRow(
            icon: CupertinoIcons.shield,
            title: '隱私政策',
            subtitle: '查看隱私保護說明',
            onTap: () {
              _log.d('開啟隱私政策');
              // TODO: 導航到隱私政策頁面
            },
          ),

          _buildDivider(),

          // 使用條款
          _buildSettingsRow(
            icon: CupertinoIcons.doc_text,
            title: '使用條款',
            subtitle: '查看服務條款',
            onTap: () {
              _log.d('開啟使用條款');
              // TODO: 導航到使用條款頁面
            },
          ),

          _buildDivider(),

          // 意見回饋
          _buildSettingsRow(
            icon: CupertinoIcons.chat_bubble,
            title: '意見回饋',
            subtitle: '告訴我們您的想法',
            onTap: () {
              _log.d('開啟意見回饋');
              _showFeedbackDialog();
            },
          ),
        ],
      ),
    );
  }

  /// 建立設定列
  Widget _buildSettingsRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey5.resolveFrom(context),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 18,
                color: CupertinoColors.systemGrey.resolveFrom(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.label,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey.resolveFrom(context),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: CupertinoColors.systemGrey3.resolveFrom(context),
            ),
          ],
        ),
      ),
    );
  }

  /// 建立開關列
  Widget _buildSwitchRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey5.resolveFrom(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: CupertinoColors.systemGrey.resolveFrom(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.label,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey.resolveFrom(context),
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: CupertinoColors.activeBlue,
          ),
        ],
      ),
    );
  }

  /// 建立分隔線
  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.only(left: 44),
      height: 0.5,
      color: CupertinoColors.separator.resolveFrom(context),
    );
  }

  /// 顯示語言選擇器
  void _showLanguagePicker() {
    _log.d('開啟語言選擇器');
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: CupertinoColors.separator.resolveFrom(context),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: const Text('取消'),
                  ),
                  const Text(
                    '選擇語言',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        _selectedLanguage = _languages.first;
                      });
                      _saveSettings();
                      Navigator.pop(context);
                      _log.i('語言設定變更: $_selectedLanguage');
                    },
                    child: const Text('確定'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 50,
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedLanguage = _languages[index];
                  });
                },
                children: _languages
                    .map((language) => Center(child: Text(language)))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 顯示主題選擇器
  void _showThemePicker() {
    _log.d('開啟主題選擇器');
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: CupertinoColors.separator.resolveFrom(context),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: const Text('取消'),
                  ),
                  const Text(
                    '選擇主題',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        _selectedTheme = _themes.first;
                      });
                      _saveSettings();
                      Navigator.pop(context);
                      _log.i('主題設定變更: $_selectedTheme');
                    },
                    child: const Text('確定'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 50,
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedTheme = _themes[index];
                  });
                },
                children:
                    _themes.map((theme) => Center(child: Text(theme))).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 顯示版本資訊
  void _showVersionInfo() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('版本資訊'),
        content: const Column(
          children: [
            SizedBox(height: 8),
            Text('PM25 空氣品質監測'),
            SizedBox(height: 4),
            Text('版本 1.0.0'),
            SizedBox(height: 4),
            Text('© 2025 PM25 App'),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('確定'),
          ),
        ],
      ),
    );
  }

  /// 顯示意見回饋對話框
  void _showFeedbackDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('意見回饋'),
        content: const Text('感謝您使用 PM25 應用程式！\n\n您的意見對我們非常重要，請告訴我們您的想法和建議。'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
              _log.i('使用者開啟意見回饋');
              // TODO: 開啟意見回饋表單或郵件
            },
            child: const Text('發送回饋'),
          ),
        ],
      ),
    );
  }
}
