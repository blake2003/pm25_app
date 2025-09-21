import 'package:flutter_test/flutter_test.dart';
import 'package:pm25_app/features/site_management/site_management_provider.dart';
import 'package:pm25_app/features/site_management/site_management_repository.dart';

// Mock Repository for testing
class MockSiteManagementRepository implements SiteManagementRepository {
  List<String> _sites = [];
  String _currentSite = '';

  @override
  Future<bool> saveSites(List<String> sites) async {
    _sites = List.from(sites);
    return true;
  }

  @override
  Future<List<String>> getSites() async {
    return List.from(_sites);
  }

  @override
  Future<bool> saveCurrentSite(String site) async {
    _currentSite = site;
    return true;
  }

  @override
  Future<String> getCurrentSite() async {
    return _currentSite;
  }

  @override
  Future<bool> clearAllData() async {
    _sites.clear();
    _currentSite = '';
    return true;
  }

  @override
  Future<bool> hasSavedData() async {
    return _sites.isNotEmpty || _currentSite.isNotEmpty;
  }
}

void main() {
  group('SiteManagementProvider Tests', () {
    late SiteManagementProvider provider;
    late MockSiteManagementRepository mockRepository;

    setUp(() {
      mockRepository = MockSiteManagementRepository();
      provider = SiteManagementProvider(repository: mockRepository);
    });

    test('初始化時應該有默認站點', () async {
      // 等待初始化完成
      await Future.delayed(Duration(milliseconds: 100));

      expect(provider.sites, contains('金門'));
      expect(provider.sites, contains('馬公'));
      expect(provider.sites, contains('馬祖'));
      expect(provider.sites, contains('員林'));
      expect(provider.sites, contains('富貴角'));
      expect(provider.sites.length, equals(5));
    });

    test('初始化時應該有當前站點', () async {
      // 等待初始化完成
      await Future.delayed(Duration(milliseconds: 100));

      expect(provider.currentSite, isNotEmpty);
      expect(provider.sites, contains(provider.currentSite));
    });

    test('獲取可添加站點應該排除已存在的站點', () async {
      // 等待初始化完成
      await Future.delayed(Duration(milliseconds: 100));

      final availableSites = provider.getAvailableSites();
      expect(availableSites, contains('大城'));
      expect(availableSites, contains('麥寮'));
      expect(availableSites, contains('關山'));
      expect(availableSites, isNot(contains('金門')));
      expect(availableSites, isNot(contains('馬公')));
    });

    test('添加站點應該成功', () async {
      // 等待初始化完成
      await Future.delayed(Duration(milliseconds: 100));

      final initialCount = provider.sites.length;
      final success = await provider.addSite('大城');

      expect(success, isTrue);
      expect(provider.sites.length, equals(initialCount + 1));
      expect(provider.sites, contains('大城'));
    });

    test('添加已存在的站點應該失敗', () async {
      // 等待初始化完成
      await Future.delayed(Duration(milliseconds: 100));

      final initialCount = provider.sites.length;
      final success = await provider.addSite('金門');

      expect(success, isFalse);
      expect(provider.sites.length, equals(initialCount));
    });

    test('添加無效站點應該失敗', () async {
      // 等待初始化完成
      await Future.delayed(Duration(milliseconds: 100));

      final initialCount = provider.sites.length;
      final success = await provider.addSite('無效站點');

      expect(success, isFalse);
      expect(provider.sites.length, equals(initialCount));
    });

    test('刪除站點應該成功', () async {
      // 等待初始化完成
      await Future.delayed(Duration(milliseconds: 100));

      // 先添加一個站點
      await provider.addSite('大城');
      final initialCount = provider.sites.length;

      final success = await provider.deleteSite('大城');

      expect(success, isTrue);
      expect(provider.sites.length, equals(initialCount - 1));
      expect(provider.sites, isNot(contains('大城')));
    });

    test('刪除不存在的站點應該失敗', () async {
      // 等待初始化完成
      await Future.delayed(Duration(milliseconds: 100));

      final initialCount = provider.sites.length;
      final success = await provider.deleteSite('不存在的站點');

      expect(success, isFalse);
      expect(provider.sites.length, equals(initialCount));
    });

    test('當只有一個站點時不能刪除', () async {
      // 等待初始化完成
      await Future.delayed(Duration(milliseconds: 100));

      // 清空站點列表，只保留一個
      await mockRepository.clearAllData();
      await mockRepository.saveSites(['金門']);
      await mockRepository.saveCurrentSite('金門');

      // 重新初始化 provider
      provider = SiteManagementProvider(repository: mockRepository);

      // 等待新 provider 初始化完成
      await Future.delayed(Duration(milliseconds: 100));

      final success = await provider.deleteSite('金門');
      expect(success, isFalse);
      expect(provider.sites.length, equals(1));
    });

    test('切換當前站點應該成功', () async {
      // 等待初始化完成
      await Future.delayed(Duration(milliseconds: 100));

      await provider.addSite('大城');
      final newSite = '大城';

      final success = await provider.switchCurrentSite(newSite);

      expect(success, isTrue);
      expect(provider.currentSite, equals(newSite));
    });

    test('切換到不存在的站點應該失敗', () async {
      // 等待初始化完成
      await Future.delayed(Duration(milliseconds: 100));

      final originalSite = provider.currentSite;
      final success = await provider.switchCurrentSite('不存在的站點');

      expect(success, isFalse);
      expect(provider.currentSite, equals(originalSite));
    });

    test('切換到相同站點應該成功但不改變', () async {
      // 等待初始化完成
      await Future.delayed(Duration(milliseconds: 100));

      final originalSite = provider.currentSite;
      final success = await provider.switchCurrentSite(originalSite);

      expect(success, isTrue);
      expect(provider.currentSite, equals(originalSite));
    });

    test('重置為默認應該成功', () async {
      // 等待初始化完成
      await Future.delayed(Duration(milliseconds: 100));

      // 先添加一些站點
      await provider.addSite('大城');
      await provider.addSite('麥寮');

      await provider.resetToDefault();

      expect(provider.sites.length, equals(5));
      expect(provider.sites, contains('金門'));
      expect(provider.sites, contains('馬公'));
      expect(provider.sites, contains('馬祖'));
      expect(provider.sites, contains('員林'));
      expect(provider.sites, contains('富貴角'));
      expect(provider.sites, isNot(contains('大城')));
      expect(provider.sites, isNot(contains('麥寮')));
    });

    test('檢查站點是否存在應該正確', () async {
      // 等待初始化完成
      await Future.delayed(Duration(milliseconds: 100));

      expect(provider.hasSite('金門'), isTrue);
      expect(provider.hasSite('馬公'), isTrue);
      expect(provider.hasSite('不存在的站點'), isFalse);
    });

    test('獲取站點數量應該正確', () async {
      // 等待初始化完成
      await Future.delayed(Duration(milliseconds: 100));

      expect(provider.siteCount, equals(5));
    });

    test('檢查是否可以刪除站點應該正確', () async {
      // 等待初始化完成
      await Future.delayed(Duration(milliseconds: 100));

      expect(provider.canDeleteSite(), isTrue);

      // 創建一個新的 mock repository 和 provider 來測試單一站點情況
      final singleSiteRepository = MockSiteManagementRepository();
      await singleSiteRepository.clearAllData();
      await singleSiteRepository.saveSites(['金門']);
      await singleSiteRepository.saveCurrentSite('金門');

      final singleSiteProvider =
          SiteManagementProvider(repository: singleSiteRepository);

      // 等待新 provider 初始化完成
      await Future.delayed(Duration(milliseconds: 100));

      expect(singleSiteProvider.canDeleteSite(), isFalse);
    });
  });
}
