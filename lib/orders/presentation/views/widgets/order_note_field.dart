import 'package:flutter/material.dart';

class OrderNoteField extends StatefulWidget {
  final String? initialValue;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const OrderNoteField({
    super.key,
    this.initialValue,
    required this.enabled,
    required this.onChanged,
  });

  @override
  State<OrderNoteField> createState() => _OrderNoteFieldState();
}

class _OrderNoteFieldState extends State<OrderNoteField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(covariant OrderNoteField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lý do hủy (nếu có):',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: _controller,
          enabled: widget.enabled,
          maxLines: 2,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Nhập lý do hủy đơn...',
            filled: !widget.enabled,
            fillColor: !widget.enabled ? Colors.grey[100] : null,
          ),
        ),
      ],
    );
  }
}
