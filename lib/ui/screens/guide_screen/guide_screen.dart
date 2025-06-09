// guide_screen.dart
import 'package:flutter/material.dart';
import 'package:pm25_app/ui/screens/guide_screen/guide_provider.dart';
import 'package:provider/provider.dart';

/// 自訂 PageScrollPhysics，降低誤觸翻頁機率
class CustomPageScrollPhysics extends PageScrollPhysics {
  const CustomPageScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageScrollPhysics(parent: buildParent(ancestor));
  }

  /// 調高觸發翻頁的最小速度，減少輕滑誤觸
  @override
  double get minFlingVelocity => 800.0;
}

/// 無狀態的引導頁面組件，使用 Provider 管理狀態
class GuideScreen extends StatelessWidget {
  static const String routeName = '/guide';
  const GuideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GuideProvider>(
      create: (_) => GuideProvider(),
      child: Consumer<GuideProvider>(
        builder: (context, provider, _) {
          // 高對比度漸層：紫紅→橙黃
          final gradient = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurpleAccent.withOpacity(0.8),
              Colors.orangeAccent.withOpacity(0.8),
            ],
          );
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(gradient: gradient),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: provider.pageController,
                        physics: const CustomPageScrollPhysics(),
                        pageSnapping: true,
                        itemCount: provider.pages.length,
                        onPageChanged: provider.onPageChanged,
                        itemBuilder: (context, idx) {
                          final page = provider.pages[idx];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 48),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(page.icon, size: 120, color: Colors.white),
                                const SizedBox(height: 40),
                                Text(
                                  page.title,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  page.description,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // 圓點指示器
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(provider.pages.length, (idx) {
                        final isActive = provider.currentIndex == idx;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 18 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),

                    // 按鈕列
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.skip_next,
                                color: Colors.white),
                            label: const Text('跳過',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () => provider.skip(context),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            onPressed: provider.currentIndex <
                                    provider.pages.length - 1
                                ? provider.nextPage
                                : () => provider.finish(context),
                            child: Text(
                              provider.currentIndex < provider.pages.length - 1
                                  ? '下一步'
                                  : '開始體驗',
                              style: const TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
