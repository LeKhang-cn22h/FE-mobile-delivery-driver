import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class LocationViewModel extends ChangeNotifier {
  LatLng? _currentPosition;
  double _heading = 0;
  StreamSubscription<Position>? _sub;

  LatLng? get currentPosition => _currentPosition;
  double get heading => _heading;

  Future<void> initLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) return;

    // Cấu hình tối ưu cho Navigation: Accuracy Best và DistanceFilter nhỏ
    _sub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 1, // Cập nhật mỗi 1 mét để xoay mượt
      ),
    ).listen((pos) {
      _currentPosition = LatLng(pos.latitude, pos.longitude);
      _heading = pos.heading; // Lấy hướng thực tế từ GPS
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}