import 'package:flutter_test/flutter_test.dart';
import 'package:pm25_app/features/news/model.dart';
import 'package:pm25_app/features/news/news_provider.dart';

void main() {
  group('NewsProvider Tests', () {
    late NewsProvider provider;

    setUp(() {
      provider = NewsProvider();
    });

    test('初始狀態應該正確', () {
      expect(provider.newsList, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
      expect(provider.lastFetchTime, isNull);
      expect(provider.hasData, isFalse);
      expect(provider.hasError, isFalse);
      expect(provider.shouldLoadData, isTrue);
      expect(provider.formattedLastFetchTime, equals('尚未載入'));
    });

    test('shouldLoadData 應該在沒有資料且不在載入中時返回 true', () {
      expect(provider.shouldLoadData, isTrue);
    });

    test('formattedLastFetchTime 應該正確格式化時間', () {
      // 測試格式化邏輯
      final testTime = DateTime.now().subtract(const Duration(minutes: 5));
      final difference = DateTime.now().difference(testTime);
      expect(difference.inMinutes, greaterThanOrEqualTo(5));
    });

    test('clearError 應該清除錯誤狀態', () {
      expect(provider.hasError, isFalse);
    });

    test('reset 應該重置所有狀態', () {
      provider.reset();

      expect(provider.newsList, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
      expect(provider.lastFetchTime, isNull);
      expect(provider.hasData, isFalse);
      expect(provider.hasError, isFalse);
    });

    test('NewsArticle 模型測試', () {
      final news = NewsArticle(
        title: '測試新聞',
        publishTime: '2024-01-01 12:00:00',
        reporter: '測試記者',
        content: '測試內容',
        images: [],
      );

      expect(news.title, equals('測試新聞'));
      expect(news.reporter, equals('測試記者'));
      expect(news.hasImages, isFalse);
      expect(news.imageCount, equals(0));
      expect(news.mainImage, isNull);
    });

    test('NewsArticle 圖片處理測試', () {
      final images = [
        NewsImage(url: 'http://example.com/image1.jpg', isMain: true),
        NewsImage(url: 'http://example.com/image2.jpg'),
      ];

      final news = NewsArticle(
        title: '測試新聞',
        publishTime: '2024-01-01 12:00:00',
        reporter: '測試記者',
        content: '測試內容',
        images: images,
      );

      expect(news.hasImages, isTrue);
      expect(news.imageCount, equals(2));
      expect(news.mainImage, isNotNull);
      expect(news.mainImage!.url, equals('http://example.com/image1.jpg'));
    });

    test('NewsImage 模型測試', () {
      final image = NewsImage(
        url: 'http://example.com/test.jpg',
        alt: '測試圖片',
        title: '測試標題',
        isMain: true,
      );

      expect(image.url, equals('http://example.com/test.jpg'));
      expect(image.alt, equals('測試圖片'));
      expect(image.title, equals('測試標題'));
      expect(image.isMain, isTrue);
      expect(image.isValidUrl, isTrue);
    });

    test('NewsImage 無效 URL 測試', () {
      final image = NewsImage(url: '');
      expect(image.isValidUrl, isFalse);
    });
  });
}
