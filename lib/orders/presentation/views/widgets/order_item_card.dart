import 'package:flutter/material.dart';
import '../../../domain/entities/order_entity.dart';
import 'order_status_badge.dart';
import 'order_info_section.dart';
import 'order_note_field.dart';
import 'order_actions_section.dart';

class OrderItemCard extends StatefulWidget {
  final OrderEntity order;
  final bool disabled;
  final Future<void> Function(OrderStatus status, {String? note})
      onChangeStatus;

  const OrderItemCard({
    super.key,
    required this.order,
    required this.disabled,
    required this.onChangeStatus,
  });

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  late String _cancelNote;

  @override
  void initState() {
    super.initState();
    _cancelNote = widget.order.cancelNote ?? '';
  }

  @override
  void didUpdateWidget(covariant OrderItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.order.cancelNote != widget.order.cancelNote) {
      _cancelNote = widget.order.cancelNote ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.order.code,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                OrderStatusBadge(status: widget.order.status),
              ],
            ),
            const SizedBox(height: 8),

            // Customer name
            Text(
              widget.order.customerName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),

            // Info section
            OrderInfoSection(order: widget.order),
            const SizedBox(height: 8),

            // Note field (chỉ show khi pending hoặc cancelled)
            if (widget.order.status == OrderStatus.pending ||
                widget.order.status == OrderStatus.cancelled)
              Column(
                children: [
                  OrderNoteField(
                    initialValue: widget.order.cancelNote,
                    enabled: widget.order.status == OrderStatus.pending &&
                        !widget.disabled,
                    onChanged: (value) => _cancelNote = value,
                  ),
                  const SizedBox(height: 8),
                ],
              ),

            // Show cancel note nếu đã hủy
            if (widget.order.status == OrderStatus.cancelled &&
                widget.order.cancelNote != null &&
                widget.order.cancelNote!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Text(
                    'Lý do hủy: ${widget.order.cancelNote}',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ),

            // Actions
            OrderActionsSection(
              order: widget.order,
              disabled: widget.disabled,
              onComplete: () =>
                  widget.onChangeStatus(OrderStatus.completed),
              onCancel: () => widget.onChangeStatus(
                OrderStatus.cancelled,
                note: _cancelNote.trim(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
