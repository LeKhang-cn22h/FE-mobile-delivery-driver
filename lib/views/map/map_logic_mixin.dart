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
  MapLibreMapController? controller;
  Line? routeLine;

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
  Future<void> handleMapUpdate() async {
    if (controller == null) return;

    final locationVM = context.read<LocationViewModel>();
    final routeVM = context.read<RouteViewModel>();
    final navVM = context.read<NavigationViewModel>();

    final rawPos = locationVM.rawPosition;
    if (rawPos == null) return;

    /// ===============================
    /// SNAP USER TO ROAD
    /// ===============================
    if (navVM.isNavigating && _canSnap) {
      final snapped = await _osrmService.snapUserToRoad(rawPos);
      if (snapped != null) {
        locationVM.setSnappedPosition(snapped); // Đẩy vào VM
        _lastSnapTime = DateTime.now();
      }
    }

    final userPos = locationVM.currentPosition!;
    /// ===============================

    /// ===============================
    /// CAMERA CONTROL
    /// ===============================
    if (navVM.isNavigating) {
      routeVM.updateNavigationData(userPos);

      controller!.updateContentInsets(
        const EdgeInsets.only(bottom: 220),
      );

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
    } else if (!movedOnce) {
      movedOnce = true;
      moveToUser();
    }

    /// ===============================
    /// ROUTE LOGIC
    /// ===============================
    if (routeVM.routeLine.isNotEmpty) {
      final isOffRoute = RouteLogicHandler.isUserOffRoute(
        userPos,
        routeVM.routeLine,
      );

      if (isOffRoute && !routeVM.isCalculating) {
        routeVM.calculateTodayRoute(userPos);
        return;
      }

      final remainingRoute =
      RouteLogicHandler.trimPassedRoute(
        routeVM.routeLine,
        userPos,
      );

      routeLine = await MapUtils.drawRoute(
        controller!,
        remainingRoute,
        oldLine: routeLine,
      );
    }

    /// ===============================
    /// ARRIVAL CHECK
    /// ===============================
    if (navVM.pendingPoint == null && !isDialogShowing) {
      final arrivedPoint =
      RouteLogicHandler.checkArrival(
        userPos,
        routeVM.sortedPoints,
      );

      if (arrivedPoint != null) {
        navVM.setPendingPoint(arrivedPoint);
        showArrivalDialog(navVM, routeVM);
      }
    }

    /// ===============================
    /// DRAW MARKERS
    /// ===============================
    await MapUtils.drawMarkers(
      controller!,
      routeVM.sortedPoints,
    );

    /// ===============================
    /// USER MARKER (SNAPPED POSITION)
    /// ===============================
    await MapUtils.drawOrUpdateUserMarker(
      controller!,
      userPos,
      locationVM.heading,
    );
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
    if (controller == null) return;

    final locationVM = context.read<LocationViewModel>();
    final navVM = context.read<NavigationViewModel>();
    final routeVM = context.read<RouteViewModel>();

    final rawPos = locationVM.rawPosition;
    if (rawPos == null) return;

    final snapped =
    await _osrmService.snapUserToRoad(rawPos);

    final userPos = snapped ?? rawPos;

    if (snapped != null) {
      locationVM.setSnappedPosition(snapped);
    }

    _lastSnapTime = DateTime.now();

    if (navVM.isNavigating) {
      routeVM.updateNavigationData(userPos);
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

    await handleMapUpdate();
  }
}