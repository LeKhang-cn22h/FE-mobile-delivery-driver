
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_service.dart';
import '../models/user_model.dart';

/// Nhiệm vụ:
/// - Gọi API thông qua ApiService
/// - Parse response thành UserModel
/// - Xử lý business logic đơn giản
///
/// Sử dụng:
///   final repo = UserRepository();
///   final user = await repo.getCurrentUser();
class UserRepository {
  // ===== DEPENDENCIES =====
  final ApiService _apiService = ApiService();

  // ==========================================
  // GET CURRENT USER
  // ==========================================

  /// Lấy thông tin user đang đăng nhập
  ///
  /// API: GET /api/v1/auth/me
  /// Cần: Bearer token (ApiService tự động gắn)
  ///
  /// Returns: UserModel nếu thành công
  /// Throws: Exception nếu lỗi
  Future<UserModel> getCurrentUser() async {
    // 1. Gọi API
    final response = await _apiService.get(ApiEndpoints.me);

    // 2. Check kết quả
    if (response.success && response.data != null) {
      // 3. Parse JSON → UserModel
      return UserModel.fromJson(response.data!);
    }

    // 4. Throw error nếu failed
    throw Exception(response.message ?? 'Không thể lấy thông tin người dùng');
  }

  // ==========================================
  // UPDATE PROFILE
  // ==========================================

  /// Cập nhật thông tin profile
  ///
  /// API: PATCH /api/v1/auth/me
  /// Body: Chỉ gửi fields có giá trị
  ///
  /// [fullName] - Tên mới (optional)
  /// [phone] - SĐT mới (optional)
  /// [avatarUrl] - URL avatar mới (optional)
  ///
  /// Returns: UserModel đã cập nhật
  Future<UserModel> updateProfile({
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    // 1. Tạo body - chỉ gửi fields có giá trị
    final Map<String, dynamic> body = {};

    if (fullName != null && fullName.isNotEmpty) {
      body['full_name'] = fullName;
    }
    if (phone != null && phone.isNotEmpty) {
      body['phone'] = phone;
    }
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      body['avatar_url'] = avatarUrl;
    }

    // 2. Check có gì để update không
    if (body.isEmpty) {
      throw Exception('Không có thông tin nào để cập nhật');
    }

    // 3. Gọi API
    final response = await _apiService.patch(
      ApiEndpoints.me,
      body: body,
    );

    // 4. Xử lý kết quả
    if (response.success && response.data != null) {
      return UserModel.fromJson(response.data!);
    }

    throw Exception(response.message ?? 'Cập nhật thất bại');
  }

  // ==========================================
  // CHANGE PASSWORD (nếu cần)
  // ==========================================

  /// Đổi mật khẩu
  ///
  /// API: POST /api/v1/auth/change-password (nếu có)
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _apiService.post(
      '${ApiEndpoints.me}/change-password',
      body: {
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    );

    if (response.success) {
      return true;
    }

    throw Exception(response.message ?? 'Đổi mật khẩu thất bại');
  }

  // ==========================================
  // DELETE ACCOUNT (nếu cần)
  // ==========================================

  /// Xóa tài khoản
  Future<bool> deleteAccount() async {
    final response = await _apiService.delete(ApiEndpoints.me);

    if (response.success) {
      return true;
    }

    throw Exception(response.message ?? 'Xóa tài khoản thất bại');
  }
}