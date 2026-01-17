import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:provider/provider.dart';

// Import ViewModels
import '../../viewmodels/location_viewmodel.dart';
import '../../viewmodels/route_viewmodel.dart';
import '../../viewmodels/navigation_viewmodel.dart';

// Import Utils
import '../../utils/map_utils.dart';
import '../../utils/route_logic_handler.dart';

// Import Widgets
import '../widgets/map_view_widget.dart';
import '../widgets/check_route_button.dart';
import '../widgets/location_button.dart';
import '../widgets/route_list_bottom_sheet.dart';
import '../widgets/nav_instruction_panel.dart'; // Widget bảng xanh phía trên
import '../widgets/nav_bottom_info.dart';        // Widget thông tin phía dưới

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapLibreMapController? _controller;
  Line? _routeLine;
  bool _movedOnce = false;
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationViewModel>().addListener(_handleMapUpdate);
      context.read<RouteViewModel>().addListener(_handleMapUpdate);
      context.read<NavigationViewModel>().addListener(_handleMapUpdate);
    });
  }

  @override
  void dispose() {
    context.read<LocationViewModel>().removeListener(_handleMapUpdate);
    context.read<RouteViewModel>().removeListener(_handleMapUpdate);
    context.read<NavigationViewModel>().removeListener(_handleMapUpdate);
    super.dispose();
  }

  /// Hàm xử lý cập nhật bản đồ chính
  void _handleMapUpdate() async {
    if (_controller == null) return;

    final locationVM = context.read<LocationViewModel>();
    final routeVM = context.read<RouteViewModel>();
    final navVM = context.read<NavigationViewModel>();
    final userPos = locationVM.currentPosition;

    if (userPos == null) return;

    // --- LOGIC CAMERA & DATA: NAVIGATION MODE ---
    if (navVM.isNavigating) {
      // 1. Cập nhật chữ chỉ dẫn từ API OSRM thông qua ViewModel
      routeVM.updateNavigationData(userPos);

      // 2. Cấu hình Camera dẫn đường chuyên nghiệp
      _controller?.updateContentInsets(const EdgeInsets.only(bottom: 220)); // Đẩy icon user xuống dưới

      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: userPos,
            zoom: 18.0,
            tilt: 60.0, // Góc nghiêng 3D giống Google Maps
            bearing: locationVM.heading, // Xoay theo hướng di chuyển của user
          ),
        ),
      );
    } else {
      // Khi không ở chế độ dẫn đường
      if (!_movedOnce) {
        _movedOnce = true;
        _moveToUser();
      }
    }

    // --- LOGIC LỘ TRÌNH & MARKERS ---
    if (routeVM.routeLine.isNotEmpty) {
      if (RouteLogicHandler.isUserOffRoute(userPos, routeVM.routeLine) && !routeVM.isCalculating) {
        routeVM.calculateTodayRoute(userPos);
        return;
      }
      final remainingRoute = RouteLogicHandler.trimPassedRoute(routeVM.routeLine, userPos);
      _routeLine = await MapUtils.drawRoute(_controller!, remainingRoute, oldLine: _routeLine);
    }

    // Check điểm đến
    if (navVM.pendingPoint == null && !_isDialogShowing) {
      final arrivedPoint = RouteLogicHandler.checkArrival(userPos, routeVM.sortedPoints);
      if (arrivedPoint != null) {
        navVM.setPendingPoint(arrivedPoint);
        _showArrivalDialog(navVM, routeVM);
      }
    }
    await MapUtils.drawMarkers(_controller!, routeVM.sortedPoints);
  }

  @override
  Widget build(BuildContext context) {
    final navVM = context.watch<NavigationViewModel>();
    final routeVM = context.watch<RouteViewModel>();
    final isNavigating = navVM.isNavigating;

    return Scaffold(
      body: Stack(
        children: [
          MapViewWidget(onMapCreated: (c) => _controller = c),

          // 1. BẢNG CHỈ DẪN PHÍA TRÊN (HIỆN KHI DẪN ĐƯỜNG)
          if (isNavigating)
            NavInstructionPanel(instruction: routeVM.currentInstruction),

          // 2. CÁC NÚT ĐIỀU KHIỂN CHẾ ĐỘ THƯỜNG
          if (!isNavigating) ...[
            const CheckRouteButton(),
            _buildSideButtons(),
            LocationButton(onPressed: _moveToUser),
            _buildStartActionButton(), // Nút "Bắt đầu đi"
          ],

          // 3. THÔNG TIN HÀNH TRÌNH PHÍA DƯỚI (HIỆN KHI DẪN ĐƯỜNG)
          if (isNavigating)
            NavBottomInfo(
              time: routeVM.remainingTime,
              distance: routeVM.remainingDistance,
              onStop: () {
                _controller?.updateContentInsets(EdgeInsets.zero); // Trả lại tâm màn hình
                _controller?.animateCamera(CameraUpdate.tiltTo(0)); // Bỏ nghiêng 3D
                navVM.toggleNavigation();
              },
            ),
        ],
      ),
    );
  }

  // Nút Bắt đầu dẫn đường (Chỉ hiện ở chế độ chờ)
  Widget _buildStartActionButton() {
    return Positioned(
      bottom: 25,
      left: 20,
      right: 80,
      child: SizedBox(
        height: 55,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 8,
          ),
          onPressed: () => context.read<NavigationViewModel>().toggleNavigation(),
          icon: const Icon(Icons.navigation),
          label: const Text(
            "BẮT ĐẦU ĐI",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildSideButtons() {
    return Positioned(
      bottom: 100,
      right: 16,
      child: FloatingActionButton(
        mini: true,
        heroTag: 'route_list_fab',
        backgroundColor: Colors.white,
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const RouteListView(),
        ),
        child: const Icon(Icons.list, color: Colors.blue),
      ),
    );
  }

  void _moveToUser() {
    final pos = context.read<LocationViewModel>().currentPosition;
    if (pos != null) {
      _controller?.animateCamera(CameraUpdate.newLatLngZoom(pos, 16));
    }
  }

  void _showArrivalDialog(NavigationViewModel navVM, RouteViewModel routeVM) {
    if (_isDialogShowing) return;
    _isDialogShowing = true;
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
              _isDialogShowing = false;
              Navigator.pop(ctx);
            },
            child: const Text("HOÀN THÀNH"),
          ),
        ],
      ),
    );
  }
}