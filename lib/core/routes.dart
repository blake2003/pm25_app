// lib/routes.dart
import 'package:flutter/material.dart';
import 'package:pm25_app/ui/screens/auth_screens/forgot_password_screen.dart';
import 'package:pm25_app/ui/screens/auth_screens/sign_in_screen.dart';
import 'package:pm25_app/ui/screens/auth_screens/sign_up_screen.dart';
import 'package:pm25_app/ui/screens/guide_screen/guide_screen.dart';
import 'package:pm25_app/ui/screens/home_screen.dart';

// 假設 HomePage1…HomePage30 各自存在對應檔案

// … 依序 import 到 home_page30.dart

/// 所有路由名稱
abstract class AppRoutes {
  // 基础路由
  //static const splash = '/';
  static const signIn = '/signin';
  static const signUp = '/signup';
  static const forgotPassword = '/forgot_password';
  static const home = '/home';
  static const guide = '/guide';
}

/// Route 表
final Map<String, WidgetBuilder> appRouteTable = {
  //AppRoutes.splash: (_) => const SplashScreenPage(),
  AppRoutes.signIn: (_) => const SignInScreen(),
  AppRoutes.signUp: (_) => const SignUpScreen(),
  AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
  AppRoutes.home: (_) => const HomeScreen(),
  AppRoutes.guide: (_) => const GuideScreen(),
  // … 其他 homePageN
};
