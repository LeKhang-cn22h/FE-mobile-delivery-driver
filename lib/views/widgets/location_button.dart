import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/location_viewmodel.dart';

class LocationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LocationButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // Chỉ theo dõi trạng thái có tọa độ hay chưa từ LocationViewModel
    final hasLocation = context.select((LocationViewModel vm) => vm.currentPosition != null);

    return Positioned(
      bottom: 30,
      right: 16,
      child: FloatingActionButton(
        // Nếu chưa có GPS, nút sẽ ở trạng thái disable (màu xám)
        onPressed: hasLocation ? onPressed : null,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}