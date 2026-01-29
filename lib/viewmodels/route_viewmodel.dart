import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import '../data/models/route_point.dart';
import '../data/services/osrm_service.dart';
import '../data/repositories/route_repository.dart';

class RouteViewModel extends ChangeNotifier {
  // Lấy thực thể OsrmService để sử dụng các hàm static hoặc instance
  // Theo code bạn cung cấp, OsrmService có các hàm static nên ta gọi trực tiếp qua tên lớp
  bool _shouldRedrawMarkers = true;
  bool get shouldRedrawMarkers => _shouldRedrawMarkers;

  double totalDistanceKm = 0;
  String totalDistanceText = "0 km";

  List<LatLng> routeLine = [];
  List<RoutePoint> sortedPoints = [];
  bool _isCalculating = false;

  // Dữ liệu hiển thị trên bảng điều hướng (Top & Bottom Panel)


  bool get isCalculating => _isCalculating;

  void markMarkersDrawn() {
    _shouldRedrawMarkers = false;
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
        sortedPoints = await repo.fetchTodayPoints();
      }

      // Gọi API lấy tọa độ đường đi để vẽ lên bản đồ
      final result = await OsrmService.routeWithInfo(
        userPos.latitude,
        userPos.longitude,
        sortedPoints,
      );

      routeLine = result.geometry;
      totalDistanceKm = result.distanceMeters / 1000;
      totalDistanceText = "${totalDistanceKm.toStringAsFixed(1)} km";

      _shouldRedrawMarkers = true;
    } catch (e) {
      debugPrint("Lỗi khi tính toán lộ trình: $e");
    } finally {
      _isCalculating = false;
      notifyListeners();
    }
  }

  /// 3. Xóa điểm khi hoàn thành và cập nhật lại lộ trình
  void removePoint(String pointId, LatLng userPos) {
    sortedPoints.removeWhere((p) => p.id == pointId);

    _shouldRedrawMarkers = true;

    calculateTodayRoute(userPos);
    notifyListeners();
  }


  void setRoute(List<LatLng> newRoute) {
    routeLine = newRoute;
    _shouldRedrawMarkers = true;
    notifyListeners();
  }
}