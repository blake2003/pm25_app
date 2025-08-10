import 'package:flutter_test/flutter_test.dart';
import 'package:pm25_app/features/news/model.dart';

void main() {
  group('NewsArticle null safety tests', () {
    test('應該正確處理完整的JSON資料', () {
      final json = {
        'title': '測試新聞標題',
        'publish_time': '2024-01-01 12:00:00',
        'reporter': '測試記者',
        'content': '測試新聞內容',
        'images': [
          {
            'url': 'https://example.com/image1.jpg',
            'alt': '圖片描述',
            'title': '圖片標題',
            'is_main': true
          },
          {
            'url': 'https://example.com/image2.jpg',
            'alt': '圖片描述2',
            'title': '圖片標題2',
            'is_main': false
          }
        ]
      };

      final article = NewsArticle.fromJson(json);

      expect(article.title, '測試新聞標題');
      expect(article.publishTime, '2024-01-01 12:00:00');
      expect(article.reporter, '測試記者');
      expect(article.content, '測試新聞內容');
      expect(article.images.length, 2);
      expect(article.hasImages, true);
      expect(article.imageCount, 2);
      expect(article.mainImage?.url, 'https://example.com/image1.jpg');
      expect(article.mainImage?.isMain, true);
    });

    test('應該正確處理沒有images字段的JSON', () {
      final json = {
        'title': '無圖片新聞',
        'publish_time': '2024-01-01 12:00:00',
        'reporter': '測試記者',
        'content': '測試新聞內容'
        // 沒有 images 字段
      };

      final article = NewsArticle.fromJson(json);

      expect(article.title, '無圖片新聞');
      expect(article.images.length, 0);
      expect(article.hasImages, false);
      expect(article.imageCount, 0);
      expect(article.mainImage, null);
    });

    test('應該正確處理images為null的JSON', () {
      final json = {
        'title': '圖片為null的新聞',
        'publish_time': '2024-01-01 12:00:00',
        'reporter': '測試記者',
        'content': '測試新聞內容',
        'images': null
      };

      final article = NewsArticle.fromJson(json);

      expect(article.title, '圖片為null的新聞');
      expect(article.images.length, 0);
      expect(article.hasImages, false);
      expect(article.imageCount, 0);
      expect(article.mainImage, null);
    });

    test('應該正確處理images為空陣列的JSON', () {
      final json = {
        'title': '空圖片陣列新聞',
        'publish_time': '2024-01-01 12:00:00',
        'reporter': '測試記者',
        'content': '測試新聞內容',
        'images': []
      };

      final article = NewsArticle.fromJson(json);

      expect(article.title, '空圖片陣列新聞');
      expect(article.images.length, 0);
      expect(article.hasImages, false);
      expect(article.imageCount, 0);
      expect(article.mainImage, null);
    });

    test('應該正確處理缺少必要字段的JSON', () {
      final json = {
        'title': null,
        'publish_time': null,
        'reporter': null,
        'content': null,
        'images': null
      };

      final article = NewsArticle.fromJson(json);

      expect(article.title, '標題不明');
      expect(article.publishTime, '時間不明');
      expect(article.reporter, '記者不明');
      expect(article.content, '內容不明');
      expect(article.images.length, 0);
    });

    test('應該正確處理包含無效圖片資料的JSON', () {
      final json = {
        'title': '部分無效圖片新聞',
        'publish_time': '2024-01-01 12:00:00',
        'reporter': '測試記者',
        'content': '測試新聞內容',
        'images': [
          {
            'url': 'https://example.com/valid.jpg',
            'alt': '有效圖片',
            'is_main': true
          },
          null, // 無效圖片資料
          {
            'url': null, // 無效URL
            'alt': '無效圖片'
          },
          {
            'url': 'https://example.com/valid2.jpg',
            'alt': '另一張有效圖片',
            'is_main': false
          }
        ]
      };

      final article = NewsArticle.fromJson(json);

      expect(article.title, '部分無效圖片新聞');
      // 應該只保留有效的圖片
      expect(article.images.length, 2);
      expect(article.hasImages, true);
      expect(article.mainImage?.url, 'https://example.com/valid.jpg');
    });

    test('應該正確處理沒有主圖標記的情況', () {
      final json = {
        'title': '無主圖標記新聞',
        'publish_time': '2024-01-01 12:00:00',
        'reporter': '測試記者',
        'content': '測試新聞內容',
        'images': [
          {
            'url': 'https://example.com/image1.jpg',
            'alt': '第一張圖',
            'is_main': false
          },
          {
            'url': 'https://example.com/image2.jpg',
            'alt': '第二張圖',
            'is_main': false
          }
        ]
      };

      final article = NewsArticle.fromJson(json);

      expect(article.images.length, 2);
      expect(article.hasImages, true);
      // 當沒有主圖標記時，應該返回第一張圖片
      expect(article.mainImage?.url, 'https://example.com/image1.jpg');
      expect(article.mainImage?.isMain, false);
    });

    test('NewsImage 應該正確處理各種資料類型', () {
      final json = {
        'url': 'https://example.com/test.jpg',
        'alt': 123, // 數字類型
        'title': true, // 布林類型
        'is_main': 'true' // 字串類型的布林值
      };

      final image = NewsImage.fromJson(json);

      expect(image.url, 'https://example.com/test.jpg');
      expect(image.alt, '123');
      expect(image.title, 'true');
      expect(image.isMain, true);
      expect(image.isValidUrl, true);
    });

    test('NewsImage.isValidUrl 應該正確檢查URL有效性', () {
      final validImage = NewsImage(url: 'https://example.com/test.jpg');
      final invalidImage1 = NewsImage(url: '');
      final invalidImage2 = NewsImage(url: 'invalid-url');

      expect(validImage.isValidUrl, true);
      expect(invalidImage1.isValidUrl, false);
      expect(invalidImage2.isValidUrl, false);
    });
  });
}
