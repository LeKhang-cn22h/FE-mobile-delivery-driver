import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class LocationViewModel extends ChangeNotifier {
  /// ===============================
  /// INTERNAL STATE
  /// ===============================

  LatLng? _rawPosition;
  LatLng? _snappedPosition;

  LatLng? get rawPosition => _rawPosition;
  LatLng? get snappedPosition => _snappedPosition;


  double _heading = 0;
  StreamSubscription<Position>? _sub;

  /// ===============================
  /// PUBLIC API (GIỮ NGUYÊN)
  /// ===============================

  LatLng? get currentPosition =>
      _snappedPosition ?? _rawPosition;

  double get heading => _heading;

  bool get isSnapped => _snappedPosition != null;

  /// ===============================
  /// LOCATION STREAM
  /// ===============================
  Future<void> initLocation() async {
    final serviceEnabled =
    await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) return;

    _sub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 1,
      ),
    ).listen((pos) {
      _rawPosition = LatLng(pos.latitude, pos.longitude);
      _heading = pos.heading;

      // Luôn thông báo để bản đồ vẽ lại vị trí mới
      notifyListeners();
    });
  }

  /// ===============================
  /// SNAP CONTROL
  /// ===============================

  void setSnappedPosition(LatLng position) {
    _snappedPosition = position;
    notifyListeners();
  }

  void clearSnap() {
    _snappedPosition = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

}