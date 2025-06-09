// validator.dart
class Validator {
  static bool isValidEmail(String email) {
    // 簡單 Email 格式檢查
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    // 這裡示範密碼長度至少 6 碼
    return password.length >= 6;
  }
}
