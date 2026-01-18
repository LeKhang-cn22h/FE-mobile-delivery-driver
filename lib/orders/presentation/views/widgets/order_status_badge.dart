import 'package:flutter/material.dart';
import '../../../domain/entities/order_entity.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label) = _getStatusDisplay(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (Color, String) _getStatusDisplay(OrderStatus status) {
    switch (status) {
      case OrderStatus.completed:
        return (Colors.green, 'Đã giao');
      case OrderStatus.cancelled:
        return (Colors.red, 'Đã hủy');
      case OrderStatus.pending:
      default:
        return (Colors.orange, 'Chờ giao');
    }
  }
}
