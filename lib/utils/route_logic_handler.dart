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
}

//check bò lạc :)))