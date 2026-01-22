import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_endpoints.dart';
import '../storage/auth_storage.dart';

/// ApiResponse - Wrapper cho response từ API
class ApiResponse<T> {
  final bool success;
  final int statusCode;
  final T? data;
  final String? message;

  ApiResponse({
    required this.success,
    required this.statusCode,
    this.data,
    this.message,
  });

  @override
  String toString() {
    return 'ApiResponse(success: $success, statusCode: $statusCode, message: $message)';
  }
}

/// ApiService - HTTP Client với auto Bearer token
///
/// Features:
/// - Tự động gắn Authorization header từ AuthStorage
/// - Xử lý errors thống nhất
/// - Logging cho debug
///
/// Sử dụng:
///   final api = ApiService();
///   final response = await api.get(ApiEndpoints.me);
class ApiService {
  // ===== SINGLETON =====
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // ===== DEPENDENCIES =====
  final ApiConfig _config = ApiConfig();
  final AuthStorage _authStorage = AuthStorage();
  final http.Client _client = http.Client();

  // ===== DEBUG MODE =====
  final bool _enableLogging = true;

  // ==========================================
  // PUBLIC METHODS
  // ==========================================

  /// GET request
  ///
  /// [endpoint] - Path từ ApiEndpoints (vd: ApiEndpoints.me)
  /// [requireAuth] - Có cần gắn Bearer token không (default: true)
  /// [queryParams] - Query parameters (vd: {'page': '1'})
  Future<ApiResponse<Map<String, dynamic>>> get(
      String endpoint, {
        bool requireAuth = true,
        Map<String, String>? queryParams,
      }) async {
    return _request(
      method: 'GET',
      endpoint: endpoint,
      requireAuth: requireAuth,
      queryParams: queryParams,
    );
  }

  /// POST request
  ///
  /// [endpoint] - Path từ ApiEndpoints
  /// [body] - Request body (Map sẽ được convert sang JSON)
  /// [requireAuth] - Có cần gắn Bearer token không
  Future<ApiResponse<Map<String, dynamic>>> post(
      String endpoint, {
        Map<String, dynamic>? body,
        bool requireAuth = true,
      }) async {
    return _request(
      method: 'POST',
      endpoint: endpoint,
      body: body,
      requireAuth: requireAuth,
    );
  }

  /// PATCH request
  Future<ApiResponse<Map<String, dynamic>>> patch(
      String endpoint, {
        Map<String, dynamic>? body,
        bool requireAuth = true,
      }) async {
    return _request(
      method: 'PATCH',
      endpoint: endpoint,
      body: body,
      requireAuth: requireAuth,
    );
  }

  /// PUT request
  Future<ApiResponse<Map<String, dynamic>>> put(
      String endpoint, {
        Map<String, dynamic>? body,
        bool requireAuth = true,
      }) async {
    return _request(
      method: 'PUT',
      endpoint: endpoint,
      body: body,
      requireAuth: requireAuth,
    );
  }

  /// DELETE request
  Future<ApiResponse<Map<String, dynamic>>> delete(
      String endpoint, {
        bool requireAuth = true,
      }) async {
    return _request(
      method: 'DELETE',
      endpoint: endpoint,
      requireAuth: requireAuth,
    );
  }

  // ==========================================
  // PRIVATE: Core request handler
  // ==========================================

  Future<ApiResponse<Map<String, dynamic>>> _request({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
    bool requireAuth = true,
    Map<String, String>? queryParams,
  }) async {
    try {
      // 1. Build URL
      var url = _config.fullUrl(endpoint);
      if (queryParams != null && queryParams.isNotEmpty) {
        final queryString = Uri(queryParameters: queryParams).query;
        url = '$url?$queryString';
      }
      final uri = Uri.parse(url);

      // 2. Build headers
      final headers = await _buildHeaders(requireAuth);

      // 3. Log request
      _log('→ $method $url');
      if (body != null) _log('→ Body: ${json.encode(body)}');

      // 4. Execute request
      http.Response response;

      switch (method) {
        case 'GET':
          response = await _client.get(uri, headers: headers);
          break;
        case 'POST':
          response = await _client.post(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'PATCH':
          response = await _client.patch(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'PUT':
          response = await _client.put(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'DELETE':
          response = await _client.delete(uri, headers: headers);
          break;
        default:
          throw Exception('Unsupported method: $method');
      }

      // 5. Log response
      _log('← Status: ${response.statusCode}');
      _log('← Body: ${response.body}');

      // 6. Parse & return
      return _parseResponse(response);

    } on SocketException {
      _log('✗ Network Error: No internet connection');
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'Không có kết nối mạng. Vui lòng kiểm tra lại.',
      );
    } on HttpException catch (e) {
      _log('✗ HTTP Error: $e');
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'Lỗi kết nối đến server.',
      );
    } catch (e) {
      _log('✗ Error: $e');
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'Đã xảy ra lỗi: $e',
      );
    }
  }

  // ==========================================
  // PRIVATE: Build headers với Bearer token
  // ==========================================

  Future<Map<String, String>> _buildHeaders(bool requireAuth) async {
    final headers = Map<String, String>.from(_config.defaultHeaders);

    if (requireAuth) {
      final token = await _authStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // ==========================================
  // PRIVATE: Parse response
  // ==========================================

  ApiResponse<Map<String, dynamic>> _parseResponse(http.Response response) {
    final statusCode = response.statusCode;
    Map<String, dynamic>? data;
    String? message;

    // Try parse JSON body
    try {
      if (response.body.isNotEmpty) {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          data = decoded;
        }
      }
    } catch (_) {
      // Body không phải JSON
    }

    // Check success
    final isSuccess = statusCode >= 200 && statusCode < 300;

    // Extract error message nếu failed
    if (!isSuccess) {
      message = _extractErrorMessage(data, statusCode);
    }

    return ApiResponse(
      success: isSuccess,
      statusCode: statusCode,
      data: data,
      message: message,
    );
  }

  // ==========================================
  // PRIVATE: Extract error message
  // ==========================================

  String _extractErrorMessage(Map<String, dynamic>? data, int statusCode) {
    if (data != null) {
      // {"detail": "message"}
      if (data['detail'] is String) {
        return data['detail'];
      }
      // {"detail": {"detail": "message"}}
      if (data['detail'] is Map) {
        return data['detail']['detail'] ?? 'Lỗi không xác định';
      }
      // {"message": "..."}
      if (data['message'] is String) {
        return data['message'];
      }
      // {"error": "..."}
      if (data['error'] is String) {
        return data['error'];
      }
    }

    // Default messages
    switch (statusCode) {
      case 400:
        return 'Dữ liệu không hợp lệ';
      case 401:
        return 'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.';
      case 403:
        return 'Bạn không có quyền truy cập';
      case 404:
        return 'Không tìm thấy dữ liệu';
      case 422:
        return 'Dữ liệu không hợp lệ';
      case 500:
        return 'Lỗi server. Vui lòng thử lại sau.';
      default:
        return 'Đã xảy ra lỗi ($statusCode)';
    }
  }

  // ==========================================
  // PRIVATE: Logging
  // ==========================================

  void _log(String message) {
    if (_enableLogging) {
      print('[ApiService] $message');
    }
  }
}