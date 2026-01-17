import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location_point.dart';

class GeocodingService {
  Future<LocationPoint> geocode(String address) async {
    final url =
        'https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=1';

    final res = await http.get(Uri.parse(url), headers: {
      "User-Agent": "flutter-app"
    });

    final data = jsonDecode(res.body);
    return LocationPoint(
      double.parse(data[0]['lat']),
      double.parse(data[0]['lon']),
    );
  }
}
//OSM – Nominatim