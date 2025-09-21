import 'package:flutter/cupertino.dart';
import 'package:pm25_app/core/constants/language/l10n/app_localizations.dart';
import 'package:pm25_app/core/loggers/log.dart';
import 'package:pm25_app/features/site_management/site_management_provider.dart';
import 'package:provider/provider.dart';

/// 站點管理對話框組件
class SiteManagementDialog {
  static final _log = AppLogger('SiteManagementDialog');

  /// 顯示添加站點對話框
  static Future<bool> showAddSiteDialog(BuildContext context) async {
    _log.d('顯示添加站點對話框');

    final provider = context.read<SiteManagementProvider>();
    final availableSites = provider.getAvailableSites();

    if (availableSites.isEmpty) {
      // 已無可添加地區
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('無可添加地區'),
          content: const Text('所有地區都已添加。'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(AppLocalizations.of(context)!.confirmAction),
            ),
          ],
        ),
      );
      return false;
    }

    // 初始化選擇的站點為可用站點列表的第一個
    String? selectedSite = availableSites.isNotEmpty ? availableSites[0] : null;

    final bool? confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context)!.selectRegion),
        content: SizedBox(
          height: 200,
          child: CupertinoPicker(
            itemExtent: 40,
            onSelectedItemChanged: (index) {
              selectedSite = availableSites[index];
              _log.d('選擇添加站點: $selectedSite');
            },
            children:
                availableSites.map((s) => Center(child: Text(s))).toList(),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              _log.d('取消按鈕點擊');
              Navigator.of(ctx).pop(false); // 返回 false 表示取消
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          CupertinoDialogAction(
            onPressed: () {
              _log.d('確定按鈕點擊，selectedSite: $selectedSite');
              if (selectedSite != null) {
                Navigator.of(ctx).pop(true); // 返回 true 表示確認添加
              }
            },
            child: Text(AppLocalizations.of(context)!.confirmAction),
          ),
        ],
      ),
    );

    _log.d('對話框關閉，confirmed: $confirmed, selectedSite: $selectedSite');

    // 如果用戶取消，直接返回
    if (confirmed != true) {
      _log.d('用戶取消添加操作');
      return false;
    }

    // 如果沒有選擇站點，直接返回
    if (selectedSite == null) {
      _log.d('沒有選擇站點');
      return false;
    }

    // 執行添加站點
    try {
      final success = await provider.addSite(selectedSite!);
      if (success) {
        _log.i('成功添加站點: $selectedSite');
        return true;
      } else {
        _log.w('添加站點失敗: $selectedSite');
        return false;
      }
    } catch (e, stack) {
      _log.e('添加站點異常', e, stack);
      return false;
    }
  }

  /// 顯示刪除站點對話框
  static Future<bool> showDeleteSiteDialog(BuildContext context) async {
    _log.d('顯示刪除站點對話框');

    final provider = context.read<SiteManagementProvider>();

    // 如果只有一個站點，不允許刪除
    if (!provider.canDeleteSite()) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context)!.deleteFailed),
          content: Text(AppLocalizations.of(context)!.deleteFailedMessage),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(AppLocalizations.of(context)!.confirmAction),
            ),
          ],
        ),
      );
      return false;
    }

    String? selectedSite = provider.sites.isNotEmpty ? provider.sites[0] : null;

    final bool? confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context)!.selectRegion),
        content: SizedBox(
          height: 200,
          child: CupertinoPicker(
            itemExtent: 40,
            onSelectedItemChanged: (index) {
              selectedSite = provider.sites[index];
              _log.d('選擇刪除站點: $selectedSite');
            },
            children:
                provider.sites.map((s) => Center(child: Text(s))).toList(),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              _log.d('取消按鈕點擊');
              Navigator.of(ctx).pop(false); // 返回 false 表示取消
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              _log.d('刪除按鈕點擊，selectedSite: $selectedSite');
              if (selectedSite != null) {
                Navigator.of(ctx).pop(true); // 返回 true 表示確認刪除
              }
            },
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    _log.d('刪除對話框關閉，confirmed: $confirmed, selectedSite: $selectedSite');

    // 如果用戶取消，直接返回
    if (confirmed != true) {
      _log.d('用戶取消刪除操作');
      return false;
    }

    // 如果沒有選擇站點，直接返回
    if (selectedSite == null) {
      _log.d('沒有選擇要刪除的站點');
      return false;
    }

    // 確認刪除對話框
    final bool? confirmDelete = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context)!.confirmAction),
        content: Text('確定要刪除「$selectedSite」嗎？\n此操作無法復原。'), //待翻譯
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    _log.d(
        '確認刪除對話框關閉，confirmDelete: $confirmDelete, selectedSite: $selectedSite');

    if (confirmDelete == true) {
      // 執行刪除站點
      try {
        final success = await provider.deleteSite(selectedSite!);
        if (success) {
          _log.i('成功刪除站點: $selectedSite');
          return true;
        } else {
          _log.w('刪除站點失敗: $selectedSite');
          return false;
        }
      } catch (e, stack) {
        _log.e('刪除站點異常', e, stack);
        return false;
      }
    } else {
      _log.d('用戶在確認對話框中取消刪除');
      return false;
    }
  }

  /// 顯示站點管理選項對話框
  static Future<void> showSiteManagementOptions(BuildContext context) async {
    _log.d('顯示站點管理選項對話框');

    final provider = context.read<SiteManagementProvider>();

    final String? action = await showCupertinoDialog<String>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context)!.siteManagement),
        content: Text('當前有 ${provider.siteCount} 個站點'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop('add'),
            child: Text(AppLocalizations.of(context)!.addSite),
          ),
          if (provider.canDeleteSite())
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop('delete'),
              child: Text(AppLocalizations.of(context)!.deleteSite),
            ),
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop('reset'),
            child: Text(AppLocalizations.of(context)!.resetToDefault),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop('cancel'),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ],
      ),
    );

    switch (action) {
      case 'add':
        await showAddSiteDialog(context);
        break;
      case 'delete':
        await showDeleteSiteDialog(context);
        break;
      case 'reset':
        await _showResetConfirmation(context);
        break;
      case 'cancel':
      default:
        _log.d('用戶取消站點管理操作');
        break;
    }
  }

  /// 顯示重置確認對話框
  static Future<void> _showResetConfirmation(BuildContext context) async {
    _log.d('顯示重置確認對話框');

    final bool? confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context)!.confirmAction),
        content: const Text('確定要將站點列表重置為默認值嗎？\n此操作無法復原。'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(AppLocalizations.of(context)!.reset),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final provider = context.read<SiteManagementProvider>();
      await provider.resetToDefault();
      _log.i('成功重置站點列表為默認值');
    }
  }
}
