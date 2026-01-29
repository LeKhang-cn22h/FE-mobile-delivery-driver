class OptimizedRoutePoint {
  final int order;
  final double lat;
  final double lng;
  final String name;

  OptimizedRoutePoint({
    required this.order,
    required this.lat,
    required this.lng,
    required this.name,
  });

  factory OptimizedRoutePoint.fromJson(Map<String, dynamic> json) {
    return OptimizedRoutePoint(
      order: json['order'],
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      name: json['name'],
    );
  }
}