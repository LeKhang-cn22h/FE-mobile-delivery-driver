import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../viewmodels/navigation_viewmodel.dart';
import '../../viewmodels/route_viewmodel.dart';
import '../../viewmodels/location_viewmodel.dart';

import 'map_logic_mixin.dart';
import 'widgets/components/map_view_widget.dart';
import 'widgets/components/check_route_button.dart';
import 'widgets/components/location_button.dart';
import 'widgets/navigation/nav_instruction_panel.dart';
import 'widgets/navigation/nav_bottom_info.dart';
import 'widgets/navigation/start_navigation_button.dart';
import 'widgets/navigation/route_list_bottom_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with MapLogicMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationViewModel>().addListener(handleMapUpdate);
      context.read<RouteViewModel>().addListener(handleMapUpdate);
      context.read<NavigationViewModel>().addListener(handleMapUpdate);
    });
  }

  @override
  void dispose() {
    // Đảm bảo gỡ listener để tránh memory leak
    context.read<LocationViewModel>().removeListener(handleMapUpdate);
    context.read<RouteViewModel>().removeListener(handleMapUpdate);
    context.read<NavigationViewModel>().removeListener(handleMapUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navVM = context.watch<NavigationViewModel>();
    final routeVM = context.watch<RouteViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          MapViewWidget(onMapCreated: (c) => controller = c),

          if (navVM.isNavigating) ...[
            NavInstructionPanel(instruction: routeVM.currentInstruction),
            NavBottomInfo(
              time: routeVM.remainingTime,
              distance: routeVM.remainingDistance,
              onStop: () {
                controller?.updateContentInsets(EdgeInsets.zero);
                controller?.animateCamera(CameraUpdate.tiltTo(0));
                navVM.toggleNavigation();
              },
            ),
          ] else ...[
            const CheckRouteButton(),
            _buildSideListButton(),
            LocationButton(onPressed: moveToUser),
            const StartNavigationButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildSideListButton() {
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
}