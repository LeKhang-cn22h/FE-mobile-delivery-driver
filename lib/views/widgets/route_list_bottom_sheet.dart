import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/route_viewmodel.dart';

class RouteListView extends StatelessWidget {
  const RouteListView({super.key});

  @override
  Widget build(BuildContext context) {
    final routeVM = context.watch<RouteViewModel>();
    final points = routeVM.sortedPoints;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Thanh gạch nhỏ trên đầu để gợi ý kéo xuống được
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const Text(
            "Danh sách lộ trình",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (points.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text("Không có điểm dừng nào trong lộ trình."),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: points.length,
                itemBuilder: (context, index) {
                  final p = points[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: Text("${index + 1}", style: const TextStyle(color: Colors.blue)),
                    ),
                    title: Text(p.name),
                    subtitle: Text("Tọa độ: ${p.lat}, ${p.lng}"),
                    trailing: const Icon(Icons.location_on, color: Colors.red),
                    onTap: () {
                      // Có thể thêm logic zoom vào điểm này trên bản đồ nếu muốn
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}