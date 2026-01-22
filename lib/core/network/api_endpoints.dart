/// ApiEndpoints - Tập trung tất cả API paths
///
/// Chỉ chứa paths, không chứa base URL
/// Dễ maintain khi API thay đổi
class ApiEndpoints {
  // Prevent instantiation
  ApiEndpoints._();

  // ===== API VERSION =====
  static const String _v1 = '/api/v1';

  // ==========================================
  // AUTH ENDPOINTS
  // ==========================================
  static const String login = '$_v1/auth/login';
  static const String register = '$_v1/auth/register';
  static const String logout = '$_v1/auth/logout';
  static const String refreshToken = '$_v1/auth/refresh';
  static const String me = '$_v1/auth/me';
  static const String resetPassword = '$_v1/auth/reset-password';

}