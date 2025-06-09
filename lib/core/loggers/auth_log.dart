import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Logger {
  static const String _logEndpoint = "https://example.com/api/logs";

  static Future<void> logEvent(String event, {String? detail}) async {
    // 先行在本地終端印出 (方便 Debug)
    debugPrint("[EVENT] $event ${detail != null ? '-> $detail' : ''}");

    // 嘗試上傳到後端
    try {
      final response = await http.post(
        Uri.parse(_logEndpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "event": event,
          "detail": detail,
          "timestamp": DateTime.now().toIso8601String(),
        }),
      );

      // 可根據 response 狀態做後續處理
      if (response.statusCode != 200) {
        debugPrint(
            "Failed to log event to backend. Status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Failed to log event to backend. Error: $e");
      // 若需要上傳失敗後做重試、排程等機制，可在此補上
    }
  }
}
