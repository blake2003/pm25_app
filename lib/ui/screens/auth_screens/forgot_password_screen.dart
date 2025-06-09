import 'package:flutter/material.dart';
import 'package:pm25_app/core/loggers/log.dart';
import 'package:pm25_app/core/services/navigation_service.dart';
import 'package:pm25_app/features/auth/auth.model.dart';
import 'package:pm25_app/ui/extensions/no_account_text.dart';
import 'package:pm25_app/ui/widgets/gfwidgets/alert.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  static const String routeName = "/forgot_password";

  // 定義邊框樣式
  OutlineInputBorder _border() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: const BorderSide(color: Color(0xFFd0d0d0)),
      );

  @override
  Widget build(BuildContext context) {
    final log = AppLogger('Body');
    log.i('Body build() called');

    // 1️⃣ 取得並監聽模型
    final model = context.watch<ForgotPasswordModel>();
    //final nav = Provider.of<NavigationService>(context, listen: false);
    final alertProv = context.watch<GfAlertProvider>();
    log.i('model: $model');

    return Stack(
      children: [
        // 主畫面
        Scaffold(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Please enter your email and we will send you a link to return to your account",
                      style: TextStyle(
                        color: Colors.grey,
                        height: 1.5,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),

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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 20),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Submit button
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
                                final nav = Provider.of<NavigationService>(
                                    context,
                                    listen: false);
                                final messenger = ScaffoldMessenger.of(context);

                                bool ok;
                                try {
                                  ok = await model.submit();
                                  log.e('model.submit() returned: $ok');
                                } catch (e, st) {
                                  // 最后一层保护
                                  log.e('submit() threw: $e\n$st');
                                  debugPrint('submit() threw: $e\n$st');
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text('登入失敗（系統錯誤）'),
                                    ),
                                  );
                                  return;
                                }
                                if (ok) {
                                  // 成功，顯示通用樣板彈窗，並在按下關閉時導回 '/signin'
                                  context.read<GfAlertProvider>().showAlert(
                                        context: context,
                                        title: '信件已發送',
                                        content: Text(
                                            '請檢查信箱，${model.emailController.text}！'),
                                        buttonText: '返回登入',
                                        onPressed: () {
                                          // 隱藏彈窗
                                          context
                                              .read<GfAlertProvider>()
                                              .hideAlert();
                                          // 跳轉回登入頁（用你在 routes.dart 內定義的路由名稱或字串）
                                          nav.pushNamed('/signin');
                                        },
                                      ); // ← 參考通用樣板 showAlert 實作 :contentReference[oaicite:0]{index=0}
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
                                'Submit',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                      ),
                    ),

                    const SizedBox(height: 32),
                    const NoAccountText(),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            )),

        // 彈窗疊加層：只有在 isVisible 時顯示
        if (alertProv.isVisible) alertProv.alertWidget,
      ],
    );
  }
}
