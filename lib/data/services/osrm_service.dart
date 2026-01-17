import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maplibre_gl/maplibre_gl.dart';
import '../models/route_point.dart';

class OsrmService {
  static const _base = "https://router.project-osrm.org";

  static Future<List<double>> table(
      double fromLat,
      double fromLng,
      List<RoutePoint> points,
      ) async {
    final coords = [
      "$fromLng,$fromLat",
      ...points.map((p) => "${p.lng},${p.lat}")
    ].join(";");

    final url = Uri.parse(
      "$_base/table/v1/driving/$coords?sources=0&annotations=distance",
    );


    final res = await http.get(url);
    final json = jsonDecode(res.body);

    /// distances[0] = từ user → các điểm
    final List<dynamic> row = json['distances'][0];

    /// bỏ phần tử đầu (0 → chính nó)
    return row
        .skip(1)
        .map((d) => (d as num).toDouble())
        .toList();
  }

  static Future<List<LatLng>> route(
      double fromLat,
      double fromLng,
      List<RoutePoint> points,
      ) async {
    final coords = [
      "$fromLng,$fromLat",
      ...points.map((p) => "${p.lng},${p.lat}")
    ].join(";");

    final url = Uri.parse(
      "$_base/route/v1/driving/$coords"
          "?overview=full&geometries=geojson",
    );

    final res = await http.get(url);
    final json = jsonDecode(res.body);

    final List<dynamic> coordinates =
    json['routes'][0]['geometry']['coordinates'];

    return coordinates.map<LatLng>((c) {
      final lon = (c[0] as num).toDouble();
      final lat = (c[1] as num).toDouble();
      return LatLng(lat, lon);
    }).toList();
  }

  static Future<Map<String, dynamic>> navigationInfo(
      double fromLat,
      double fromLng,
      RoutePoint destination,
      ) async {
    final coords = "$fromLng,$fromLat;${destination.lng},${destination.lat}";

    // Thêm các tham số: steps=true (lấy các bước), language=vi (tiếng Việt)
    final url = Uri.parse(
      "$_base/route/v1/driving/$coords?steps=true&overview=full&language=vi",
    );

    final res = await http.get(url);
    final data = jsonDecode(res.body);

    if (data['routes'] == null || (data['routes'] as List).isEmpty) {
      return {"instruction": "Đi về hướng điểm đến", "time": "0 phút", "distance": "0 km"};
    }

    final route = data['routes'][0];
    final leg = route['legs'][0];

    // Lấy chỉ dẫn của bước đầu tiên sắp tới
    String instruction = "Đi thẳng";
    if (leg['steps'] != null && (leg['steps'] as List).isNotEmpty) {
      instruction = leg['steps'][0]['maneuver']['instruction'];
    }

    return {
      "instruction": instruction,
      "time": "${(route['duration'] / 60).toStringAsFixed(0)} phút",
      "distance": "${(route['distance'] / 1000).toStringAsFixed(1)} km",
    };
  }
}
