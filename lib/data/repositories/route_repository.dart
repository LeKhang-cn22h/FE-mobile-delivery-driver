import '../models/route_point.dart';

class RouteRepository {
  List<RoutePoint> todayPoints() {
    return [
      RoutePoint(id: '1', name: 'Bến Thành', lat: 10.772, lng: 106.698),
      RoutePoint(id: '2', name: 'Thảo Cầm Viên', lat: 10.787, lng: 106.705),
      RoutePoint(id: '3', name: 'Nhà Thờ Đức Bà', lat: 10.779, lng: 106.699),
      RoutePoint(id: '4', name: 'Landmark 81', lat: 10.794, lng: 106.721),
    ];
  }
}
//mock