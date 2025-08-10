import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pm25_app/features/auth/auth_service.dart';
import 'package:pm25_app/ui/screens/auth/sign_in_screen.dart';
import 'package:pm25_app/ui/screens/guide/guide_page.dart';
import 'package:pm25_app/ui/screens/main/home_screen.dart';

/// GfDrawer：自定義 Drawer，提供多項選單功能
class GfDrawer extends StatelessWidget {
  const GfDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return GFDrawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeaderWidget(),
          DrawerListTile(
            leading: const Icon(Icons.home, color: GFColors.PRIMARY),
            title: '首頁',
            onTap: () => _navigateTo(context, const HomeScreen()),
          ),
          DrawerListTile(
            leading: const Icon(Icons.map, color: GFColors.PRIMARY),
            title: '回導覽頁',
            onTap: () => _navigateTo(context, const GuideScreen()),
          ),
          FutureBuilder<User?>(
            future: _getCurrentUser(),
            builder: (context, snapshot) {
              final user = snapshot.data;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              }
              if (user == null) {
                // 未登入顯示登入
                return DrawerListTile(
                  leading: const Icon(Icons.login, color: GFColors.SUCCESS),
                  title: '登入',
                  onTap: () => _navigateTo(context, const SignInScreen()),
                );
              } else {
                // 已登入顯示登出
                return DrawerListTile(
                  leading: const Icon(Icons.logout, color: GFColors.DANGER),
                  title: '登出',
                  onTap: () => _handleLogout(context),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  /// 導航至指定頁面
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  /// 登出處理：呼叫 FirebaseAuth 的 signOut 並跳轉到登入頁
  Future<void> _handleLogout(BuildContext context) async {
    await signOut();
    Navigator.of(context).pushReplacementNamed('/home');
  }

  Future<User?> _getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }
}

/// DrawerHeaderWidget：Drawer 的頭部
class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const GFDrawerHeader(
      currentAccountPicture: GFAvatar(
          //backgroundImage: AssetImage('images/cat.jpeg'),
          ),
      decoration: BoxDecoration(
        color: GFColors.PRIMARY,
      ),
      otherAccountsPictures: [
        GFAvatar(
            //backgroundImage: AssetImage('images/cat.jpeg'),
            ),
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('小黑', style: TextStyle(color: Colors.white)),
          Text('Flutter新手小白', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

/// DrawerListTile：客製化的 ListTile 用於 Drawer
class DrawerListTile extends StatelessWidget {
  final Icon leading;
  final String title;
  final VoidCallback onTap;

  const DrawerListTile({
    super.key,
    required this.leading,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title),
      onTap: onTap,
    );
  }
}
