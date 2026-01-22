import '../../../core/storage/auth_storage.dart';
import '../models/auth_response_model.dart';
import '../repositories/auth_repository.dart';

/// AuthService - Xử lý nghiệp vụ authentication
class AuthService {
  final AuthRepository _repository;
  final AuthStorage _authStorage;

  AuthService({
    AuthRepository? repository,
    AuthStorage? authStorage,
  })  : _repository = repository ?? AuthRepository(),
        _authStorage = authStorage ?? AuthStorage();

  // ==========================================
  // ĐĂNG NHẬP
  // ==========================================

  /// Đăng nhập với validation
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    // === VALIDATION ===
    if (email.isEmpty) {
      throw Exception('Vui lòng nhập email');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Email không hợp lệ');
    }

    if (password.isEmpty) {
      throw Exception('Vui lòng nhập mật khẩu');
    }

    // === GỌI REPOSITORY ===
    final response = await _repository.login(
      email: email.trim(),
      password: password,
    );

    // === LƯU TOKENS ===
    await _authStorage.saveAll(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      userId: response.user.id,
      userEmail: response.user.email,
    );

    return response;
  }

  // ==========================================
  // ĐĂNG KÝ
  // ==========================================

  /// Đăng ký với validation
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String fullName,
    String? phone,
  }) async {
    // === VALIDATION ===
    if (fullName.isEmpty) {
      throw Exception('Vui lòng nhập họ tên');
    }

    if (fullName.length < 2) {
      throw Exception('Họ tên phải có ít nhất 2 ký tự');
    }

    if (email.isEmpty) {
      throw Exception('Vui lòng nhập email');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Email không hợp lệ');
    }

    if (password.isEmpty) {
      throw Exception('Vui lòng nhập mật khẩu');
    }

    if (password.length < 6) {
      throw Exception('Mật khẩu phải có ít nhất 6 ký tự');
    }

    if (password != confirmPassword) {
      throw Exception('Mật khẩu xác nhận không khớp');
    }

    if (phone != null && phone.isNotEmpty && !_isValidPhone(phone)) {
      throw Exception('Số điện thoại không hợp lệ');
    }

    // === GỌI REPOSITORY ===
    final response = await _repository.register(
      email: email.trim(),
      password: password,
      fullName: fullName.trim(),
      phone: phone?.trim(),
    );
    return response;
  }

  // ==========================================
  // ĐĂNG XUẤT
  // ==========================================

  /// Đăng xuất
  Future<void> logout() async {
    try {
      await _repository.logout();
    } catch (_) {
      // Ignore error - vẫn clear local data
    }

    // Clear local tokens
    await _authStorage.clearAll();
  }

  // ==========================================
  // QUÊN MẬT KHẨU
  // ==========================================

  /// Gửi email reset password
  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      throw Exception('Vui lòng nhập email');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Email không hợp lệ');
    }

    await _repository.resetPassword(email.trim());
  }

  // ==========================================
  // KIỂM TRA TRẠNG THÁI
  // ==========================================

  /// Kiểm tra đã đăng nhập chưa
  Future<bool> isLoggedIn() async {
    return await _authStorage.isLoggedIn();
  }

  // ==========================================
  // PRIVATE HELPERS
  // ==========================================

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    final regex = RegExp(r'^0[0-9]{9}$');
    return regex.hasMatch(phone);
  }
}