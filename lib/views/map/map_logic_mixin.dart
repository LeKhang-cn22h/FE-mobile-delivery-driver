import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:provider/provider.dart';

import '../../data/services/osrm_service.dart';
import '../../viewmodels/location_viewmodel.dart';
import '../../viewmodels/route_viewmodel.dart';
import '../../viewmodels/navigation_viewmodel.dart';
import '../../utils/map_utils.dart';
import '../../utils/route_logic_handler.dart';

mixin MapLogicMixin<T extends StatefulWidget> on State<T> {
  /// ===============================
  /// MAP STATE
  /// ===============================
  bool _isUpdatingMap = false;
  MapLibreMapController? controller;
  Line? routeLine;

  bool _isInsetApplied = false;
  bool isCameraFollowingUser = false;



  bool movedOnce = false;
  bool isDialogShowing = false;

  /// ===============================
  /// SNAP (LVL2)
  /// ===============================
  final OsrmService _osrmService = OsrmService();
  DateTime _lastSnapTime = DateTime.fromMillisecondsSinceEpoch(0);

  bool get _canSnap =>
      DateTime.now().difference(_lastSnapTime).inSeconds >= 3;

  /// ===============================
  /// MAIN MAP UPDATE LOOP
  /// ===============================

  Future<void> _handleSnap(
      LocationViewModel locationVM,
      RouteViewModel routeVM,
      NavigationViewModel navVM,
      ) async {
    final rawPos = locationVM.rawPosition;
    if (rawPos == null) return;

    if (!navVM.isNavigating || !_canSnap) return;

    final isOffRoute = RouteLogicHandler.isUserOffRoute(
      rawPos,
      routeVM.routeLine,
      threshold: 25,
    );

    if (isOffRoute) return;

    final snapped = await _osrmService.snapUserToRoad(rawPos);
    if (snapped != null) {
      locationVM.setSnappedPosition(snapped);
      _lastSnapTime = DateTime.now();
    }
  }

  void _handleCamera(
      LatLng userPos,
      LocationViewModel locationVM,
      NavigationViewModel navVM,
      ) {
    final map = controller;
    if (map == null) return;

    // 🚨 NAV MODE → BẮT BUỘC FOLLOW
    if (navVM.isNavigating) {
      isCameraFollowingUser = true;
    }

    // ❌ Không follow → không đụng camera
    if (!isCameraFollowingUser) return;

    if (navVM.isNavigating) {
      // Apply inset MỘT LẦN
      if (!_isInsetApplied) {
        controller!.updateContentInsets(
          const EdgeInsets.only(bottom: 220),
        );
        _isInsetApplied = true;
      }

      controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: userPos,
            zoom: 18,
            tilt: 60,
            bearing: locationVM.heading,
          ),
        ),
      );
    } else {
      // NORMAL MODE (focus user do bấm nút)
      if (_isInsetApplied) {
        controller!.updateContentInsets(EdgeInsets.zero);
        _isInsetApplied = false;
      }

      controller!.animateCamera(
        CameraUpdate.newLatLngZoom(
          userPos,
          16,
        ),
      );
    }
  }
  void resetCameraToDefault(LatLng userPos) {
    // 🔄 Thoát nav → KHÔNG FOLLOW
    isCameraFollowingUser = false;
    _isInsetApplied = false;

    controller?.updateContentInsets(EdgeInsets.zero);

    controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: userPos,
          zoom: 16,
          bearing: 0,
          tilt: 0,
        ),
      ),
    );
  }

  Future<void> _handleRouteLogic(
      LatLng userPos,
      RouteViewModel routeVM,
      NavigationViewModel navVM,
      ) async {
    if (routeVM.routeLine.isEmpty) return;

    final isOffRoute = RouteLogicHandler.isUserOffRoute(
      userPos,
      routeVM.routeLine,
    );

    if (isOffRoute &&
        navVM.canRecalculate &&
        !routeVM.isCalculating) {
      navVM.markRecalculated();
      await routeVM.calculateTodayRoute(userPos);
      return;
    }

    final effectiveRoute = navVM.isNavigating
        ? RouteLogicHandler.trimPassedRoute(
      routeVM.routeLine,
      userPos,
    )
        : routeVM.routeLine;

    if (effectiveRoute.length < 2) return;

    routeLine = await MapUtils.drawRoute(
      controller!,
      effectiveRoute,
      oldLine: routeLine,
    );
  }

  Future<void> _handleMarkers(
      LatLng userPos,
      LocationViewModel locationVM,
      RouteViewModel routeVM,
      ) async {
    await MapUtils.drawOrUpdateUserMarker(
      controller!,
      userPos,
      locationVM.heading,
    );

    if (routeVM.shouldRedrawMarkers) {
      await MapUtils.drawMarkers(
        controller!,
        routeVM.sortedPoints,
      );
      routeVM.markMarkersDrawn();
    }
  }

  Future<void> handleMapUpdate() async {
    if (_isUpdatingMap) return;
    _isUpdatingMap = true;

    try {
      if (controller == null) return;

      final locationVM = context.read<LocationViewModel>();
      final routeVM = context.read<RouteViewModel>();
      final navVM = context.read<NavigationViewModel>();

      await _handleSnap(locationVM, routeVM, navVM);

      final rawPos = locationVM.rawPosition;
      if (rawPos == null) return;

// vị trí dùng để vẽ
      final renderPos =
          locationVM.snappedPosition ?? rawPos;

// ====== NAVIGATION INFO (RAW GPS) ======
      if (navVM.isNavigating &&
          routeVM.sortedPoints.isNotEmpty &&
          navVM.canUpdateNav) {
        await navVM.updateNavigationData(
          rawPos,
          routeVM.sortedPoints.first,
        );
        navVM.markNavUpdated();
      }

// ====== CAMERA + MAP (RENDER POS) ======
      _handleCamera(renderPos, locationVM, navVM);
      await _handleRouteLogic(renderPos, routeVM, navVM);
      await _handleMarkers(renderPos, locationVM, routeVM);

    } finally {
      _isUpdatingMap = false;
    }
  }

  /// ===============================
  /// CAMERA MOVE TO USER
  /// ===============================
  void moveToUser() {
    final pos = context.read<LocationViewModel>().currentPosition;
    if (pos != null) {
      controller?.animateCamera(
        CameraUpdate.newLatLngZoom(pos, 16),
      );
    }
  }

  /// ===============================
  /// ARRIVAL DIALOG
  /// ===============================
  void showArrivalDialog(
      NavigationViewModel navVM,
      RouteViewModel routeVM,
      ) {
    if (isDialogShowing) return;

    isDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Xác nhận đến nơi"),
        content: Text(
          "Bạn đã hoàn thành: ${navVM.pendingPoint?.name}?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              final userPos =
                  context.read<LocationViewModel>().currentPosition;

              if (navVM.pendingPoint?.id != null &&
                  userPos != null) {
                routeVM.removePoint(
                  navVM.pendingPoint!.id,
                  userPos,
                );
              }

              navVM.clearPending();
              isDialogShowing = false;
              Navigator.pop(ctx);
            },
            child: const Text("HOÀN THÀNH"),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// START NAVIGATION (SNAP NGAY)
  /// ===============================
  Future<void> onStartNavigation() async {
    final locationVM = context.read<LocationViewModel>();
    final rawPos = locationVM.rawPosition;
    if (rawPos == null) return;

    final snapped = await _osrmService.snapUserToRoad(rawPos);
    if (snapped != null) {
      locationVM.setSnappedPosition(snapped);
      _lastSnapTime = DateTime.now();
    }
  }
}