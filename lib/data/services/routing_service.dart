import 'dart:convert';
import 'package:http/http.dart' as http;

class RoutingService {
  Future<List<List<double>>> getRoute(List<List<double>> points) async {
    final coords = points.map((p) => "${p[1]},${p[0]}").join(";");

    final url =
        "http://router.project-osrm.org/route/v1/driving/$coords?overview=full&geometries=geojson";

    final res = await http.get(Uri.parse(url));
    final data = jsonDecode(res.body);

    return List<List<double>>.from(
        data['routes'][0]['geometry']['coordinates']);
  }
}
//OSRM