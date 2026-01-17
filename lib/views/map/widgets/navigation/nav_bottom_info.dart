import 'package:flutter/material.dart';

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
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 35), // Padding dưới để tránh thanh điều hướng điện thoại
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
        child: Row(
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
                child: const Icon(Icons.close, color: Colors.black54, size: 28),
              ),
            ),

            const Spacer(),

            // Thông tin chính (Thời gian & Khoảng cách)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    color: Color(0xFFE67E22), // Màu cam Google Maps
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "$distance • 16:35", // Giờ đến dự kiến
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Nút tùy chọn lộ trình phụ
            const Icon(Icons.alt_route, color: Colors.black54, size: 30),
          ],
        ),
      ),
    );
  }
}