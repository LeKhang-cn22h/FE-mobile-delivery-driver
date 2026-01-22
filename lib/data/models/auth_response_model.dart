import 'package:test_f/data/models/user_model.dart';
/// AuthResponseModel - Response từ API login/register
///
/// JSON format:
/// {
///   "access_token": "eyJ...",
///   "refresh_token": "...",
///   "token_type": "bearer",
///   "expires_in": 3600,
///   "user": { ... }
/// }
class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int? expiresIn;
  final UserModel user;

  const AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    this.expiresIn,
    required this.user,
  });

  /// Parse JSON → AuthResponseModel
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      tokenType: json['token_type'] ?? 'bearer',
      expiresIn: json['expires_in'],
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}