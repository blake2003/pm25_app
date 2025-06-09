import 'package:flutter/material.dart';
import 'package:pm25_app/ui/widgets/gfwidgets/gfdrawer.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        // 移除返回按钮，因为这是主页面
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Navigator.pop(context),
        // ),
      ),
      body: const Center(
        child: Text('首页内容'),
      ),
      // 直接使用自定义的 GfDrawer
      drawer: const GfDrawer(),
    );
  }
}
