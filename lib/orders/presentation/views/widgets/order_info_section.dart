import 'package:flutter/material.dart';
import '../../../domain/entities/order_entity.dart';

class OrderInfoSection extends StatelessWidget {
  final OrderEntity order;

  const OrderInfoSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(label: 'Địa chỉ:', value: order.address),
        _InfoRow(label: 'SĐT:', value: order.phone),
        _InfoRow(label: 'Giờ dự kiến:', value: order.expectedTime),
        if (order.status == OrderStatus.completed && order.completedAt != null)
          _InfoRow(label: 'Hoàn thành lúc:', value: order.completedAt ?? ''),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(value, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
