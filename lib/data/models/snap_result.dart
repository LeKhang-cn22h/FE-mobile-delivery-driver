import 'package:maplibre_gl/maplibre_gl.dart';

class SnapResult {
  final LatLng position;
  final double confidence;

  SnapResult({
    required this.position,
    required this.confidence,
  });
}