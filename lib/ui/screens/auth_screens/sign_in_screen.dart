// lib/pages/AuthPage/Body/sign_body.dart

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pm25_app/core/services/navigation_service.dart';
import 'package:pm25_app/features/auth/auth.model.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});
  static const String routeName = '/signin';

  // 定義邊框樣式
  OutlineInputBorder _border() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: const BorderSide(color: Color(0xFFd0d0d0)),
      );

  @override
  Widget build(BuildContext context) {
    // 1️⃣ 取得並監聽模型
    final model = context.watch<SignInModel>();
    final nav = Provider.of<NavigationService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Welcome to AMQ',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Log in with your email and password\nor continue with social media',
                style: TextStyle(fontSize: 15, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // E-mail
              TextField(
                controller: model.emailController, // 2️⃣ 綁定 controller
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: _border(),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                ),
              ),
              const SizedBox(height: 20),

              // Password
              TextField(
                controller: model.passwordController, // 2️⃣ 綁定 controller
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: _border(),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                ),
              ),
              const SizedBox(height: 24),

              // Remember me + Forgot password
              Row(
                children: [
                  Checkbox(
                    value: model.remember, // 3️⃣ 綁定 remember
                    onChanged: model.toggleRemember, // 3️⃣ 切換事件
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Text('Remember me'),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      // 導向註冊頁
                      nav.pushNamed('/forgot_password');
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ), //這裡有問題要改
                ],
              ),
              const SizedBox(height: 16),

              // Continue button
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2e3160),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  onPressed: model.isLoading
                      ? null
                      : () async {
                          // 同步先抓 navigator & messenger
                          final nav = Provider.of<NavigationService>(context,
                              listen: false);
                          final messenger = ScaffoldMessenger.of(context);

                          bool ok;
                          try {
                            ok = await model.submit();
                          } catch (e, st) {
                            // 最后一层保护
                            debugPrint('submit() threw: $e\n$st');
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('登入失敗（系統錯誤）'),
                              ),
                            );
                            return;
                          }

                          if (ok) {
                            nav.pushNamed('/guide');
                          } else {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(model.error ?? '登入失敗'),
                              ),
                            );
                          }
                        },
                  child: model.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 32),

              // social icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(MdiIcons.fromString("google")),
                      iconSize: 24,
                      onPressed: () {}),
                  IconButton(
                      icon: Icon(MdiIcons.fromString("facebook")),
                      iconSize: 24,
                      onPressed: () {}),
                  IconButton(
                      icon: Icon(MdiIcons.fromString("twitter")),
                      iconSize: 24,
                      onPressed: () {}),
                ],
              ),
              const SizedBox(height: 24),

              // Sign-up text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?  "),
                  GestureDetector(
                    onTap: () {
                      // 導向註冊頁
                      nav.pushNamed('/signup');
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
