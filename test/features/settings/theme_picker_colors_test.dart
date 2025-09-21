import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pm25_app/core/constants/theme/theme_colors.dart';
import 'package:pm25_app/features/settings/theme/theme_provider.dart';
import 'package:pm25_app/ui/screens/setting/settings_screen.dart';
import 'package:provider/provider.dart';

void main() {
  group('主題選擇器顏色測試', () {
    late ThemeProvider themeProvider;

    setUp(() {
      themeProvider = ThemeProvider();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<ThemeProvider>.value(
          value: themeProvider,
          child: const SettingsScreen(),
        ),
      );
    }

    testWidgets('深色主題下主題選擇器文字應該為白色', (WidgetTester tester) async {
      // 設定深色主題
      await themeProvider.toggleTheme(AppThemeMode.dark);
      await tester.pumpAndSettle();

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 點擊外觀設定項目開啟主題選擇器
      await tester.tap(find.text('外觀'));
      await tester.pumpAndSettle();

      // 檢查標題文字顏色
      final titleFinder = find.text('選擇主題');
      expect(titleFinder, findsOneWidget);

      final titleWidget = tester.widget<Text>(titleFinder);
      expect(titleWidget.style?.color, equals(const Color(0xFFFFFFFF))); // 白色

      // 檢查選項文字顏色
      final themeOptions = ['自動', '淺色', '深色'];
      for (final option in themeOptions) {
        final optionFinder = find.text(option);
        expect(optionFinder, findsOneWidget);

        final optionWidget = tester.widget<Text>(optionFinder);
        expect(
            optionWidget.style?.color, equals(const Color(0xFFFFFFFF))); // 白色
      }

      // 檢查按鈕文字顏色
      final cancelButtonFinder = find.text('取消');
      expect(cancelButtonFinder, findsOneWidget);

      final cancelButtonWidget = tester.widget<Text>(cancelButtonFinder);
      expect(cancelButtonWidget.style?.color,
          equals(const Color(0xFFFFFFFF))); // 白色

      final confirmButtonFinder = find.text('確定');
      expect(confirmButtonFinder, findsOneWidget);

      final confirmButtonWidget = tester.widget<Text>(confirmButtonFinder);
      expect(confirmButtonWidget.style?.color,
          equals(const Color(0xFFFFFFFF))); // 白色
    });

    testWidgets('淺色主題下主題選擇器文字應該為黑色', (WidgetTester tester) async {
      // 設定淺色主題
      await themeProvider.toggleTheme(AppThemeMode.light);
      await tester.pumpAndSettle();

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 點擊外觀設定項目開啟主題選擇器
      await tester.tap(find.text('外觀'));
      await tester.pumpAndSettle();

      // 檢查標題文字顏色
      final titleFinder = find.text('選擇主題');
      expect(titleFinder, findsOneWidget);

      final titleWidget = tester.widget<Text>(titleFinder);
      expect(titleWidget.style?.color, equals(const Color(0xFF000000))); // 黑色

      // 檢查選項文字顏色
      final themeOptions = ['自動', '淺色', '深色'];
      for (final option in themeOptions) {
        final optionFinder = find.text(option);
        expect(optionFinder, findsOneWidget);

        final optionWidget = tester.widget<Text>(optionFinder);
        expect(
            optionWidget.style?.color, equals(const Color(0xFF000000))); // 黑色
      }

      // 檢查按鈕文字顏色
      final cancelButtonFinder = find.text('取消');
      expect(cancelButtonFinder, findsOneWidget);

      final cancelButtonWidget = tester.widget<Text>(cancelButtonFinder);
      expect(cancelButtonWidget.style?.color,
          equals(const Color(0xFF000000))); // 黑色

      final confirmButtonFinder = find.text('確定');
      expect(confirmButtonFinder, findsOneWidget);

      final confirmButtonWidget = tester.widget<Text>(confirmButtonFinder);
      expect(confirmButtonWidget.style?.color,
          equals(const Color(0xFF000000))); // 黑色
    });

    testWidgets('語言選擇器也應該使用正確的文字顏色', (WidgetTester tester) async {
      // 設定深色主題
      await themeProvider.toggleTheme(AppThemeMode.dark);
      await tester.pumpAndSettle();

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 點擊語言設定項目開啟語言選擇器
      await tester.tap(find.text('語言'));
      await tester.pumpAndSettle();

      // 檢查標題文字顏色
      final titleFinder = find.text('選擇語言');
      expect(titleFinder, findsOneWidget);

      final titleWidget = tester.widget<Text>(titleFinder);
      expect(titleWidget.style?.color, equals(const Color(0xFFFFFFFF))); // 白色

      // 檢查語言選項文字顏色
      final languageOptions = ['繁體中文', 'English', '日本語', '한국어'];
      for (final option in languageOptions) {
        final optionFinder = find.text(option);
        expect(optionFinder, findsOneWidget);

        final optionWidget = tester.widget<Text>(optionFinder);
        expect(
            optionWidget.style?.color, equals(const Color(0xFFFFFFFF))); // 白色
      }
    });
  });
}
