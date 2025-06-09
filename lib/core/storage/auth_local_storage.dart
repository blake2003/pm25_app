import 'package:pm25_app/core/loggers/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 資料模型 ─ 也可以用 record (Dart 3) 或 freezed
class SavedCredential {
  final String email;
  final String password;
  final bool rememberMe; // 與 model 相同
  const SavedCredential(
      {required this.email, required this.password, required this.rememberMe});
}

class CredentialStorage {
  static const _kEmailKey = 'saved_email';
  static const _kPwdKey = 'saved_password';
  static const _kRemember = 'remember_me';

  /// 載入；若未勾 [remember_me] 則回傳空字串
  static Future<SavedCredential> load() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool(_kRemember) ?? false;
    return SavedCredential(
      email: remember ? (prefs.getString(_kEmailKey) ?? '') : '',
      password: remember ? (prefs.getString(_kPwdKey) ?? '') : '',
      rememberMe: remember,
    );
  }

  /// 儲存或清除
  static Future<void> save({
    required bool remember,
    required String email,
    required String password,
  }) async {
    final log = AppLogger('CredentialStorage');
    final prefs = await SharedPreferences.getInstance();
    if (remember) {
      log.i(
          '儲存帳密: email=[31m[1m[0m[32m[1m[0m[33m[1m[0m[34m[1m[0m[35m[1m[0m[36m[1m[0m[37m[1m[0m[90m[1m[0m[91m[1m[0m[92m[1m[0m[93m[1m[0m[94m[1m[0m[95m[1m[0m[96m[1m[0m[97m[1m[0m$email, password=***');
      await prefs.setString(_kEmailKey, email);
      log.i('已寫入 $_kEmailKey');
      await prefs.setString(_kPwdKey, password);
      log.i('已寫入 $_kPwdKey');
      await prefs.setBool(_kRemember, true);
      log.i('已寫入 $_kRemember=true');
    } else {
      log.i('清除帳密');
      await prefs.remove(_kEmailKey);
      log.i('已移除 $_kEmailKey');
      await prefs.remove(_kPwdKey);
      log.i('已移除 $_kPwdKey');
      await prefs.setBool(_kRemember, false);
      log.i('已寫入 $_kRemember=false');
    }
  }
}

// 可能是狀態被保留了，所以登出後，帳密還在
// key會被清除，所以hot reload後，帳密會被清除