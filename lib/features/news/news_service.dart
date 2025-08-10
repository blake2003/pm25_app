import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pm25_app/core/loggers/log.dart';
import 'package:pm25_app/features/news/model.dart';

class NewsService {
  static const String _baseUrl = 'http://127.0.0.1:5000';
  static final _logger = AppLogger('NewsService');

  static Future<List<NewsArticle>> fetchNews() async {
    try {
      _logger.i('開始獲取新聞資料...');
      _logger.i('API端點: $_baseUrl/api/news');

      final response = await http.get(
        Uri.parse('$_baseUrl/api/news'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      _logger.i('API響應狀態碼: ${response.statusCode}');
      _logger.i('API響應內容長度: ${response.body.length}');

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseData = json.decode(response.body);
          _logger.i('API響應狀態: ${responseData['status']}');
          _logger.i('API響應訊息: ${responseData['message']}');

          // 檢查API響應狀態
          if (responseData['status'] == 'success' ||
              responseData['status'] == 'warning') {
            final List<dynamic> data = responseData['data'] ?? [];
            _logger.i('收到 ${data.length} 條原始新聞資料');

            if (data.isEmpty) {
              _logger.w('API返回空的新聞列表');
              return [];
            }

            // 安全地解析每條新聞，即使部分失敗也不影響整體
            List<NewsArticle> articles = [];
            int successCount = 0;
            int failCount = 0;

            for (int i = 0; i < data.length; i++) {
              try {
                final article =
                    NewsArticle.fromJson(data[i] as Map<String, dynamic>);
                articles.add(article);
                successCount++;

                // 記錄圖片資訊
                if (article.hasImages) {
                  _logger.i(
                      '新聞 "${article.title.substring(0, 20)}..." 包含 ${article.imageCount} 張圖片');
                }
              } catch (e) {
                failCount++;
                _logger.e('解析第 ${i + 1} 條新聞時發生錯誤: $e');
                _logger.e('問題資料: ${data[i]}');
                // 繼續處理下一條新聞，不中斷整個流程
                continue;
              }
            }

            _logger.i('成功解析 $successCount 條新聞，失敗 $failCount 條');

            if (articles.isEmpty && data.isNotEmpty) {
              throw Exception('所有新聞解析都失敗了，請檢查資料格式');
            }

            return articles;
          } else {
            _logger.e('API返回錯誤狀態: ${responseData['status']}');
            throw Exception('API錯誤: ${responseData['message'] ?? '未知錯誤'}');
          }
        } catch (e) {
          _logger.e('JSON解析錯誤: $e');
          _logger.e('響應內容: ${response.body}');
          throw Exception('資料解析失敗: $e');
        }
      } else {
        _logger.e('API調用失敗: ${response.statusCode}');
        _logger.e('錯誤響應: ${response.body}');
        throw Exception('獲取新聞失敗: HTTP ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('獲取新聞時發生錯誤: $e');
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection')) {
        throw Exception(
            '無法連接到新聞服務器，請確認：\n1. 後端服務是否已啟動\n2. IP地址是否正確($_baseUrl)\n3. 網路連接是否正常\n4. 防火牆設置');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception('請求超時，請稍後重試');
      } else {
        throw Exception('獲取新聞失敗: $e');
      }
    }
  }
}
