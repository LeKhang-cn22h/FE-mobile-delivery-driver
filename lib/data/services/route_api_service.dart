import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/route_point.dart';

class RoutingApi {
  static const String baseUrl = 'http://api-gateway:8386';

  static Future<List<RoutePoint>> fetchTodayPoints() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/v1/routing/today-points'),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load route points');
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => RoutePoint.fromJson(e)).toList();
  }

  static Future<dynamic> optimizeRoute({
    required List<RoutePoint> points,
    int startIndex = 0,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/v1/routing/optimize'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "locations": points.map((p) => {
          "lat": p.lat,
          "lng": p.lng,
          "name": p.name,
        }).toList(),
        "start_index": startIndex,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('Optimize failed');
    }

    return jsonDecode(res.body);
  }
}