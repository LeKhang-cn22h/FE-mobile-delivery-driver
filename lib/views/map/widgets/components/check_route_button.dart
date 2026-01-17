import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodels/location_viewmodel.dart';
import '../../../../viewmodels/route_viewmodel.dart';



class CheckRouteButton extends StatelessWidget {
  const CheckRouteButton({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Chỉ theo dõi vị trí từ LocationViewModel để bật/tắt nút
    final userPos = context.select((LocationViewModel vm) => vm.currentPosition);
    final hasLocation = userPos != null;

    return Positioned(
      top: 50,
      left: 16,
      right: 16,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.route),
        label: const Text("Check lộ trình hôm nay"),
        // 2. Nếu có vị trí, khi nhấn sẽ gọi RouteViewModel xử lý
        onPressed: hasLocation
            ? () => context.read<RouteViewModel>().calculateTodayRoute(userPos)
            : null,
      ),
    );
  }
}