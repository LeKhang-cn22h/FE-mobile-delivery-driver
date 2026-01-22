import '../../../../core/network/api_service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/auth_response_model.dart';

/// AuthRepository - Gọi API authentication
class AuthRepository {
  final ApiService _apiService;

  AuthRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// POST /api/v1/auth/login
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.login,
      body: {
        'email': email,
        'password': password,
      },
      requireAuth: false, // Login không cần token
    );

    if (response.success && response.data != null) {
      return AuthResponseModel.fromJson(response.data!);
    }

    throw Exception(response.message ?? 'Đăng nhập thất bại');
  }

  /// POST /api/v1/auth/register
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.register,
      body: {
        'email': email,
        'password': password,
        'full_name': fullName,
        if (phone != null) 'phone': phone,
      },
      requireAuth: false, // Register không cần token
    );

    if (response.success && response.data != null) {
      return AuthResponseModel.fromJson(response.data!);
    }

    throw Exception(response.message ?? 'Đăng ký thất bại');
  }

  /// POST /api/v1/auth/logout
  Future<void> logout() async {
    final response = await _apiService.post(ApiEndpoints.logout);

    if (!response.success) {
      throw Exception(response.message ?? 'Đăng xuất thất bại');
    }
  }

  /// POST /api/v1/auth/refresh
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    final response = await _apiService.post(
      ApiEndpoints.refreshToken,
      body: {'refresh_token': refreshToken},
      requireAuth: false,
    );

    if (response.success && response.data != null) {
      return AuthResponseModel.fromJson(response.data!);
    }

    throw Exception(response.message ?? 'Làm mới token thất bại');
  }

  /// POST /api/v1/auth/reset-password
  Future<void> resetPassword(String email) async {
    final response = await _apiService.post(
      ApiEndpoints.resetPassword,
      body: {'email': email},
      requireAuth: false,
    );

    if (!response.success) {
      throw Exception(response.message ?? 'Gửi yêu cầu thất bại');
    }
  }
}