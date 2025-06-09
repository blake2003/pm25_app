import 'package:flutter/material.dart';
import 'package:pm25_app/core/services/navigation_service.dart';
import 'package:provider/provider.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationService>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don’t have an account? ",
          style: TextStyle(
            color: Colors.grey,
            height: 1.5,
            fontSize: 16,
          ),
        ),
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
    );
  }
}
