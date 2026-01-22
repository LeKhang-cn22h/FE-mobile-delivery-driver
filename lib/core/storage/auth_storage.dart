import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// AuthStorage - Quản lý lưu trữ JWT tokens
///
/// Sử dụng flutter_secure_storage để lưu an toàn:
/// - Android: Encrypted SharedPreferences
///
/// Singleton pattern: Chỉ có 1 instance trong toàn app
class AuthStorage {
  // ===== SINGLETON PATTERN =====
  static final AuthStorage _instance = AuthStorage._internal();

  factory AuthStorage() => _instance;

  AuthStorage._internal();

  // ===== STORAGE INSTANCE =====
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions.biometric(
      enforceBiometrics: true
    ),

  );

  // ===== KEYS =====
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';

  // ==========================================
  // ACCESS TOKEN
  // ==========================================

  /// Lưu access token
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Đọc access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Xóa access token
  Future<void> deleteAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
  }

  // ==========================================
  // REFRESH TOKEN
  // ==========================================

  /// Lưu refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Đọc refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Xóa refresh token
  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
  }

  // ==========================================
  // USER INFO (Optional - để cache)
  // ==========================================

  /// Lưu user ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  /// Đọc user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// Lưu user email
  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _userEmailKey, value: email);
  }

  /// Đọc user email
  Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  // ==========================================
  // CONVENIENCE METHODS
  // ==========================================

  /// Lưu tất cả tokens sau khi login
  Future<void> saveAll({
    required String accessToken,
    required String refreshToken,
    String? userId,
    String? userEmail,
  }) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
    if (userId != null) await saveUserId(userId);
    if (userEmail != null) await saveUserEmail(userEmail);
  }

  /// Xóa tất cả data khi logout
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Kiểm tra đã login chưa (có token không)
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}