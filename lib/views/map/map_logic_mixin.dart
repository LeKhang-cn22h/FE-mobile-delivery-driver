import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/location_viewmodel.dart';
import '../../viewmodels/route_viewmodel.dart';
import '../../viewmodels/navigation_viewmodel.dart';
import '../../utils/map_utils.dart';
import '../../utils/route_logic_handler.dart';

mixin MapLogicMixin<T extends StatefulWidget> on State<T> {
  MapLibreMapController? controller;
  Line? routeLine;
  bool movedOnce = false;
  bool isDialogShowing = false;

  // Giữ nguyên logic xử lý cập nhật bản đồ
  void handleMapUpdate() async {
    if (controller == null) return;

    final locationVM = context.read<LocationViewModel>();
    final routeVM = context.read<RouteViewModel>();
    final navVM = context.read<NavigationViewModel>();
    final userPos = locationVM.currentPosition;

    if (userPos == null) return;

    // Logic Camera trong chế độ dẫn đường
    if (navVM.isNavigating) {
      routeVM.updateNavigationData(userPos);
      controller?.updateContentInsets(const EdgeInsets.only(bottom: 220));
      controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: userPos,
            zoom: 18.0,
            tilt: 60.0,
            bearing: locationVM.heading,
          ),
        ),
      );
    } else if (!movedOnce) {
      movedOnce = true;
      moveToUser();
    }

    // Logic vẽ đường và kiểm tra lệch tuyến
    if (routeVM.routeLine.isNotEmpty) {
      if (RouteLogicHandler.isUserOffRoute(userPos, routeVM.routeLine) && !routeVM.isCalculating) {
        routeVM.calculateTodayRoute(userPos);
        return;
      }
      final remainingRoute = RouteLogicHandler.trimPassedRoute(routeVM.routeLine, userPos);
      routeLine = await MapUtils.drawRoute(controller!, remainingRoute, oldLine: routeLine);
    }

    // Logic xác nhận đến điểm dừng
    if (navVM.pendingPoint == null && !isDialogShowing) {
      final arrivedPoint = RouteLogicHandler.checkArrival(userPos, routeVM.sortedPoints);
      if (arrivedPoint != null) {
        navVM.setPendingPoint(arrivedPoint);
        showArrivalDialog(navVM, routeVM);
      }
    }
    await MapUtils.drawMarkers(controller!, routeVM.sortedPoints);
  }

  void moveToUser() {
    final pos = context.read<LocationViewModel>().currentPosition;
    if (pos != null) {
      controller?.animateCamera(CameraUpdate.newLatLngZoom(pos, 16));
    }
  }

  void showArrivalDialog(NavigationViewModel navVM, RouteViewModel routeVM) {
    if (isDialogShowing) return;
    isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Xác nhận đến nơi"),
        content: Text("Bạn đã hoàn thành: ${navVM.pendingPoint?.name}?"),
        actions: [
          TextButton(
            onPressed: () {
              final userPos = context.read<LocationViewModel>().currentPosition;
              if (navVM.pendingPoint?.id != null && userPos != null) {
                routeVM.removePoint(navVM.pendingPoint!.id, userPos);
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
}