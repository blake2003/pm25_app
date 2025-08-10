import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class DebugService {
  static const String _baseUrl = 'http://127.0.0.1:5000';

  static Future<Map<String, dynamic>> testConnection() async {
    final result = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'tests': <Map<String, dynamic>>[],
    };

    // 測試1: 健康檢查
    try {
      Logger.root.info('🔍 測試1: 健康檢查 $_baseUrl/api/health');
      final response = await http.get(
        Uri.parse('$_baseUrl/api/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      result['tests'].add({
        'name': '健康檢查',
        'url': '$_baseUrl/api/health',
        'status': response.statusCode,
        'success': response.statusCode == 200,
        'response': response.body,
        'error': null,
      });
    } catch (e) {
      result['tests'].add({
        'name': '健康檢查',
        'url': '$_baseUrl/api/health',
        'status': null,
        'success': false,
        'response': null,
        'error': e.toString(),
      });
    }

    // 測試2: 根路徑
    try {
      Logger.root.info('🔍 測試2: IP address $_baseUrl/');
      final response = await http.get(
        Uri.parse('$_baseUrl/'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      result['tests'].add({
        'name': '根路徑',
        'url': '$_baseUrl/',
        'status': response.statusCode,
        'success': response.statusCode == 200,
        'response': response.body,
        'error': null,
      });
    } catch (e) {
      result['tests'].add({
        'name': '根路徑',
        'url': '$_baseUrl/',
        'status': null,
        'success': false,
        'response': null,
        'error': e.toString(),
      });
    }

    // 測試3: 新聞API
    try {
      Logger.root.info('🔍 測試3: 新聞API $_baseUrl/api/news');
      final response = await http.get(
        Uri.parse('$_baseUrl/api/news'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      result['tests'].add({
        'name': '新聞API',
        'url': '$_baseUrl/api/news',
        'status': response.statusCode,
        'success': response.statusCode == 200,
        'response': response.body.length > 1000
            ? '${response.body.substring(0, 1000)}...'
            : response.body,
        'error': null,
      });
    } catch (e) {
      result['tests'].add({
        'name': '新聞API',
        'url': '$_baseUrl/api/news',
        'status': null,
        'success': false,
        'response': null,
        'error': e.toString(),
      });
    }

    return result;
  }

  static String formatTestResults(Map<String, dynamic> results) {
    final buffer = StringBuffer();
    buffer.writeln('=== API連接測試結果 ===');
    buffer.writeln('測試時間: ${results['timestamp']}');
    buffer.writeln();

    final tests = results['tests'] as List<Map<String, dynamic>>;
    for (int i = 0; i < tests.length; i++) {
      final test = tests[i];
      buffer.writeln('${i + 1}. ${test['name']}');
      buffer.writeln('   URL: ${test['url']}');
      buffer.writeln('   結果: ${test['success'] ? '✅ 成功' : '❌ 失敗'}');

      if (test['status'] != null) {
        buffer.writeln('   狀態碼: ${test['status']}');
      }

      if (test['error'] != null) {
        buffer.writeln('   錯誤: ${test['error']}');
      }

      if (test['response'] != null && test['success']) {
        try {
          final jsonResponse = json.decode(test['response']);
          if (jsonResponse is Map && jsonResponse.containsKey('message')) {
            buffer.writeln('   訊息: ${jsonResponse['message']}');
          }
        } catch (e) {
          // 忽略JSON解析錯誤
        }
      }

      buffer.writeln();
    }

    // 總結
    final successCount = tests.where((test) => test['success'] == true).length;
    buffer.writeln('總結: $successCount/${tests.length} 項測試通過');

    if (successCount == tests.length) {
      buffer.writeln('🎉 所有測試都通過！API連接正常。');
    } else {
      buffer.writeln('⚠️  部分測試失敗，請檢查：');
      buffer.writeln('1. 後端服務是否已啟動 (python app.py)');
      buffer.writeln('2. 端口5000是否被其他程序佔用');
      buffer.writeln('3. 防火牆是否阻擋連接');
    }

    return buffer.toString();
  }
}
