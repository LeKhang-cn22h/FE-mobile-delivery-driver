import 'package:maplibre_gl/maplibre_gl.dart';
import '../data/models/route_point.dart';
import 'geo_utils.dart';
import 'geo_utils.dart' as GeoUtils;

class RouteLogicHandler {
  /// 1. Kiểm tra xem User có đang ở gần bất kỳ điểm dừng nào không
  /// Trả về RoutePoint nếu User nằm trong bán kính [radiusMetres]
  static RoutePoint? checkArrival(
      LatLng userPos,
      List<RoutePoint> targetPoints,
      {double radiusMetres = 50.0}
      ) {
    for (var point in targetPoints) {
      double distance = GeoUtils.haversine(
          userPos.latitude,
          userPos.longitude,
          point.lat,
          point.lng
      );

      if (distance <= radiusMetres) {
        return point;
      }
    }
    return null;
  }

  /// 2. Cắt bớt đoạn đường màu xanh đã đi qua
  /// Tìm điểm gần nhất trên routeLine và trả về mảng tọa độ từ đó đến cuối
  static List<LatLng> trimPassedRoute(List<LatLng> route, LatLng userPos) {
    if (route.isEmpty) return [];

    int closestIdx = 0;
    double minDistance = double.maxFinite;

    for (int i = 0; i < route.length; i++) {
      double d = GeoUtils.haversine(
          userPos.latitude,
          userPos.longitude,
          route[i].latitude,
          route[i].longitude
      );

      if (d < minDistance) {
        minDistance = d;
        closestIdx = i;
      }
    }

    // Trả về danh sách từ điểm gần nhất trở đi
    return route.sublist(closestIdx);
  }

  /// 3. Kiểm tra xem User có đi chệch khỏi đường xanh quá xa không (Rerouting logic)
  /// Trả về true nếu khoảng cách từ User tới điểm gần nhất trên lộ trình > [threshold]
  static bool isUserOffRoute(
      LatLng userPos,
      List<LatLng> route,
      {double threshold = 50.0}
      ) {
    if (route.isEmpty) return false;

    double minDistance = double.maxFinite;

    for (var point in route) {
      double d = GeoUtils.haversine(
          userPos.latitude,
          userPos.longitude,
          point.latitude,
          point.longitude
      );
      if (d < minDistance) {
        minDistance = d;
      }
    }

    // Nếu khoảng cách gần nhất đến đường > threshold thì coi là đi lạc
    return minDistance > threshold;
  }

  /// 4. Sắp xếp các điểm dừng theo khoảng cách thực tế (nếu cần tính toán nhanh ở Client)
  /// Lưu ý: Nên dùng OsrmService.table để có kết quả chính xác theo đường đi thực tế.
  static List<RoutePoint> sortPointsByProximity(LatLng startPos, List<RoutePoint> points) {
    List<RoutePoint> sorted = List.from(points);
    sorted.sort((a, b) {
      double distA = GeoUtils.haversine(startPos.latitude, startPos.longitude, a.lat, a.lng);
      double distB = GeoUtils.haversine(startPos.latitude, startPos.longitude, b.lat, b.lng);
      return distA.compareTo(distB);
    });
    return sorted;
  }

  /// 5. Kiểm tra user có ở GẦN route không (dùng cho SNAP)
  /// Đo khoảng cách từ user tới từng ĐOẠN route
  static bool isNearRoute(
      LatLng userPos,
      List<LatLng> route, {
        double thresholdMeters = 25.0,
      }) {
    if (route.length < 2) return false;

    for (int i = 0; i < route.length - 1; i++) {
      final a = route[i];
      final b = route[i + 1];

      final distance = _distancePointToSegment(
        userPos,
        a,
        b,
      );

      if (distance <= thresholdMeters) {
        return true;
      }
    }
    return false;
  }
  /// Khoảng cách từ điểm P tới đoạn AB (đơn vị: mét)
  static double _distancePointToSegment(
      LatLng p,
      LatLng a,
      LatLng b,
      ) {
    // Chuyển lat/lng sang hệ phẳng x/y (đủ chính xác ở scale nhỏ)
    final ax = a.longitude;
    final ay = a.latitude;
    final bx = b.longitude;
    final by = b.latitude;
    final px = p.longitude;
    final py = p.latitude;

    final dx = bx - ax;
    final dy = by - ay;

    if (dx == 0 && dy == 0) {
      return GeoUtils.haversine(py, px, ay, ax);
    }

    final t = ((px - ax) * dx + (py - ay) * dy) / (dx * dx + dy * dy);
    final clampedT = t.clamp(0.0, 1.0);

    final projX = ax + clampedT * dx;
    final projY = ay + clampedT * dy;

    return GeoUtils.haversine(
      py,
      px,
      projY,
      projX,
    );
  }
}

//check bò lạc :)))