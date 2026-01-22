/// ApiConfig - Cấu hình API (base URL, headers, timeout)
/// Singleton pattern
class ApiConfig {
  static final ApiConfig _instance= ApiConfig._internal();
  factory ApiConfig() => _instance;
  ApiConfig._internal();

  static const String _realDeviceUrl = 'http://192.168.1.161:8000';

  static const String baseUrl= _realDeviceUrl;

  Duration get connectTimeout => const Duration(seconds: 30);
  Duration get receiveTimeout => const Duration(seconds: 30);

  Map<String, String> get defaultHeaders =>{
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  String fullUrl(String endpoint) => '$baseUrl$endpoint';
}