class AuthService {
  // final Dio _dio; // Uncomment khi có API thật

  AuthService();

  /// Login API
  Future<Map<String, dynamic>> login(String email, String password) async {
    // TODO: Thay bằng API thật
    // final response = await _dio.post('/auth/login', data: {
    //   'email': email,
    //   'password': password,
    // });
    // return response.data;

    await Future.delayed(const Duration(seconds: 2));

    // Giả lập lỗi
    if (email == 'error@test.com') {
      throw Exception('Email hoặc mật khẩu không đúng');
    }

    if (password.length < 6) {
      throw Exception('Mật khẩu phải có ít nhất 6 ký tự');
    }

    // Giả lập thành công
    return {
      'user': {
        'id': 'user_123',
        'email': email,
        'full_name': email.split('@')[0].toUpperCase(),
        'created_at': DateTime.now().toIso8601String(),
      },
      'access_token': 'fake_jwt_token_abc123',
      'refresh_token': 'fake_refresh_token_xyz789',
    };
  }

  /// Register API
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    // Giả lập email đã tồn tại
    if (email == 'exists@test.com') {
      throw Exception('Email đã được sử dụng');
    }

    return {
      'user': {
        'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
        'email': email,
        'full_name': fullName,
        'phone': phone,
        'created_at': DateTime.now().toIso8601String(),
      },
      'access_token': 'fake_jwt_token_new',
      'refresh_token': 'fake_refresh_token_new',
    };
  }

  /// Logout API
  Future<void> logout(String token) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Revoke token on server
  }
}