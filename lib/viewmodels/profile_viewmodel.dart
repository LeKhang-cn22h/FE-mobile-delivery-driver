import 'package:flutter/foundation.dart';

import '../core/storage/auth_storage.dart';
import '../data/models/user_model.dart';
import '../data/services/user_service.dart';

/// Trạng thái của Profile
enum ProfileState {
  initial,    // Chưa làm gì
  loading,    // Đang tải
  loaded,     // Tải xong
  updating,   // Đang cập nhật
  error,      // Có lỗi
}

/// ProfileViewModel - Quản lý state cho ProfilePage
///
/// Nhiệm vụ:
/// - Gọi UserService
/// - Quản lý loading/error states
/// - Notify UI khi data thay đổi
class ProfileViewModel extends ChangeNotifier {
  // ===== DEPENDENCIES =====
  final UserService _userService;
  final AuthStorage _authStorage;

  ProfileViewModel({
    UserService? userService,
    AuthStorage? authStorage,
  })  : _userService = userService ?? UserService(),
        _authStorage = authStorage ?? AuthStorage();

  // ===== STATE =====
  ProfileState _state = ProfileState.initial;
  UserModel? _user;
  String? _errorMessage;

  // ===== GETTERS =====
  ProfileState get state => _state;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;

  /// Kiểm tra đang loading không
  bool get isLoading => _state == ProfileState.loading;

  /// Kiểm tra đang updating không
  bool get isUpdating => _state == ProfileState.updating;

  /// Kiểm tra có lỗi không
  bool get hasError => _state == ProfileState.error;

  /// Kiểm tra có user data không
  bool get hasUser => _user != null;

  // ==========================================
  // LẤY THÔNG TIN USER
  // ==========================================

  /// Load thông tin user hiện tại
  Future<void> loadCurrentUser() async {
    // Set loading state
    _state = ProfileState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Gọi service
      _user = await _userService.getCurrentUser();
      _state = ProfileState.loaded;
    } catch (e) {
      _state = ProfileState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }

    notifyListeners();
  }

  // ==========================================
  // CẬP NHẬT PROFILE
  // ==========================================

  /// Cập nhật thông tin profile
  Future<bool> updateProfile({
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    // Set updating state
    _state = ProfileState.updating;
    _errorMessage = null;
    notifyListeners();

    try {
      // Gọi service (đã có validation trong service)
      _user = await _userService.updateProfile(
        fullName: fullName,
        phone: phone,
        avatarUrl: avatarUrl,
      );

      _state = ProfileState.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _state = ProfileState.loaded; // Quay lại loaded, không phải error
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // ==========================================
  // ĐỔI MẬT KHẨU
  // ==========================================

  /// Đổi mật khẩu
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _state = ProfileState.updating;
    _errorMessage = null;
    notifyListeners();

    try {
      await _userService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      _state = ProfileState.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _state = ProfileState.loaded;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // ==========================================
  // LOGOUT
  // ==========================================

  /// Đăng xuất - xóa tokens
  Future<void> logout() async {
    await _authStorage.clearAll();
    _user = null;
    _state = ProfileState.initial;
    notifyListeners();
  }

  // ==========================================
  // HELPER METHODS
  // ==========================================

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset về trạng thái ban đầu
  void reset() {
    _state = ProfileState.initial;
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }
}