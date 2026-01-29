class RoutePoint {
  final String id;
  final String name;
  final double lat;
  final double lng;

  RoutePoint({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
  });

  factory RoutePoint.fromJson(Map<String, dynamic> json) {
    return RoutePoint(
      id: json['id'],
      name: json['name'],
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "lat": lat,
    "lng": lng,
  };
}