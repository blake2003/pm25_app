// lib/ui/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pm25_app/core/constants/language/l10n/app_localizations.dart';
import 'package:pm25_app/core/utils/safe_collection_extensions.dart';
import 'package:pm25_app/features/aqi/aqi_provider.dart';
import 'package:pm25_app/features/site_management/site_management_provider.dart';
import 'package:pm25_app/ui/screens/news/news_screen.dart';
import 'package:pm25_app/ui/screens/setting/settings_screen.dart';
import 'package:pm25_app/ui/widgets/aqi_card.dart';
import 'package:pm25_app/ui/widgets/gfwidgets/gfdrawer.dart';
import 'package:pm25_app/ui/widgets/homescreen/recentdata_widget.dart';
import 'package:pm25_app/ui/widgets/homescreen/state_widget.dart';
import 'package:pm25_app/ui/widgets/site_management_dialog.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // 站點管理相關變數將通過 Provider 管理
  late SiteManagementProvider _siteProvider;

  /// 彈出添加站點 Dialog - iOS 風格
  void _showAddSiteDialog(BuildContext context) async {
    await SiteManagementDialog.showAddSiteDialog(context);
  }

  /// 彈出刪除站點 Dialog - iOS 風格
  void _showDeleteSiteDialog(BuildContext context) async {
    await SiteManagementDialog.showDeleteSiteDialog(context);
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _siteProvider = context.read<SiteManagementProvider>();

    // 首次進畫面就抓資料
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AqiProvider>().loadAqi(_siteProvider.currentSite);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 下拉選單切換站點
  void _onSiteChanged(String? newSite) {
    if (newSite == null || newSite == _siteProvider.currentSite) return;
    _siteProvider.switchCurrentSite(newSite);
    context.read<AqiProvider>().loadAqi(newSite);
  }

  /// 將 DateTime 轉為 HH:mm 格式字串
  String _formatTime(DateTime time) => DateFormat('HH:mm').format(time);

//===============================================
  @override
  Widget build(BuildContext context) {
    // 各頁面 widget
    final List<Widget> pages = [
      // 首頁內容 - iOS 風格
      Consumer<AqiProvider>(
        builder: (_, provider, __) {
          if (provider.isLoading) {
            return StateWidgets.loading();
          }
          if (provider.error != null) {
            return StateWidgets.errorWithProvider(error: provider.error!);
          }
          if (provider.records.isEmpty) {
            return StateWidgets.empty();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 最近三個小時資料統計卡片
                  RecentDataCard(provider: provider),
                  const SizedBox(height: 16),
                  // 最新的 AQI 資料卡片
                  if (provider.records.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AqiCard(record: provider.records.firstOrNull!),
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
    //===============================================
    // AppBar 標題與 actions 根據 index 切換
    PreferredSizeWidget appBar;
    if (_currentIndex == 0) {
      appBar = AppBar(
        title: Consumer2<AqiProvider, SiteManagementProvider>(
          builder: (_, aqiProvider, siteProvider, __) {
            final updateTime =
                aqiProvider.records.firstOrNull?.datacreationdate;
            final timeText =
                updateTime != null ? '（${_formatTime(updateTime)} 更新）' : '';
            return Text(
                '${AppLocalizations.of(context)!.airQualityTitle}$timeText'); //"空氣品質"
          },
        ),
        actions: [
          Consumer<SiteManagementProvider>(
            builder: (_, siteProvider, __) => DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                //TODO: 需要翻譯 value
                value: siteProvider.currentSite,
                items: siteProvider.sites
                    .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s),
                        ))
                    .toList(),
                onChanged: _onSiteChanged,
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.add_location),
            onPressed: () => _showAddSiteDialog(context),
            tooltip: AppLocalizations.of(context)!.addSite, //“添加站點”
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteSiteDialog(context),
            tooltip: AppLocalizations.of(context)!.deleteSite, //“刪除站點”
          ),
        ],
      );
    } else if (_currentIndex == 1) {
      appBar = AppBar(
        title: Text(AppLocalizations.of(context)!.news), //“新聞”
      );
    } else {
      appBar = AppBar(
        title: Text(AppLocalizations.of(context)!.settings), //“設定”
      );
    }
    //===============================================
    // FAB 只在首頁顯示 - iOS 風格
    //最新的資料（正方形那個）
    final fab = _currentIndex == 0
        ? Consumer<SiteManagementProvider>(
            builder: (_, siteProvider, __) => FloatingActionButton(
              onPressed: () =>
                  context.read<AqiProvider>().loadAqi(siteProvider.currentSite),
              child: const Icon(Icons.refresh),
            ),
          )
        : null;
    //===============================================
    // 底部導航列
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
