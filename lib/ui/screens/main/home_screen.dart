// lib/ui/screens/home_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pm25_app/core/loggers/log.dart';
import 'package:pm25_app/features/aqi/aqi_provider.dart';
import 'package:pm25_app/ui/screens/main/pages/aqi_data_page.dart';
import 'package:pm25_app/ui/screens/news/news_screen.dart';
import 'package:pm25_app/ui/screens/setting/settings_screen.dart';
import 'package:pm25_app/ui/widgets/aqi_card.dart';
import 'package:pm25_app/ui/widgets/gfwidgets/gfdrawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // 日誌記錄器
  final _log = AppLogger('HomeScreen');

  // 你可以改成從 SharedPreferences 讀取上次選擇的站點
  String _currentSite = '金門';

  // 範例站點清單，可依實際 API 改動
  List<String> _sites = ['金門', '馬公', '馬祖', '員林', '富貴角'];

  /// 彈出添加站點 Dialog - iOS 風格
  void _showAddSiteDialog(BuildContext context) async {
    // 假設所有可選地區如下，實際可根據 API 或需求調整
    final List<String> allSites = [
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
    ];
    // 過濾掉已經在 _sites 的地區
    final List<String> availableSites =
        allSites.where((s) => !_sites.contains(s)).toList();
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
              child: const Text('確定'),
            ),
          ],
        ),
      );
      return;
    }
    // 初始化選擇的站點為可用站點列表的第一個（解決 CupertinoPicker 初始值為 null 導致第一個項目無法選擇的問題）
    String? selectedSite = availableSites.isNotEmpty ? availableSites[0] : null;
    await showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('選擇要添加的地區'),
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
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              _log.d('確定按鈕點擊，selectedSite: $selectedSite');
              if (selectedSite != null) {
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('確定'),
          ),
        ],
      ),
    );
    _log.d('對話框關閉，selectedSite: $selectedSite');
    if (selectedSite != null && !_sites.contains(selectedSite)) {
      setState(() {
        _sites.add(selectedSite!);
        _log.i('添加站點: $selectedSite, 當前站點列表: $_sites');
      });
    } else {
      _log.w(
          '無法添加站點: selectedSite=$selectedSite, 已存在=${selectedSite != null ? _sites.contains(selectedSite!) : false}');
    }
  }

  /// 彈出刪除站點 Dialog - iOS 風格
  void _showDeleteSiteDialog(BuildContext context) async {
    // 如果只有一個站點，不允許刪除
    if (_sites.length <= 1) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('無法刪除'),
          content: const Text('至少需要保留一個站點。'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('確定'),
            ),
          ],
        ),
      );
      return;
    }

    String? selectedSite = _sites.isNotEmpty ? _sites[0] : null;
    await showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('選擇要刪除的地區'),
        content: SizedBox(
          height: 200,
          child: CupertinoPicker(
            itemExtent: 40,
            onSelectedItemChanged: (index) {
              selectedSite = _sites[index];
              _log.d('選擇刪除站點: $selectedSite');
            },
            children: _sites.map((s) => Center(child: Text(s))).toList(),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              _log.d('刪除按鈕點擊，selectedSite: $selectedSite');
              if (selectedSite != null) {
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('刪除'),
          ),
        ],
      ),
    );

    if (selectedSite != null) {
      // 確認刪除對話框
      final bool? confirmDelete = await showCupertinoDialog<bool>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('確認刪除'),
          content: Text('確定要刪除「$selectedSite」嗎？\n此操作無法復原。'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('取消'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('刪除'),
            ),
          ],
        ),
      );

      _log.d(
          '確認刪除對話框關閉，confirmDelete: $confirmDelete, selectedSite: $selectedSite');
      if (confirmDelete == true) {
        setState(() {
          _sites.remove(selectedSite);
          _log.i('刪除站點: $selectedSite, 剩餘站點列表: $_sites');
          // 如果刪除的是當前選中的站點，切換到第一個站點
          if (_currentSite == selectedSite) {
            _currentSite = _sites.first;
            _log.i('切換到新站點: $_currentSite');
            context.read<AqiProvider>().loadAqi(_currentSite);
          }
        });
      }
    }
  }

  // TabController 來管理 Tab 狀態
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
    // 首次進畫面就抓資料
    Future.microtask(() => context.read<AqiProvider>().loadAqi(_currentSite));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 下拉選單切換站點
  void _onSiteChanged(String? newSite) {
    if (newSite == null || newSite == _currentSite) return;
    setState(() => _currentSite = newSite);
    context.read<AqiProvider>().loadAqi(_currentSite);
  }

  /// 將 DateTime 轉為 HH:mm 格式字串
  String _formatTime(DateTime time) => DateFormat('HH:mm').format(time);

  /// 建立最近三個小時資料統計卡片 - iOS 風格
  Widget _buildRecentDataCard(AqiProvider provider) {
    final recentCount = provider.recentThreeHoursCount;
    final averagePm25 = provider.recentThreeHoursAveragePm25;
    final timeRange = provider.recentThreeHoursTimeRange;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.separator.withOpacity(0.3),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    CupertinoIcons.chart_bar_alt_fill,
                    color: CupertinoColors.systemBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '最近三個小時統計',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.label,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: CupertinoIcons.doc_text,
                    label: '資料筆數',
                    value: '$recentCount 筆',
                    color: CupertinoColors.systemBlue,
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => const AqiDataPage(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    icon: CupertinoIcons.chart_bar,
                    label: '平均 PM2.5',
                    value: '${averagePm25.toStringAsFixed(1)} μg/m³',
                    color: _getPm25Color(averagePm25),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: CupertinoIcons.clock,
                    label: '時間範圍',
                    value: timeRange,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 建立統計項目 - iOS 風格
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    VoidCallback? onTap,
  }) {
    Widget content = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: CupertinoColors.secondaryLabel,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (onTap != null) ...[
                const Spacer(),
                Icon(
                  CupertinoIcons.chevron_right,
                  size: 12,
                  color: CupertinoColors.systemGrey,
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: content,
      );
    }

    return content;
  }

  /// 根據 PM2.5 值獲取對應顏色 - iOS 風格
  Color _getPm25Color(double pm25) {
    if (pm25 <= 12) return CupertinoColors.systemGreen;
    if (pm25 <= 35.4) return CupertinoColors.systemYellow;
    if (pm25 <= 55.4) return CupertinoColors.systemOrange;
    if (pm25 <= 150.4) return CupertinoColors.systemRed;
    if (pm25 <= 250.4) return CupertinoColors.systemPurple;
    return CupertinoColors.systemBrown;
  }

  /// 載入狀態 - iOS 風格
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CupertinoActivityIndicator(radius: 20),
          const SizedBox(height: 16),
          Text(
            '載入中...',
            style: TextStyle(
              fontSize: 16,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
        ],
      ),
    );
  }

  /// 錯誤狀態 - iOS 風格
  Widget _buildErrorState(String error) {
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
            CupertinoButton.filled(
              onPressed: () =>
                  context.read<AqiProvider>().loadAqi(_currentSite),
              child: const Text('重新載入'),
            ),
          ],
        ),
      ),
    );
  }

  /// 空資料狀態 - iOS 風格
  Widget _buildEmptyState() {
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
                CupertinoIcons.doc_text,
                size: 48,
                color: CupertinoColors.systemGrey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '暫無資料',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.label,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '目前沒有可顯示的空氣品質資料',
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.secondaryLabel,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 各頁面 widget
    final List<Widget> pages = [
      // 首頁內容 - iOS 風格
      Consumer<AqiProvider>(
        builder: (_, provider, __) {
          if (provider.isLoading) {
            return _buildLoadingState();
          }
          if (provider.error != null) {
            return _buildErrorState(provider.error!);
          }
          if (provider.records.isEmpty) {
            return _buildEmptyState();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 最近三個小時資料統計卡片
                  _buildRecentDataCard(provider),
                  const SizedBox(height: 16),
                  // 最新的 AQI 資料卡片
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AqiCard(record: provider.records.first),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // 新聞頁
      const NewsScreen(),
      // 設定頁（可自訂）
      const SettingsScreen(),
    ];

    // AppBar 標題與 actions 根據 index 切換
    PreferredSizeWidget appBar;
    if (_currentIndex == 0) {
      appBar = AppBar(
        title: Consumer<AqiProvider>(
          builder: (_, provider, __) {
            final updated = provider.records.isNotEmpty
                ? '（${_formatTime(provider.records.first.datacreationdate)} 更新）'
                : '';
            return Text('空氣品質 - $_currentSite$updated');
          },
        ),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _currentSite,
              items: _sites
                  .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s),
                      ))
                  .toList(),
              onChanged: _onSiteChanged,
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.add_location),
            onPressed: () => _showAddSiteDialog(context),
            tooltip: '添加站點',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteSiteDialog(context),
            tooltip: '刪除站點',
          ),
        ],
      );
    } else if (_currentIndex == 1) {
      appBar = AppBar(title: const Text('相關新聞'));
    } else {
      appBar = AppBar(title: const Text('設定'));
    }

    // FAB 只在首頁顯示 - iOS 風格
    final fab = _currentIndex == 0
        ? FloatingActionButton(
            onPressed: () => context.read<AqiProvider>().loadAqi(_currentSite),
            child: const Icon(Icons.refresh),
          )
        : null;

    return Scaffold(
      appBar: appBar,
      body: TabBarView(
        controller: _tabController,
        children: pages,
      ),
      drawer: const Drawer(
        child: GfDrawer(),
      ),
      floatingActionButton: fab,
      bottomNavigationBar: Container(
        height: 72, // 增加高度
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            // 四邊陰影
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, -2), // 底部陰影
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              spreadRadius: 0.5,
              offset: const Offset(0, 2), // 頂部陰影
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              spreadRadius: 0.5,
              offset: const Offset(-2, 0), // 左側陰影
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              spreadRadius: 0.5,
              offset: const Offset(2, 0), // 右側陰影
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(
              icon: Icon(Icons.home, size: 30), // 調整icon大小
            ),
            Tab(
              icon: Icon(Icons.article, size: 30),
            ),
            Tab(
              icon: Icon(Icons.settings, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
