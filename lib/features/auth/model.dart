import 'package:flutter/material.dart';
import 'package:pm25_app/core/storage/auth_local_storage.dart';
import 'package:pm25_app/features/auth/auth_service.dart';

class RegisterModel extends ChangeNotifier {
  // 控制器
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // 状态
  bool _isLoading = false;
  String? _errorMessage;

  // getters
  bool get isLoading => _isLoading;
  String? get error => _errorMessage;

  /// 执行注册，返回 true = 成功、false = 失败
  Future<bool> submit() async {
    _setLoading(true);
    _setError(null);

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // 验证密码是否匹配
    if (password != confirmPassword) {
      _setError('密码不匹配');
      _setLoading(false);
      return false;
    }

    try {
      // 调用注册服务
      final result = await RegisterService.register(
        email: email,
        password: password,
      );

      if (result != null) {
        // 服务层返回错误信息
        _setError(result);
        return false;
      }
      return true;
    } catch (e, st) {
      // 捕获任何非预期异常
      _setError('注册时发生非预期错误');
      debugPrint('RegisterModel.submit exception: $e\n$st');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // private helpers
  void _setLoading(bool v) {
    if (_isLoading == v) return;
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? msg) {
    if (_errorMessage == msg) return;
    _errorMessage = msg;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }
}

class SignInModel extends ChangeNotifier {
  // controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // state
  bool _remember = false;
  bool _isLoading = false;
  String? _errorMessage;

  // getters
  bool get remember => _remember;
  bool get isLoading => _isLoading;
  String? get error => _errorMessage;

  SignInModel() {
    _restoreCredentials();
  }

  /// 主動刷新帳密（給外部呼叫）
  Future<void> refreshCredentials() async {
    await _restoreCredentials();
  }

  /// 從 SharedPreferences 載入已儲存的帳密
  Future<void> _restoreCredentials() async {
    emailController.clear();
    passwordController.clear();
    final creds = await CredentialStorage.load();
    emailController.text = creds.email;
    passwordController.text = creds.password;
    _remember = creds.rememberMe;
    notifyListeners();
  }

  /// 切換「記住我」狀態
  void toggleRemember(bool? v) {
    _remember = v ?? false;
    if (!_remember) {
      passwordController.clear();
    }
    notifyListeners();
  }

  /// 執行登入，返回 true = 成功、false = 失敗
  Future<bool> submit() async {
    _setLoading(true);
    _setError(null);

    final email = emailController.text.trim();
    final pwd = passwordController.text.trim();

    try {
      // ① 呼叫 SignInService，這裡它已經處理了 FirebaseAuthException
      final result = await SignInService.signIn(
        email: email,
        password: pwd,
        remember: _remember,
      );
      if (result != null) {
        // 服務層回傳錯誤訊息
        _setError(result);
        return false;
      }
      return true;
    } catch (e, st) {
      // ② 再 catch 一次：攔截任何非預期例外
      _setError('登入時發生非預期錯誤');
      debugPrint('SignInModel.submit exception: $e\n$st');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // private helpers
  void _setLoading(bool v) {
    if (_isLoading == v) return;
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? msg) {
    if (_errorMessage == msg) return;
    _errorMessage = msg;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class ForgotPasswordModel extends ChangeNotifier {
  // 控制器，只需要 email
  final TextEditingController emailController = TextEditingController();

  // 載入中與錯誤 / 訊息狀態
  bool _isLoading = false;
  String? _errorMessage;
  String? _infoMessage;

  // getters
  bool get isLoading => _isLoading;
  String? get error => _errorMessage;
  String? get info => _infoMessage;

  /// 送出重設密碼請求
  /// 回傳 true 代表成功、false 代表失敗
  Future<bool> submit() async {
    _setLoading(true);
    _setError(null);
    _setInfo(null);

    final email = emailController.text.trim();

    try {
      // 需要在 AuthService 中實作 sendPasswordResetEmail
      final result = await ForgotPassword.sendPasswordResetEmail(email);
      if (result != null) {
        // 服務層回傳錯誤訊息（如驗證失敗、網路錯誤等）
        _setError(result);
        return false;
      }

      // 無錯誤：告知使用者信件已發送
      _setInfo('已向 $email 發送密碼重設連結');
      return true;
    } catch (e, st) {
      // 捕捉任何預期外錯誤
      _setError('發送重設郵件時發生錯誤');
      debugPrint('ForgotPasswordModel.submit exception: $e\n$st');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // private helpers
  void _setLoading(bool v) {
    if (_isLoading == v) return;
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? msg) {
    if (_errorMessage == msg) return;
    _errorMessage = msg;
    notifyListeners();
  }

  void _setInfo(String? msg) {
    if (_infoMessage == msg) return;
    _infoMessage = msg;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
