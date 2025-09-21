import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pm25_app/core/constants/language/l10n/app_localizations.dart';
import 'package:pm25_app/core/constants/theme/theme_colors.dart';
import 'package:pm25_app/core/loggers/log.dart';
import 'package:pm25_app/features/settings/theme/auto_theme/time_provider.dart';
import 'package:pm25_app/features/settings/theme/theme_provider.dart';
import 'package:provider/provider.dart';

/// 深色模式設定頁面
/// 提供主題切換功能，支援淺色、深色和自動模式
class DarkModeSettingsPage extends StatefulWidget {
  const DarkModeSettingsPage({super.key});

  @override
  State<DarkModeSettingsPage> createState() => _DarkModeSettingsPageState();
}

class _DarkModeSettingsPageState extends State<DarkModeSettingsPage> {
  final log = AppLogger('DarkModeSettingsPage');
  final TimeProvider _timeScheduleManager = TimeProvider();
  bool _isAutoSettingsExpanded = false;

  /// 輔助方法：獲取顏色，自動處理解析後的主題模式
  Color _getColor(String colorKey, ThemeProvider themeProvider,
      AppThemeMode resolvedThemeMode) {
    return AppColors.getColor(
        colorKey, themeProvider.themeMode, resolvedThemeMode);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // 獲取解析後的主題模式，確保自動模式下使用正確的顏色
        final resolvedThemeMode = themeProvider.resolvedThemeMode;

        return Scaffold(
          appBar: AppBar(
            title: Text(
                AppLocalizations.of(context)?.appearanceSettings ?? '外觀設定'),
            backgroundColor:
                _getColor('surface', themeProvider, resolvedThemeMode),
            foregroundColor:
                _getColor('onSurface', themeProvider, resolvedThemeMode),
            elevation: 0,
            centerTitle: true,
          ),
          backgroundColor:
              _getColor('background', themeProvider, resolvedThemeMode),
          body: SafeArea(
            child: Column(
              children: [
                // 主題選項列表
                _buildThemeOptions(themeProvider, resolvedThemeMode),

                // 說明文字
                _buildDescription(),

                Spacer(),

                // 版本資訊
                _buildVersionInfo(),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 建立主題選項列表
  Widget _buildThemeOptions(
      ThemeProvider themeProvider, AppThemeMode resolvedThemeMode) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getColor('surface', themeProvider, resolvedThemeMode),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getColor('border', themeProvider, resolvedThemeMode),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          // 自動模式
          _buildAutoThemeOption(themeProvider),

          _buildDivider(),

          // 淺色模式
          _buildThemeOption(
            icon: CupertinoIcons.sun_max,
            title: AppLocalizations.of(context)?.light ?? '淺色',
            subtitle: AppLocalizations.of(context)?.useLightTheme ?? '使用淺色主題',
            isSelected: themeProvider.isLightTheme,
            onTap: () => _selectTheme(themeProvider, AppThemeMode.light),
          ),

          _buildDivider(),

          // 深色模式
          _buildThemeOption(
            icon: CupertinoIcons.moon,
            title: AppLocalizations.of(context)?.dark ?? '深色',
            subtitle: AppLocalizations.of(context)?.useDarkTheme ?? '使用深色主題',
            isSelected: themeProvider.isDarkTheme,
            onTap: () => _selectTheme(themeProvider, AppThemeMode.dark),
          ),
        ],
      ),
    );
  }

  /// 建立自動主題選項（包含時間設定）
  Widget _buildAutoThemeOption(ThemeProvider themeProvider) {
    return Column(
      children: [
        // 自動模式選項
        _buildThemeOption(
          icon: CupertinoIcons.device_phone_portrait,
          title: AppLocalizations.of(context)?.auto ?? '自動',
          subtitle:
              AppLocalizations.of(context)?.switchBasedOnTime ?? '根據時間自動切換',
          isSelected: themeProvider.isAutoTheme,
          onTap: () => _toggleAutoSettings(themeProvider),
          showExpandIcon: true,
          isExpanded: _isAutoSettingsExpanded,
        ),

        // 時間設定下拉窗口
        if (_isAutoSettingsExpanded) _buildAutoTimeSettings(themeProvider),
      ],
    );
  }

  /// 建立主題選項項目
  Widget _buildThemeOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    bool showExpandIcon = false,
    bool isExpanded = false,
  }) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final resolvedThemeMode = themeProvider.resolvedThemeMode;

        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // 圖示
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _getColor('primary', themeProvider, resolvedThemeMode)
                        : _getColor(
                            'systemGrey6', themeProvider, resolvedThemeMode),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? _getColor(
                            'onPrimary', themeProvider, resolvedThemeMode)
                        : _getColor(
                            'systemGrey', themeProvider, resolvedThemeMode),
                    size: 20,
                  ),
                ),

                SizedBox(width: 16),

                // 文字內容
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: _getColor(
                              'textPrimary', themeProvider, resolvedThemeMode),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: _getColor('textSecondary', themeProvider,
                              resolvedThemeMode),
                        ),
                      ),
                    ],
                  ),
                ),

                // 選中指示器或展開圖示
                if (showExpandIcon)
                  Icon(
                    isExpanded
                        ? CupertinoIcons.chevron_up
                        : CupertinoIcons.chevron_down,
                    color: _getColor(
                        'systemGrey', themeProvider, resolvedThemeMode),
                    size: 20,
                  )
                else if (isSelected)
                  Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color:
                        _getColor('primary', themeProvider, resolvedThemeMode),
                    size: 24,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 建立自動時間設定下拉窗口
  Widget _buildAutoTimeSettings(ThemeProvider themeProvider) {
    final resolvedThemeMode = themeProvider.resolvedThemeMode;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getColor('systemGrey6', themeProvider, resolvedThemeMode),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getColor('border', themeProvider, resolvedThemeMode),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)?.autoSwitchTimeSettings ?? '自動切換時間設定',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _getColor('textPrimary', themeProvider, resolvedThemeMode),
            ),
          ),
          SizedBox(height: 12),

          // 白天開始時間
          FutureBuilder<String>(
            future: _getCurrentDayStartTime(),
            builder: (context, snapshot) {
              return _buildTimeSettingRowWithValue(
                AppLocalizations.of(context)?.dayStartTime ?? '白天開始時間',
                AppLocalizations.of(context)?.lightThemeStartTime ?? '淺色主題開始時間',
                () => _showTimePicker('dayStart', themeProvider),
                snapshot.data ?? '07:00',
              );
            },
          ),

          SizedBox(height: 12),

          // 夜晚開始時間
          FutureBuilder<String>(
            future: _getCurrentNightStartTime(),
            builder: (context, snapshot) {
              return _buildTimeSettingRowWithValue(
                AppLocalizations.of(context)?.nightStartTime ?? '夜晚開始時間',
                AppLocalizations.of(context)?.darkThemeStartTime ?? '深色主題開始時間',
                () => _showTimePicker('nightStart', themeProvider),
                snapshot.data ?? '19:00',
              );
            },
          ),

          SizedBox(height: 16),

          // 重置按鈕
          Row(
            children: [
              Expanded(
                child: CupertinoButton(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  color: _getColor(
                      'systemGrey5', themeProvider, resolvedThemeMode),
                  borderRadius: BorderRadius.circular(8),
                  onPressed: () => _resetToDefaultTime(themeProvider),
                  child: Text(
                    AppLocalizations.of(context)?.resetToDefault ?? '重置為預設',
                    style: TextStyle(
                      color: _getColor(
                          'textPrimary', themeProvider, resolvedThemeMode),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 獲取當前白天開始時間（格式化）
  Future<String> _getCurrentDayStartTime() async {
    try {
      final dayTime = await _timeScheduleManager.getDayStartTime();
      final hour = dayTime['hour']!;
      final minute = dayTime['minute']!;
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '07:00'; // 預設值
    }
  }

  /// 獲取當前夜晚開始時間（格式化）
  Future<String> _getCurrentNightStartTime() async {
    try {
      final nightTime = await _timeScheduleManager.getNightStartTime();
      final hour = nightTime['hour']!;
      final minute = nightTime['minute']!;
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '19:00'; // 預設值
    }
  }

  /// 建立時間設定行（帶時間值顯示）
  Widget _buildTimeSettingRowWithValue(
      String title, String subtitle, VoidCallback onTap, String timeValue) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final resolvedThemeMode = themeProvider.resolvedThemeMode;

        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: _getColor('surface', themeProvider, resolvedThemeMode),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getColor('border', themeProvider, resolvedThemeMode),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: _getColor(
                              'textPrimary', themeProvider, resolvedThemeMode),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: _getColor('textSecondary', themeProvider,
                              resolvedThemeMode),
                        ),
                      ),
                    ],
                  ),
                ),
                // 顯示當前時間值
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getColor(
                        'systemGrey6', themeProvider, resolvedThemeMode),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    timeValue,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _getColor(
                          'textPrimary', themeProvider, resolvedThemeMode),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  CupertinoIcons.chevron_right,
                  color:
                      _getColor('systemGrey', themeProvider, resolvedThemeMode),
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 建立分割線
  Widget _buildDivider() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final resolvedThemeMode = themeProvider.resolvedThemeMode;

        return Container(
          height: 0.5,
          margin: EdgeInsets.symmetric(horizontal: 16),
          color: _getColor('separator', themeProvider, resolvedThemeMode),
        );
      },
    );
  }

  /// 建立說明文字
  Widget _buildDescription() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final resolvedThemeMode = themeProvider.resolvedThemeMode;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _getColor('systemGrey6', themeProvider, resolvedThemeMode),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.info_circle,
                color:
                    _getColor('systemGrey', themeProvider, resolvedThemeMode),
                size: 20,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)?.autoModeDescription ??
                      '選擇「自動」模式將根據設定的時間自動切換主題。點擊自動選項可自訂切換時間（使用24小時制）。您也可以手動選擇淺色或深色主題。',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: _getColor(
                        'textSecondary', themeProvider, resolvedThemeMode),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 建立版本資訊
  Widget _buildVersionInfo() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final resolvedThemeMode = themeProvider.resolvedThemeMode;

        return Container(
          padding: EdgeInsets.all(16),
          child: Text(
            AppLocalizations.of(context)?.appVersion ?? 'PM25 空氣品質監測 v1.0.0',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color:
                  _getColor('textTertiary', themeProvider, resolvedThemeMode),
            ),
          ),
        );
      },
    );
  }

  /// 切換自動設定展開狀態
  void _toggleAutoSettings(ThemeProvider themeProvider) async {
    try {
      setState(() {
        _isAutoSettingsExpanded = !_isAutoSettingsExpanded;
      });

      // 如果展開且當前不是自動模式，則切換到自動模式
      if (_isAutoSettingsExpanded && !themeProvider.isAutoTheme) {
        _selectTheme(themeProvider, AppThemeMode.auto);
      }
    } catch (e, stack) {
      log.e('切換自動設定失敗', e, stack);
    }
  }

  /// 顯示時間選擇器
  void _showTimePicker(String timeType, ThemeProvider themeProvider) async {
    try {
      // 獲取當前時間設定
      final currentTime = timeType == 'dayStart'
          ? await _timeScheduleManager.getDayStartTime()
          : await _timeScheduleManager.getNightStartTime();

      final currentHour = currentTime['hour']!;
      final currentMinute = currentTime['minute']!;

      // 顯示時間選擇器
      showCupertinoModalPopup(
        context: context,
        builder: (context) => Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            final resolvedThemeMode = themeProvider.resolvedThemeMode;

            return Container(
              height: 300,
              color: _getColor('surface', themeProvider, resolvedThemeMode),
              child: Column(
                children: [
                  // 標題欄
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _getColor(
                              'separator', themeProvider, resolvedThemeMode),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            AppLocalizations.of(context)?.cancel ?? '取消',
                            style: TextStyle(
                              color: _getColor(
                                  'primary', themeProvider, resolvedThemeMode),
                            ),
                          ),
                        ),
                        Text(
                          timeType == 'dayStart'
                              ? (AppLocalizations.of(context)
                                      ?.setDayStartTime ??
                                  '設定白天開始時間')
                              : (AppLocalizations.of(context)
                                      ?.setNightStartTime ??
                                  '設定夜晚開始時間'),
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: _getColor('textPrimary', themeProvider,
                                resolvedThemeMode),
                          ),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            // 完成時間設定變更並輸出 log（如果有變更的話）
                            _timeScheduleManager.completeTimeSettings();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            AppLocalizations.of(context)?.done ?? '完成',
                            style: TextStyle(
                              color: _getColor(
                                  'primary', themeProvider, resolvedThemeMode),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 時間選擇器（24小時制）
                  Expanded(
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: true, // 明確使用24小時制
                      initialDateTime:
                          DateTime(2024, 1, 1, currentHour, currentMinute),
                      onDateTimeChanged: (DateTime newDateTime) async {
                        try {
                          if (timeType == 'dayStart') {
                            await _timeScheduleManager.setDayStartTime(
                                newDateTime.hour, newDateTime.minute);
                          } else {
                            await _timeScheduleManager.setNightStartTime(
                                newDateTime.hour, newDateTime.minute);
                          }

                          // 如果當前是自動模式，重新啟動自動切換服務
                          if (themeProvider.isAutoTheme) {
                            await themeProvider.triggerAutoSwitch();
                          }

                          // 時間設定已更新，但不在這裡輸出 log
                        } catch (e, stack) {
                          log.e('更新時間設定失敗', e, stack);
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    } catch (e, stack) {
      log.e('顯示時間選擇器失敗', e, stack);
    }
  }

  /// 重置為預設時間
  void _resetToDefaultTime(ThemeProvider themeProvider) async {
    try {
      await _timeScheduleManager.resetToDefault();

      // 完成重置並輸出 log
      _timeScheduleManager.completeTimeSettings();

      // 如果當前是自動模式，重新啟動自動切換服務
      if (themeProvider.isAutoTheme) {
        await themeProvider.triggerAutoSwitch();
      }

      // 顯示成功訊息
      _showTimeResetMessage();
    } catch (e, stack) {
      log.e('重置時間設定失敗', e, stack);
      _showErrorMessage();
    }
  }

  /// 顯示時間重置成功訊息
  void _showTimeResetMessage() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context)?.resetSuccess ?? '重置成功'),
        content: Text(AppLocalizations.of(context)?.resetSuccessMessage ??
            '時間設定已重置為預設值（07:00 / 19:00）\n使用24小時制格式'),
        actions: [
          CupertinoDialogAction(
            child: Text(AppLocalizations.of(context)?.ok ?? '確定'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  /// 選擇主題
  void _selectTheme(ThemeProvider themeProvider, AppThemeMode themeMode) async {
    try {
      // 顯示載入指示器
      showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CupertinoAlertDialog(
          content: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoActivityIndicator(),
                SizedBox(width: 16),
                Text(
                    AppLocalizations.of(context)?.switchingTheme ?? '切換主題中...'),
              ],
            ),
          ),
        ),
      );

      // 切換主題
      await themeProvider.toggleTheme(themeMode);

      // 關閉載入指示器
      Navigator.of(context).pop();

      // 顯示成功訊息
      _showSuccessMessage(themeMode);
    } catch (e, stack) {
      log.e('主題切換失敗', e, stack);

      // 關閉載入指示器
      Navigator.of(context).pop();

      // 顯示錯誤訊息
      _showErrorMessage();
    }
  }

  /// 顯示成功訊息
  void _showSuccessMessage(AppThemeMode themeMode) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title:
            Text(AppLocalizations.of(context)?.themeSwitchSuccess ?? '主題切換成功'),
        content: Text(AppLocalizations.of(context)
                ?.themeSwitchSuccessMessage(themeMode) ??
            '已切換到${AppColors.getLocalizedThemeModeDescription(themeMode, context)}主題'),
        actions: [
          CupertinoDialogAction(
            child: Text(AppLocalizations.of(context)?.ok ?? '確定'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  /// 顯示錯誤訊息
  void _showErrorMessage() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context)?.switchFailed ?? '切換失敗'),
        content: Text(AppLocalizations.of(context)?.switchFailedMessage ??
            '主題切換失敗，請稍後再試'),
        actions: [
          CupertinoDialogAction(
            child: Text(AppLocalizations.of(context)?.ok ?? '確定'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
