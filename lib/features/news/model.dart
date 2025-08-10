import 'package:pm25_app/core/loggers/log.dart';

class NewsArticle {
  static final _logger = AppLogger('NewsArticle');

  final String title;
  final String publishTime; // 改為String，因為Python返回的是字串格式
  final String reporter; // 新增reporter字段
  final String content;
  final List<NewsImage> images; // 新增圖片字段，確保不為null

  NewsArticle({
    required this.title,
    required this.publishTime,
    required this.reporter,
    required this.content,
    List<NewsImage>? images, // 允許傳入null，內部會轉為空列表
  }) : images = images ?? []; // 確保images永遠不為null

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    // 安全地解析images字段
    List<NewsImage> imagesList = [];

    try {
      final imagesJson = json['images'];
      if (imagesJson != null) {
        if (imagesJson is List) {
          for (final item in imagesJson) {
            if (item != null && item is Map<String, dynamic>) {
              try {
                // 檢查URL是否有效
                final url = item['url']?.toString() ?? '';
                if (url.isNotEmpty &&
                    (url.startsWith('http://') || url.startsWith('https://'))) {
                  final image = NewsImage.fromJson(item);
                  imagesList.add(image);
                }
              } catch (e) {
                _logger.e('解析單個圖片時發生錯誤: $e');
                // 繼續處理下一個項目
              }
            }
          }
        }
      }
    } catch (e) {
      _logger.e('解析images字段時發生錯誤: $e, 使用空列表');
      imagesList = [];
    }

    return NewsArticle(
      title: json['title']?.toString() ?? '標題不明',
      publishTime: json['publish_time']?.toString() ?? '時間不明',
      reporter: json['reporter']?.toString() ?? '記者不明',
      content: json['content']?.toString() ?? '內容不明',
      images: imagesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'publish_time': publishTime,
      'reporter': reporter,
      'content': content,
      'images': images.map((img) => img.toJson()).toList(),
    };
  }

  // 獲取主圖
  NewsImage? get mainImage {
    // 先找標記為主圖的
    for (final image in images) {
      if (image.isMain) {
        return image;
      }
    }
    // 如果沒有主圖標記，返回第一張圖片
    return images.isNotEmpty ? images.first : null;
  }

  // 是否有圖片
  bool get hasImages => images.isNotEmpty;

  // 圖片數量
  int get imageCount => images.length;
}

class NewsImage {
  final String url;
  final String alt;
  final String title;
  final bool isMain;

  NewsImage({
    required this.url,
    this.alt = '',
    this.title = '',
    this.isMain = false,
  });

  factory NewsImage.fromJson(Map<String, dynamic> json) {
    return NewsImage(
      url: json['url']?.toString() ?? '',
      alt: json['alt']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      isMain: json['is_main'] == true || json['is_main'] == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'alt': alt,
      'title': title,
      'is_main': isMain,
    };
  }

  // 檢查圖片URL是否有效
  bool get isValidUrl {
    return url.isNotEmpty &&
        (url.startsWith('http://') || url.startsWith('https://'));
  }
}
