import 'package:pm25_app/core/loggers/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SiteManagementRepository {
  static const String _sitesKey = 'sites';
  static const String _currentSiteKey = 'current_site';
  final _log = AppLogger('SiteManagementRepository');
//===============================================
  /// 保存站點列表
  Future<bool> saveSites(List<String> sites) async {
    try {
      _log.d('開始保存站點列表: $sites');
      final prefs = await SharedPreferences.getInstance();

      // 將站點列表轉換為 JSON 字符串
      final sitesJson = sites.join(',');
      final result = await prefs.setString(_sitesKey, sitesJson);

      if (result) {
        _log.i('成功保存站點列表: ${sites.length} 個站點');
      } else {
        _log.w('保存站點列表失敗');
      }

      return result;
    } catch (e, stack) {
      _log.e('保存站點列表異常', e, stack);
      return false;
    }
  }

//===============================================
  /// 讀取站點列表
  Future<List<String>> getSites() async {
    try {
      _log.d('開始讀取站點列表');
      final prefs = await SharedPreferences.getInstance();

      final sitesJson = prefs.getString(_sitesKey);
      if (sitesJson == null || sitesJson.isEmpty) {
        _log.d('沒有保存的站點列表');
        return [];
      }

      // 將 JSON 字符串轉換回站點列表
      final sites =
          sitesJson.split(',').where((site) => site.isNotEmpty).toList();
      _log.i('成功讀取站點列表: ${sites.length} 個站點');

      return sites;
    } catch (e, stack) {
      _log.e('讀取站點列表異常', e, stack);
      return [];
    }
  }

//===============================================
  /// 保存當前選中的站點
  Future<bool> saveCurrentSite(String site) async {
    try {
      _log.d('開始保存當前站點: $site');
      final prefs = await SharedPreferences.getInstance();

      final result = await prefs.setString(_currentSiteKey, site);

      if (result) {
        _log.i('成功保存當前站點: $site');
      } else {
        _log.w('保存當前站點失敗');
      }

      return result;
    } catch (e, stack) {
      _log.e('保存當前站點異常', e, stack);
      return false;
    }
  }

//===============================================
  /// 讀取當前選中的站點
  Future<String> getCurrentSite() async {
    try {
      _log.d('開始讀取當前站點');
      final prefs = await SharedPreferences.getInstance();

      final site = prefs.getString(_currentSiteKey);
      if (site == null || site.isEmpty) {
        _log.d('沒有保存的當前站點');
        return '';
      }

      _log.i('成功讀取當前站點: $site');
      return site;
    } catch (e, stack) {
      _log.e('讀取當前站點異常', e, stack);
      return '';
    }
  }

//===============================================
  /// 清除所有站點相關的數據
  Future<bool> clearAllData() async {
    try {
      _log.d('開始清除所有站點數據');
      final prefs = await SharedPreferences.getInstance();

      final result1 = await prefs.remove(_sitesKey);
      final result2 = await prefs.remove(_currentSiteKey);

      final success = result1 && result2;
      if (success) {
        _log.i('成功清除所有站點數據');
      } else {
        _log.w('清除站點數據失敗');
      }

      return success;
    } catch (e, stack) {
      _log.e('清除站點數據異常', e, stack);
      return false;
    }
  }

//===============================================
  /// 檢查是否有保存的數據
  Future<bool> hasSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_sitesKey) || prefs.containsKey(_currentSiteKey);
    } catch (e, stack) {
      _log.e('檢查保存數據異常', e, stack);
      return false;
    }
  }
}
