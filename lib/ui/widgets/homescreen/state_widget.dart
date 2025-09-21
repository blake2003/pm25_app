import 'package:flutter/cupertino.dart';
import 'package:pm25_app/features/aqi/aqi_provider.dart';
import 'package:pm25_app/features/site_management/site_management_provider.dart';
import 'package:provider/provider.dart';

/// 載入狀態 Widget - iOS 風格
class LoadingStateWidget extends StatelessWidget {
  final String? message;

  const LoadingStateWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CupertinoActivityIndicator(radius: 20),
          const SizedBox(height: 16),
          Text(
            message ?? '載入中...',
            style: TextStyle(
              fontSize: 16,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
        ],
      ),
    );
  }
}

/// 錯誤狀態 Widget - iOS 風格
class ErrorStateWidget extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;
  final String? retryText;

  const ErrorStateWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.retryText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                CupertinoIcons.exclamationmark_triangle,
                size: 48,
                color: CupertinoColors.systemRed,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '載入失敗',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.label,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.secondaryLabel,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              CupertinoButton.filled(
                onPressed: onRetry,
                child: Text(retryText ?? '重新載入'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 錯誤狀態 Widget (帶 Provider 支援) - iOS 風格
class ErrorStateWithProviderWidget extends StatelessWidget {
  final String error;
  final String? retryText;

  const ErrorStateWithProviderWidget({
    super.key,
    required this.error,
    this.retryText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                CupertinoIcons.exclamationmark_triangle,
                size: 48,
                color: CupertinoColors.systemRed,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '載入失敗',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.label,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.secondaryLabel,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Consumer<SiteManagementProvider>(
              builder: (_, siteProvider, __) => CupertinoButton.filled(
                onPressed: () => context
                    .read<AqiProvider>()
                    .loadAqi(siteProvider.currentSite),
                child: Text(retryText ?? '重新載入'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 空資料狀態 Widget - iOS 風格
class EmptyStateWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionText;

  const EmptyStateWidget({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                icon ?? CupertinoIcons.doc_text,
                size: 48,
                color: CupertinoColors.systemGrey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title ?? '暫無資料',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.label,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message ?? '目前沒有可顯示的空氣品質資料',
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.secondaryLabel,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: 24),
              CupertinoButton.filled(
                onPressed: onAction,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 狀態 Widget 工廠類別
class StateWidgets {
  /// 建立載入狀態
  static Widget loading({String? message}) {
    return LoadingStateWidget(message: message);
  }

  /// 建立錯誤狀態
  static Widget error({
    required String error,
    VoidCallback? onRetry,
    String? retryText,
  }) {
    return ErrorStateWidget(
      error: error,
      onRetry: onRetry,
      retryText: retryText,
    );
  }

  /// 建立錯誤狀態 (帶 Provider 支援)
  static Widget errorWithProvider({
    required String error,
    String? retryText,
  }) {
    return ErrorStateWithProviderWidget(
      error: error,
      retryText: retryText,
    );
  }

  /// 建立空資料狀態
  static Widget empty({
    String? title,
    String? message,
    IconData? icon,
    VoidCallback? onAction,
    String? actionText,
  }) {
    return EmptyStateWidget(
      title: title,
      message: message,
      icon: icon,
      onAction: onAction,
      actionText: actionText,
    );
  }
}
