import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import '../data/models/route_point.dart';
import '../data/services/osrm_service.dart';
import '../data/repositories/route_repository.dart';

class RouteViewModel extends ChangeNotifier {
  // Lấy thực thể OsrmService để sử dụng các hàm static hoặc instance
  // Theo code bạn cung cấp, OsrmService có các hàm static nên ta gọi trực tiếp qua tên lớp

  List<LatLng> routeLine = [];
  List<RoutePoint> sortedPoints = [];
  bool _isCalculating = false;

  // Dữ liệu hiển thị trên bảng điều hướng (Top & Bottom Panel)
  String currentInstruction = "Đang xác định hướng...";
  String remainingTime = "0 phút";
  String remainingDistance = "0 km";

  bool get isCalculating => _isCalculating;

  /// 1. Logic lấy chỉ dẫn bằng chữ (Dùng khi đang di chuyển)
  Future<void> updateNavigationData(LatLng currentPos) async {
    if (sortedPoints.isEmpty) return;

    // Lấy điểm đến gần nhất (điểm đầu tiên trong danh sách đã sắp xếp)
    final destination = sortedPoints.first;

    // Gọi hàm chuyên biệt để lấy steps/instruction từ OsrmService
    // Sử dụng logic gọi API có steps=true và language=vi
    final data = await OsrmService.navigationInfo(
        currentPos.latitude,
        currentPos.longitude,
        destination
    );

    if (data.isNotEmpty) {
      currentInstruction = data['instruction'] ?? "Đi thẳng";
      remainingTime = data['time'] ?? "0 phút";
      remainingDistance = data['distance'] ?? "0 km";

      notifyListeners();
    }
  }

  /// 2. Logic tính toán toàn bộ lộ trình (Vẽ đường Polyline xanh)
  Future<void> calculateTodayRoute(LatLng userPos) async {
    if (_isCalculating) return;

    _isCalculating = true;
    notifyListeners();

    try {
      // Nạp điểm dừng từ Repository nếu danh sách trống
      if (sortedPoints.isEmpty) {
        final repo = RouteRepository();
        sortedPoints = await repo.todayPoints();
      }

      // Gọi API lấy tọa độ đường đi để vẽ lên bản đồ
      final result = await OsrmService.route(
        userPos.latitude,
        userPos.longitude,
        sortedPoints,
      );

      routeLine = result;
    } catch (e) {
      debugPrint("Lỗi khi tính toán lộ trình: $e");
    } finally {
      _isCalculating = false;
      notifyListeners();
    }
  }

  /// 3. Xóa điểm khi hoàn thành và cập nhật lại lộ trình
  void removePoint(String id, LatLng currentUserPos) {
    sortedPoints.removeWhere((p) => p.id == id);
    // Tính lại đường đi sau khi đã bớt một điểm dừng
    calculateTodayRoute(currentUserPos);
  }
}