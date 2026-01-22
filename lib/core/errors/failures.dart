/// Base Failure class - Handle errors thống nhất
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

/// Lỗi từ server
class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
}

/// Lỗi mạng
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Không có kết nối mạng']);
}

/// Lỗi authentication
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Phiên đăng nhập hết hạn']);
}