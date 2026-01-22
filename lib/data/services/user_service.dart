import '../models/user_model.dart';
import '../repositories/user_repository.dart';

/// UserService - Xử lý nghiệp vụ liên quan đến User
///
/// Nhiệm vụ:
/// - Validate dữ liệu
/// - Business logic
/// - Gọi repository
class UserService {
  final UserRepository _repository;

  UserService({UserRepository? repository})
      : _repository = repository ?? UserRepository();

  // ==========================================
  // LẤY THÔNG TIN USER
  // ==========================================

  /// Lấy thông tin user hiện tại
  Future<UserModel> getCurrentUser() async {
    return await _repository.getCurrentUser();
  }

  // ==========================================
  // CẬP NHẬT PROFILE
  // ==========================================

  /// Cập nhật profile với validation
  Future<UserModel> updateProfile({
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    // === VALIDATION ===

    // Check có gì để update không
    if (_isEmpty(fullName) && _isEmpty(phone) && _isEmpty(avatarUrl)) {
      throw Exception('Vui lòng nhập thông tin cần cập nhật');
    }

    // Validate tên
    if (fullName != null && fullName.isNotEmpty) {
      if (fullName.length < 2) {
        throw Exception('Tên phải có ít nhất 2 ký tự');
      }
      if (fullName.length > 50) {
        throw Exception('Tên không được quá 50 ký tự');
      }
    }

    // Validate số điện thoại
    if (phone != null && phone.isNotEmpty) {
      if (!_isValidPhone(phone)) {
        throw Exception('Số điện thoại không hợp lệ (10 số, bắt đầu bằng 0)');
      }
    }

    // === GỌI REPOSITORY ===
    return await _repository.updateProfile(
      fullName: fullName,
      phone: phone,
      avatarUrl: avatarUrl,
    );
  }

  // ==========================================
  // ĐỔI MẬT KHẨU
  // ==========================================

  /// Đổi mật khẩu với validation
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    // === VALIDATION ===

    if (currentPassword.isEmpty) {
      throw Exception('Vui lòng nhập mật khẩu hiện tại');
    }

    if (newPassword.isEmpty) {
      throw Exception('Vui lòng nhập mật khẩu mới');
    }

    if (newPassword.length < 6) {
      throw Exception('Mật khẩu mới phải có ít nhất 6 ký tự');
    }

    if (newPassword != confirmPassword) {
      throw Exception('Mật khẩu xác nhận không khớp');
    }

    if (currentPassword == newPassword) {
      throw Exception('Mật khẩu mới phải khác mật khẩu hiện tại');
    }

    // === GỌI REPOSITORY ===
    return await _repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  // ==========================================
  // PRIVATE HELPERS
  // ==========================================

  bool _isEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// Validate SĐT Việt Nam: 10 số, bắt đầu bằng 0
  bool _isValidPhone(String phone) {
    final regex = RegExp(r'^0[0-9]{9}$');
    return regex.hasMatch(phone);
  }
}