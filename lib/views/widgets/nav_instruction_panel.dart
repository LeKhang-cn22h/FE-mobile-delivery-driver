import 'package:flutter/material.dart';

class NavInstructionPanel extends StatelessWidget {
  final String instruction;
  final String subInstruction;

  const NavInstructionPanel({
    super.key,
    required this.instruction,
    this.subInstruction = "Sau đó",
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50, // Điều chỉnh để không bị đè bởi Notch/StatusBar
      left: 10,
      right: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bảng chỉ dẫn chính
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF006144), // Màu xanh lá đậm đặc trưng của Google Maps
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                // Icon mũi tên chỉ hướng
                const Icon(Icons.arrow_upward, color: Colors.white, size: 42),
                const SizedBox(width: 16),
                // Nội dung chỉ dẫn
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "về hướng",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        instruction,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Icon Micro (Chỉ đường bằng giọng nói)
                const CircleAvatar(
                  backgroundColor: Colors.black12,
                  child: Icon(Icons.mic, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Bảng chỉ dẫn phụ (Sau đó...)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF004D36), // Màu tối hơn một chút
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$subInstruction ",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const Icon(Icons.turn_right, color: Colors.white, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}