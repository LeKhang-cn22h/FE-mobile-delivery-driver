import 'package:maplibre_gl/maplibre_gl.dart';
import '../data/models/route_point.dart';

class MapUtils {
  /// 1. Vẽ hoặc cập nhật tuyến đường (Line)
  /// Trả về đối tượng Line để có thể xóa hoặc cập nhật ở frame sau
  static Future<Line?> drawRoute(
      MapLibreMapController controller,
      List<LatLng> points, {
        Line? oldLine,
      }) async {
    // Xóa đường cũ trước khi vẽ đường mới
    if (oldLine != null) {
      try {
        await controller.removeLine(oldLine);
      } catch (e) {
        // Tránh crash nếu line đã bị xóa trước đó
      }
    }

    if (points.isEmpty) return null;

    return await controller.addLine(
      LineOptions(
        geometry: points,
        lineColor: "#1E90FF", // Màu xanh dương (DodgerBlue)
        lineWidth: 5.0,
        lineOpacity: 0.8,
        lineJoin: "round", // Làm mượt các góc cua
      ),
    );
  }

  /// 2. Vẽ các Marker (điểm dừng) dưới dạng Circle
  /// Lưu ý: Sử dụng Circles để tối ưu hiệu năng hơn là Symbols khi số lượng điểm lớn
  static Future<void> drawMarkers(
      MapLibreMapController controller,
      List<RoutePoint> points,
      ) async {
    // Xóa toàn bộ các marker cũ
    await controller.clearCircles();

    if (points.isEmpty) return;

    for (var p in points) {
      await controller.addCircle(
        CircleOptions(
          geometry: LatLng(p.lat, p.lng),
          circleColor: "#FF0000", // Màu đỏ cho điểm dừng
          circleRadius: 8.0,
          circleStrokeWidth: 2.0,
          circleStrokeColor: "#FFFFFF", // Viền trắng cho dễ nhìn
        ),
      );
    }
  }

  /// 3. Clear toàn bộ bản đồ khi cần thiết
  static Future<void> clearMap(MapLibreMapController controller) async {
    await controller.clearLines();
    await controller.clearCircles();
    await controller.clearSymbols();
  }
}