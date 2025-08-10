import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pm25_app/core/firebase_options.dart';
import 'package:pm25_app/core/loggers/error_handler.dart';
import 'package:pm25_app/core/loggers/log.dart';
import 'package:pm25_app/core/routes.dart';
import 'package:pm25_app/core/services/navigation_service.dart';
import 'package:pm25_app/features/auth/model.dart';
import 'package:pm25_app/ui/widgets/gfwidgets/alert.dart';
import 'package:provider/provider.dart';

import 'features/aqi/aqi_provider.dart';
import 'features/news/news_provider.dart';

/// 進入點：負責執行 Flutter App
void main() async {
  AppLogger.init();
  final log = AppLogger('main');

  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Firebase
  // 這裡的 try-catch 是為了捕捉 Firebase 初始化過程中的任何錯誤
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log.i('Firebase 初始化成功');
  } catch (e, stack) {
    log.e('Firebase 初始化失败', e, stack);
    // FirebaseCrashlytics.instance.recordError(e, null, fatal: true);
  }

  // 全域錯誤處理設定
  setupGlobalErrorHandlers();

  // MultiProvider 注入所有 ChangeNotifier
  runApp(
    MultiProvider(
      providers: [
        // 這裡的 ChangeNotifierProvider 是用來提供狀態管理的
        // 這些 Provider 可以在整個應用程式中被使用
        //ChangeNotifierProvider(create: (_) => BackToTopNotifier()),
        ChangeNotifierProvider(create: (_) => GfAlertProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final model = SignInModel();
            // model._restoreCredentials() 已在建構子裡呼叫
            return model;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final model = RegisterModel();

            return model;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final model = ForgotPasswordModel();

            return model;
          },
        ),
        ChangeNotifierProvider(
          create: (_) => AqiProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NewsProvider(),
        ),

        Provider<NavigationService>(
          create: (_) => NavigationService(),
          // listen: false is default for Provider<T>
        ),
        // ... 如有其他 Provider 再繼續加
      ],
      child: const MyApp(),
    ),
  );
}

/// 整個 App 的根組件
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1️⃣ 從 Provider 拿到同一個 NavigationService
    final navService = Provider.of<NavigationService>(context, listen: false);

    return MaterialApp(
      title: '空氣品質監測地區',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      debugShowCheckedModeBanner: false,
      // 首頁改成依照是否已登入決定可用 SignInModel

      // 2️⃣ 把 navigatorKey 傳進去，讓全 app 都用這把 Key 來導航
      navigatorKey: navService.navigatorKey,
      // 3️⃣ 使用 NavigatorService 的路由表
      initialRoute: AppRoutes.guide,
      routes: appRouteTable,
    );
  }
}


/*所有GFwidgets皆參考以下資訊
    作者：Haoyu
    链接：https://juejin.cn/post/7081298839323279373
    来源：稀土掘金
    著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。*/