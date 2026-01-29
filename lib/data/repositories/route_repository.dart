import '../models/route_point.dart';
import '../services/route_api_service.dart';

class RouteRepository {

  /// LẤY DATA TỪ BACKEND
  Future<List<RoutePoint>> fetchTodayPoints() {
    return RoutingApi.fetchTodayPoints();
  }

  /// GỬI DATA LÊN BACKEND
  Future<dynamic> optimizeRoute({
    required List<RoutePoint> points,
    int startIndex = 0,
  }) {
    return RoutingApi.optimizeRoute(
      points: points,
      startIndex: startIndex,
    );
  }
}