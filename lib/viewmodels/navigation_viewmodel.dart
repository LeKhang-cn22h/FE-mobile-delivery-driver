import 'package:flutter/material.dart';
import '../data/models/route_point.dart';

class NavigationViewModel extends ChangeNotifier {
  RoutePoint? _pendingPoint;
  bool _isNavigating = false;

  RoutePoint? get pendingPoint => _pendingPoint;
  bool get isNavigating => _isNavigating;

  void setPendingPoint(RoutePoint point) {
    if (_pendingPoint?.id == point.id) return;
    _pendingPoint = point;
    notifyListeners();
  }

  void clearPending() {
    _pendingPoint = null;
    notifyListeners();
  }

  void toggleNavigation() {
    _isNavigating = !_isNavigating;
    notifyListeners();
  }
}