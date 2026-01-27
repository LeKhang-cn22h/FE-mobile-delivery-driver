import 'package:maplibre_gl/maplibre_gl.dart';
import '../data/models/route_point.dart';

class MapUtils {
  /// ===============================
  /// USER MARKER STATE (ONLY THIS)
  /// ===============================
  static Symbol? _userSymbol;

  /// ===============================
  /// 1. DRAW / UPDATE ROUTE LINE
  /// (GIỮ LOGIC CŨ)
  /// ===============================
  static Future<Line?> drawRoute(
      MapLibreMapController controller,
      List<LatLng> points, {
        Line? oldLine,
      }) async {
    if (oldLine != null) {
      try {
        await controller.removeLine(oldLine);
      } catch (_) {}
    }

    if (points.isEmpty) return null;

    return controller.addLine(
      LineOptions(
        geometry: points,
        lineColor: "#1E90FF",
        lineWidth: 5,
        lineOpacity: 0.85,
        lineJoin: "round",
      ),
    );
  }

  /// ===============================
  /// 2. DRAW STOP MARKERS
  /// ===============================
  static Future<void> drawMarkers(
      MapLibreMapController controller,
      List<RoutePoint> points,
      ) async {
    if (points.isEmpty) return;
    await controller.clearCircles();

    for (final p in points) {
      await controller.addCircle(
        CircleOptions(
          geometry: LatLng(p.lat, p.lng),
          circleColor: "#FF3B30",
          circleRadius: 8,
          circleStrokeWidth: 2,
          circleStrokeColor: "#FFFFFF",
        ),
      );
    }
  }

  /// ===============================
  /// 3. USER MARKER (SNAP TARGET)
  /// ===============================
  static Future<void> drawOrUpdateUserMarker(
      MapLibreMapController controller,
      LatLng position,
      double heading,
      ) async {
    if (_userSymbol == null) {
      _userSymbol = await controller.addSymbol(
        SymbolOptions(
          geometry: position,
          iconImage: "user_marker",
          iconSize: 1.2,
          iconRotate: heading,
          iconAnchor: "center",
        ),
      );
    } else {
      await controller.updateSymbol(
        _userSymbol!,
        SymbolOptions(
          geometry: position,
          iconRotate: heading,
        ),
      );
    }
  }

  /// ===============================
  /// 4. CLEAR USER MARKER
  /// ===============================
  static Future<void> clearUserMarker(
      MapLibreMapController controller,
      ) async {
    if (_userSymbol != null) {
      try {
        await controller.removeSymbol(_userSymbol!);
      } catch (_) {}
      _userSymbol = null;
    }
  }

  /// ===============================
  /// 5. CLEAR MAP (KHÔNG PHÁ LOGIC)
  /// ===============================
  static Future<void> clearMap(
      MapLibreMapController controller,
      ) async {
    await clearUserMarker(controller);
    await controller.clearLines();
    await controller.clearCircles();
  }
}
