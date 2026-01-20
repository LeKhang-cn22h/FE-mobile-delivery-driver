import 'package:maplibre_gl/maplibre_gl.dart';
import '../models/snap_result.dart';

abstract class SnapService {
  Future<SnapResult?> snap(LatLng user);
}