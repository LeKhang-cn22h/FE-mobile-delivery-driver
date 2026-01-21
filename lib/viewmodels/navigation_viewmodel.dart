import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../data/models/route_point.dart';
import '../data/services/osrm_service.dart';

class NavigationViewModel extends ChangeNotifier {
  /// ===============================
  /// NAVIGATION STATE
  /// ===============================
  bool _isNavigating = false;
  bool get isNavigating => _isNavigating;

  RoutePoint? _pendingPoint;
  RoutePoint? get pendingPoint => _pendingPoint;

  /// ===============================
  /// NAVIGATION INFO (UI)
  /// ===============================
  String currentInstruction = "Đang xác định hướng...";
  String remainingTime = "0 phút";
  String remainingDistance = "0 km";

  /// ===============================
  /// REROUTE COOLDOWN
  /// ===============================
  DateTime _lastRecalc = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _lastUpdate = DateTime.fromMillisecondsSinceEpoch(0);

  DateTime _lastNavUpdate = DateTime.fromMillisecondsSinceEpoch(0);

  bool get canUpdateNav =>
      DateTime.now().difference(_lastNavUpdate).inSeconds >= 2;

  void markNavUpdated() {
    _lastNavUpdate = DateTime.now();
  }
  bool get canUpdate =>
      DateTime.now().difference(_lastUpdate).inSeconds >= 3;


  bool get canRecalculate =>
      DateTime.now().difference(_lastRecalc).inSeconds >= 15;

  void markRecalculated() {
    _lastRecalc = DateTime.now();
  }

  /// ===============================
  /// NAVIGATION CONTROL
  /// ===============================
  void toggleNavigation() {
    _isNavigating = !_isNavigating;
    notifyListeners();
  }

  /// ===============================
  /// ARRIVAL STATE
  /// ===============================
  void setPendingPoint(RoutePoint point) {
    if (_pendingPoint?.id == point.id) return;
    _pendingPoint = point;
    notifyListeners();
  }

  void clearPending() {
    _pendingPoint = null;
    notifyListeners();
  }

  /// ===============================
  /// UPDATE NAVIGATION INSTRUCTION
  /// ===============================
  Future<void> updateNavigationData(
      LatLng currentPos,
      RoutePoint destination,
      ) async {
    if (!canUpdate) return;

    _lastUpdate = DateTime.now();

    final data = await OsrmService.navigationInfo(
      currentPos.latitude,
      currentPos.longitude,
      destination,
    );

    if (data.isNotEmpty) {
      currentInstruction = data['instruction'] ?? currentInstruction;
      remainingTime = data['time'] ?? remainingTime;
      remainingDistance = data['distance'] ?? remainingDistance;
      notifyListeners();
    }
  }
}