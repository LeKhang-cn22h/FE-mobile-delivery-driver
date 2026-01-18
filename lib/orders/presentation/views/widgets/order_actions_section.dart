import 'package:flutter/material.dart';
import '../../../domain/entities/order_entity.dart';

class OrderActionsSection extends StatelessWidget {
  final OrderEntity order;
  final bool disabled;
  final VoidCallback onComplete;
  final VoidCallback onCancel;

  const OrderActionsSection({
    super.key,
    required this.order,
    required this.disabled,
    required this.onComplete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final canChangeStatus =
        !disabled && order.status != OrderStatus.completed;
    final canCancel =
        !disabled && order.status != OrderStatus.cancelled;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: canChangeStatus ? onComplete : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Đã giao'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: canCancel ? onCancel : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Hủy đơn'),
          ),
        ),
      ],
    );
  }
}
