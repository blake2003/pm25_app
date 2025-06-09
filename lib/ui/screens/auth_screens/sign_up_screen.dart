import 'package:flutter/material.dart';
import 'package:pm25_app/core/services/navigation_service.dart';
import 'package:pm25_app/features/auth/auth.model.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  static const String routeName = '/signup';

  // 定義邊框樣式
  OutlineInputBorder _border() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: const BorderSide(color: Color(0xFFd0d0d0)),
      );

  @override
  Widget build(BuildContext context) {
    // 1️⃣ 取得並監聽模型
    final model = context.watch<RegisterModel>();
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '創建新帳號',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '請填寫以下信息完成註冊，加入我們的平台',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              // 電子郵件輸入框
              TextField(
                controller: model.emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: _border(),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // 密碼輸入框
              TextField(
                controller: model.passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: _border(),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              // 確認密碼輸入框
              TextField(
                controller: model.confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Enter your password again',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: _border(),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),

              // 註冊按鈕
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
                          // 隱藏鍵盤
                          FocusScope.of(context).unfocus();

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
                                content: Text('註冊失敗（系統錯誤）'),
                              ),
                            );
                            return;
                          }

                          if (ok) {
                            // 註冊成功，顯示提示並返回登入頁
                            messenger.showSnackBar(
                              const SnackBar(content: Text('註冊成功')),
                            );
                            // 註冊成功後跳轉回登入頁
                            nav.pushNamed('/signin');
                          } else {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(model.error ?? '註冊失敗'),
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
                          'Sign Up',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 32),
              // 返回登入的提示
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?  '),
                  GestureDetector(
                    onTap: () {
                      // 導向註冊頁
                      nav.pushNamed('/signin');
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
