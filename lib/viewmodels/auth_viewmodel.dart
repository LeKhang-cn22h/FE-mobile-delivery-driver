import 'package:flutter/foundation.dart';

import '../data/models/user_model.dart';
import '../data/services/auth_service.dart';


/// Trạng thái authentication
enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// AuthViewModel - Quản lý state cho Login/Register
class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;

  AuthViewModel({AuthService? authService})
      : _authService = authService ?? AuthService();

  // ===== STATE =====
  AuthState _state = AuthState.initial;
  UserModel? _user;
  String? _errorMessage;
  bool _isPasswordVisible = false;       // THÊM
  bool _isConfirmPasswordVisible = false; // THÊM

  // ===== GETTERS =====
  AuthState get state => _state;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  bool get isLoading => _state == AuthState.loading;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get hasError => _errorMessage != null && _errorMessage!.isNotEmpty;

  // ==========================================
  // TOGGLE PASSWORD VISIBILITY
  // ==========================================

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  // ==========================================
  // KIỂM TRA TRẠNG THÁI BAN ĐẦU
  // ==========================================

  Future<void> checkAuthStatus() async {
    _state = AuthState.loading;
    notifyListeners();

    final isLoggedIn = await _authService.isLoggedIn();

    if (isLoggedIn) {
      _state = AuthState.authenticated;
    } else {
      _state = AuthState.unauthenticated;
    }

    notifyListeners();
  }

  // ==========================================
  // ĐĂNG NHẬP
  // ==========================================

  /// Đăng nhập - nhận 2 params riêng biệt
  Future<bool> login(String email, String password) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      _user = response.user;
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.unauthenticated;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // ==========================================
  // ĐĂNG KÝ
  // ==========================================

  /// Đăng ký
  Future<bool> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String fullName,
    String? phone,
  }) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.register(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        fullName: fullName,
        phone: phone,
      );

      _user = response.user;
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.unauthenticated;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // ==========================================
  // ĐĂNG XUẤT
  // ==========================================

  Future<void> logout() async {
    _state = AuthState.loading;
    notifyListeners();

    await _authService.logout();

    _user = null;
    _state = AuthState.unauthenticated;
    _isPasswordVisible = false;
    _isConfirmPasswordVisible = false;
    notifyListeners();
  }

  // ==========================================
  // QUÊN MẬT KHẨU
  // ==========================================

  Future<bool> resetPassword(String email) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
      _state = AuthState.unauthenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.unauthenticated;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // ==========================================
  // HELPERS
  // ==========================================

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void reset() {
    _state = AuthState.initial;
    _user = null;
    _errorMessage = null;
    _isPasswordVisible = false;
    _isConfirmPasswordVisible = false;
    notifyListeners();
  }
}