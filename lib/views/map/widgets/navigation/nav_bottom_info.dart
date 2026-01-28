import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodels/location_viewmodel.dart';
import '../../../../viewmodels/navigation_viewmodel.dart';
import '../../../../viewmodels/route_viewmodel.dart';


class NavBottomInfo extends StatelessWidget {
  final String time;      // Ví dụ: "6 phút"
  final String distance;  // Ví dụ: "1,7 km"
  final VoidCallback onStop;

  const NavBottomInfo({
    super.key,
    required this.time,
    required this.distance,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final navVM = context.watch<NavigationViewModel>();
    final totalDistanceText =
    context.select<RouteViewModel, String>((vm) => vm.totalDistanceText);


    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 35),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ================= ROW CHÍNH (GIỮ NGUYÊN LOGIC) =================
            Row(
              children: [
                // Nút đóng (Dấu X)
                GestureDetector(
                  onTap: onStop,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black12),
                    ),
                    child:
                    const Icon(Icons.close, color: Colors.black54, size: 28),
                  ),
                ),

                const Spacer(),

                // Thông tin chính (Thời gian & Khoảng cách)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      navVM.remainingTime, // hoặc time nếu mày đã bind đúng
                      style: const TextStyle(
                        color: Color(0xFFE67E22),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$totalDistanceText",

                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Nút tùy chọn lộ trình phụ
                const Icon(Icons.alt_route,
                    color: Colors.black54, size: 30),
              ],
            ),

            const SizedBox(height: 10),

            // ================= TỌA ĐỘ NGƯỜI DÙNG REALTIME =================
            Consumer<LocationViewModel>(
              builder: (context, locationVM, _) {
                final pos = locationVM.currentPosition;

                if (pos == null) {
                  return const Text(
                    "📍 Đang lấy vị trí...",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  );
                }

                return Text(
                  "📍 Lat: ${pos.latitude.toStringAsFixed(6)} | "
                      "Lng: ${pos.longitude.toStringAsFixed(6)}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}