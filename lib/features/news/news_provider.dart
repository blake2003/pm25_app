import 'package:flutter/material.dart';
import 'package:pm25_app/core/loggers/log.dart';
import 'package:pm25_app/features/news/model.dart';
import 'package:pm25_app/features/news/news_service.dart';

class NewsProvider extends ChangeNotifier {
  static final _logger = AppLogger('NewsProvider');

  // 私有狀態變數
  List<NewsArticle> _newsList = [];
  bool _isLoading = false;
  String? _error;
  DateTime? _lastFetchTime;

  // 公開 getter
  List<NewsArticle> get newsList => _newsList;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastFetchTime => _lastFetchTime;
  bool get hasData => _newsList.isNotEmpty;
  bool get hasError => _error != null;

  /// 檢查是否需要載入資料
  /// 如果沒有資料且不在載入中，則需要載入
  bool get shouldLoadData => _newsList.isEmpty && !_isLoading && _error == null;

  /// 格式化最後更新時間
  String get formattedLastFetchTime {
    if (_lastFetchTime == null) return '尚未載入';
    final now = DateTime.now();
    final difference = now.difference(_lastFetchTime!);

    if (difference.inMinutes < 1) {
      return '剛剛更新';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} 分鐘前更新';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} 小時前更新';
    } else {
      return '${difference.inDays} 天前更新';
    }
  }

  /// 初始化載入新聞資料
  /// 只有在沒有資料時才會載入
  Future<void> initializeNews() async {
    if (shouldLoadData) {
      _logger.i('初始化載入新聞資料');
      await _fetchNews();
    } else {
      _logger.i('新聞資料已存在，跳過初始化載入');
    }
  }

  /// 重新整理新聞資料
  /// 用戶主動請求更新時使用
  Future<void> refreshNews() async {
    _logger.i('用戶請求重新整理新聞');
    await _fetchNews();
  }

  /// 清除錯誤狀態
  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  /// 私有方法：實際執行新聞資料獲取
  Future<void> _fetchNews() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _logger.i('開始從 API 獲取新聞資料');
      final newsData = await NewsService.fetchNews();

      _newsList = newsData;
      _lastFetchTime = DateTime.now();

      _logger.i('成功獲取 ${newsData.length} 條新聞資料');
    } catch (e) {
      _error = e.toString();
      _logger.e('獲取新聞資料失敗: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 重置狀態（用於測試或清除資料）
  void reset() {
    _newsList = [];
    _isLoading = false;
    _error = null;
    _lastFetchTime = null;
    notifyListeners();
    _logger.i('新聞 Provider 狀態已重置');
  }
}
