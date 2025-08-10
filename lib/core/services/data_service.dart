// data_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pm25_app/core/loggers/log.dart';

class DataService {
  final log = AppLogger('DataService');
  final _client = http.Client();

  static const String _apiUrl =
      'https://data.moenv.gov.tw/api/v2/aqx_p_02?language=zh&offset=0&limit=300&api_key=3c05acd8-b777-43bd-ab28-c72ea6cbcc5b';

  // 傳入 sitename，回傳篩選後的資料
  Future<List<dynamic>> fetchSiteData(String site) async {
    try {
      final response = await _client.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        log.i('API 請求成功，回應大小: ${response.body.length} bytes');
        final decoded = utf8.decode(response.bodyBytes);
        final map = json.decode(decoded);
        final records = map['records'] as List<dynamic>? ?? [];
        final filteredRecords =
            records.where((r) => r['site'] == site).toList();

        log.i('篩選到 $site 站點資料: ${filteredRecords.length} 筆');

        if (filteredRecords.isEmpty) {
          log.w('⚠️ 沒有找到 $site 的資料');
        }

        return filteredRecords;
      } else {
        log.e('❌ API 請求失敗: ${response.statusCode} - ${response.reasonPhrase}');
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      log.e('❌ 資料抓取錯誤: $e', e, stackTrace);
      throw Exception('資料抓取失敗: $e');
    }
  }
}

//TODO: 檢查資料抓取問題，無法抓取資料
