import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  /// Login
  Future<UserModel> login(String email, String password) async {
    final response = await _authService.login(email, password);
    final user = UserModel.fromJson(response['user']);
    // TODO: Lưu token vào secure storage
    // await _secureStorage.write('access_token', response['access_token']);
    return user;
  }

  /// Register
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    final response = await _authService.register(
      fullName: fullName,
      email: email,
      password: password,
      phone: phone,
    );
    final user = UserModel.fromJson(response['user']);
    // TODO: Lưu token
    return user;
  }

  /// Logout
  Future<void> logout() async {
    // TODO: Lấy token từ storage và gọi API
    await _authService.logout('');
    // TODO: Xóa token khỏi storage
  }
}