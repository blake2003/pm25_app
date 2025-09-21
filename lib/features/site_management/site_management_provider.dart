import 'package:flutter/material.dart';
import 'package:pm25_app/core/loggers/log.dart';
import 'package:pm25_app/core/utils/safe_collection_extensions.dart';
import 'package:pm25_app/features/site_management/site_management_repository.dart';

class SiteManagementProvider extends ChangeNotifier {
  final SiteManagementRepository _repository;
  final _log = AppLogger('SiteManagementProvider');

  // 站點列表
  List<String> _sites = [];
  String _currentSite = '';

  // Getters
  List<String> get sites => List.unmodifiable(_sites);
  String get currentSite => _currentSite;
  bool get hasSites => _sites.isNotEmpty;

  // 所有可用的站點
  static const List<String> allAvailableSites = [
    '金門',
    '馬公',
    '馬祖',
    '員林',
    '富貴角',
    '大城',
    '麥寮',
    '關山',
    '埔里',
    '復興',
    '宜蘭',
    '土城',
    '大同',
    '中山',
    '古亭',
    '新竹',
    '板橋',
    '竹東',
    '左營',
    '楠梓',
    '沙鹿',
    '中壢',
    '竹東',
  ];

  SiteManagementProvider({SiteManagementRepository? repository})
      : _repository = repository ?? SiteManagementRepository() {
    _initializeSites();
  }
//===============================================
  /// 初始化站點列表
  Future<void> _initializeSites() async {
    try {
      _log.i('開始初始化站點列表');

      // 從持久化存儲讀取站點列表
      final savedSites = await _repository.getSites();
      if (savedSites.isNotEmpty) {
        _sites = savedSites;
        _log.i('從持久化存儲讀取到 ${_sites.length} 個站點: $_sites');
      } else {
        // 如果沒有保存的站點，使用默認站點
        _sites = ['金門', '馬公', '馬祖', '員林', '富貴角'];
        _log.i('使用默認站點列表: $_sites');
        // 保存默認站點到持久化存儲
        await _repository.saveSites(_sites);
      }

      // 讀取當前選中的站點
      final savedCurrentSite = await _repository.getCurrentSite();
      if (savedCurrentSite.isNotEmpty && _sites.contains(savedCurrentSite)) {
        _currentSite = savedCurrentSite;
        _log.i('從持久化存儲讀取到當前站點: $_currentSite');
      } else {
        // 如果沒有保存的當前站點，使用第一個站點
        final firstSite = _sites.firstOrNull;
        if (firstSite != null) {
          _currentSite = firstSite;
          _log.i('使用第一個站點作為當前站點: $_currentSite');
          // 保存當前站點到持久化存儲
          await _repository.saveCurrentSite(_currentSite);
        } else {
          _log.e('站點列表為空，無法設置當前站點');
          throw StateError('站點列表為空');
        }
      }

      notifyListeners();
      _log.i('站點列表初始化完成');
    } catch (e, stack) {
      _log.e('初始化站點列表失敗', e, stack);
      // 使用默認值作為備用
      _sites = ['金門', '馬公', '馬祖', '員林', '富貴角'];
      final firstSite = _sites.firstOrNull;
      if (firstSite != null) {
        _currentSite = firstSite;
        _log.i('使用備用站點列表，當前站點: $_currentSite');
      } else {
        _log.e('備用站點列表也為空，這是一個嚴重錯誤');
        _currentSite = '金門'; // 最後的備用方案
      }
      notifyListeners();
    }
  }

//===============================================
  /// 獲取可添加的站點列表
  List<String> getAvailableSites() {
    return allAvailableSites.where((site) => !_sites.contains(site)).toList();
  }

//===============================================
  /// 添加站點
  Future<bool> addSite(String site) async {
    try {
      _log.i('開始添加站點: $site');

      // 檢查站點是否已存在
      if (_sites.contains(site)) {
        _log.w('站點已存在: $site');
        return false;
      }

      // 檢查站點是否在可用站點列表中
      if (!allAvailableSites.contains(site)) {
        _log.w('站點不在可用列表中: $site');
        return false;
      }

      // 添加到內存
      _sites.add(site);

      // 保存到持久化存儲
      await _repository.saveSites(_sites);

      _log.i('成功添加站點: $site, 當前站點列表: $_sites');
      notifyListeners();
      return true;
    } catch (e, stack) {
      _log.e('添加站點失敗: $site', e, stack);
      // 回滾內存中的更改
      _sites.remove(site);
      return false;
    }
  }

//===============================================
  /// 刪除站點
  Future<bool> deleteSite(String site) async {
    try {
      _log.i('開始刪除站點: $site');

      // 檢查站點是否存在
      if (!_sites.contains(site)) {
        _log.w('站點不存在: $site');
        return false;
      }

      // 檢查是否至少保留一個站點
      if (_sites.length <= 1) {
        _log.w('無法刪除站點，至少需要保留一個站點');
        return false;
      }

      // 從內存中移除
      _sites.remove(site);

      // 保存到持久化存儲
      await _repository.saveSites(_sites);

      // 如果刪除的是當前選中的站點，切換到第一個站點
      if (_currentSite == site) {
        final firstSite = _sites.firstOrNull;
        if (firstSite != null) {
          _currentSite = firstSite;
          await _repository.saveCurrentSite(_currentSite);
          _log.i('切換到新站點: $_currentSite');
        } else {
          _log.e('刪除站點後列表為空，無法切換站點');
        }
      }

      _log.i('成功刪除站點: $site, 剩餘站點列表: $_sites');
      notifyListeners();
      return true;
    } catch (e, stack) {
      _log.e('刪除站點失敗: $site', e, stack);
      // 回滾內存中的更改
      if (!_sites.contains(site)) {
        _sites.add(site);
      }
      return false;
    }
  }

//===============================================
  /// 切換當前站點
  Future<bool> switchCurrentSite(String newSite) async {
    try {
      _log.i('開始切換站點: $_currentSite -> $newSite');

      // 檢查新站點是否存在
      if (!_sites.contains(newSite)) {
        _log.w('站點不存在: $newSite');
        return false;
      }

      // 檢查是否真的需要切換
      if (_currentSite == newSite) {
        _log.d('站點未改變: $newSite');
        return true;
      }

      // 更新當前站點
      _currentSite = newSite;

      // 保存到持久化存儲
      await _repository.saveCurrentSite(_currentSite);

      _log.i('成功切換站點: $_currentSite');
      notifyListeners();
      return true;
    } catch (e, stack) {
      _log.e('切換站點失敗: $newSite', e, stack);
      return false;
    }
  }

//===============================================
  /// 重置站點列表到默認值
  Future<void> resetToDefault() async {
    try {
      _log.i('開始重置站點列表到默認值');

      final defaultSites = ['金門', '馬公', '馬祖', '員林', '富貴角'];
      _sites = List.from(defaultSites);
      _currentSite = _sites.firstOrNull ?? '金門';

      // 保存到持久化存儲
      await _repository.saveSites(_sites);
      await _repository.saveCurrentSite(_currentSite);

      _log.i('成功重置站點列表: $_sites');
      notifyListeners();
    } catch (e, stack) {
      _log.e('重置站點列表失敗', e, stack);
    }
  }

//===============================================
  /// 檢查站點是否存在
  bool hasSite(String site) {
    return _sites.contains(site);
  }

  /// 獲取站點數量
  int get siteCount => _sites.length;

  /// 檢查是否可以刪除站點
  bool canDeleteSite() {
    return _sites.length > 1;
  }
}
