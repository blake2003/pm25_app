import 'package:flutter/material.dart';
import 'package:pm25_app/core/loggers/log.dart';
import 'package:pm25_app/features/news/debug_service.dart';
import 'package:pm25_app/features/news/model.dart';
import 'package:pm25_app/features/news/news_provider.dart';
import 'package:provider/provider.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  static final _logger = AppLogger('NewsScreen');

  @override
  void initState() {
    super.initState();
    _logger.i('NewsScreen初始化');
    // 在下一幀初始化新聞資料，避免在 build 期間呼叫 Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().initializeNews();
    });
  }

  void _refreshNews() {
    _logger.i('用戶請求重新整理新聞');
    context.read<NewsProvider>().refreshNews();
  }

  void _showDebugDialog() async {
    // 顯示載入對話框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('正在測試API連接...'),
          ],
        ),
      ),
    );

    try {
      // 執行測試
      final results = await DebugService.testConnection();
      final formattedResults = DebugService.formatTestResults(results);

      // 關閉載入對話框
      Navigator.pop(context);

      // 顯示測試結果
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('API連接測試結果'),
          content: SingleChildScrollView(
            child: Text(
              formattedResults,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('關閉'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _refreshNews(); // 重新載入新聞
              },
              child: const Text('重新載入'),
            ),
          ],
        ),
      );
    } catch (e) {
      // 關閉載入對話框
      Navigator.pop(context);

      // 顯示錯誤
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('測試失敗'),
          content: Text('測試過程中發生錯誤：$e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('關閉'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<NewsProvider>(
          builder: (context, provider, child) {
            final updateTime = provider.formattedLastFetchTime;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('最新消息'),
                Text(
                  updateTime,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: _showDebugDialog,
            tooltip: 'API連接測試',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshNews,
            tooltip: '重新整理',
          ),
        ],
      ),
      body: Consumer<NewsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('正在載入新聞...'),
                  SizedBox(height: 8),
                  Text('首次載入可能需要30秒', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          } else if (provider.hasError) {
            _logger.e('新聞載入錯誤: ${provider.error}');
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text('載入失敗',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      '錯誤：${provider.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshNews,
                      child: const Text('重試'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _showDebugDialog,
                      child: const Text('API測試'),
                    ),
                  ],
                ),
              ),
            );
          } else if (!provider.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.article_outlined,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('沒有新聞資料', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  const Text('後端服務可能正常，但未獲取到新聞',
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshNews,
                    child: const Text('重新載入'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _showDebugDialog,
                    child: const Text('API測試'),
                  ),
                ],
              ),
            );
          }

          final newsList = provider.newsList;
          _logger.i('成功顯示 ${newsList.length} 條新聞');

          return RefreshIndicator(
            onRefresh: () async {
              _refreshNews();
            },
            child: ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final item = newsList[index];
                return NewsListItem(
                  news: item,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NewsDetailScreen(news: item),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class NewsListItem extends StatelessWidget {
  final NewsArticle news;
  final VoidCallback onTap;

  const NewsListItem({
    super.key,
    required this.news,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 主圖
            if (news.hasImages && news.mainImage != null)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    news.mainImage!.url,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                ),
              ),

            // 內容區域
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 標題
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // 記者和時間
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          news.reporter,
                          style: TextStyle(color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        news.publishTime,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      if (news.hasImages)
                        Row(
                          children: [
                            Icon(Icons.image,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${news.images.length}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  final NewsArticle news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新聞詳情'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 主圖
            if (news.hasImages && news.mainImage != null)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  news.mainImage!.url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 標題
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 新聞資訊
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person,
                                size: 18, color: Colors.grey[700]),
                            const SizedBox(width: 8),
                            Text('記者：${news.reporter}',
                                style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.schedule,
                                size: 18, color: Colors.grey[700]),
                            const SizedBox(width: 8),
                            Text('發布時間：${news.publishTime}',
                                style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                        if (news.hasImages) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.image,
                                  size: 18, color: Colors.grey[700]),
                              const SizedBox(width: 8),
                              Text('圖片：${news.images.length} 張',
                                  style: TextStyle(color: Colors.grey[700])),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 內容
                  Text(
                    news.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  // 其他圖片
                  if (news.images.length > 1) ...[
                    const SizedBox(height: 24),
                    const Text(
                      '相關圖片',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...news.images.skip(1).map((image) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  image.url,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 200,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              if (image.alt.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  image.alt,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
