// navigation_service.dart
import 'package:flutter/material.dart';

class NavigationService {
  // 1. 全域 NavigatorState Key
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // 2. push 原生 Route
  Future<T?> push<T extends Object?>(Route<T> route) {
    return navigatorKey.currentState!.push<T>(route);
  }

  // 3. pushNamed
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  // 4. pop
  void pop<T extends Object?>([T? result]) {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState!.pop<T>(result);
    }
  }
}
