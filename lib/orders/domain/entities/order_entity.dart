enum OrderStatus { completed, cancelled, pending }

class OrderEntity {
  final String id;
  final String code;
  final String customerName;
  final String address;
  final String phone;
  final String expectedTime;
  final OrderStatus status;
  final String? cancelNote;
  final String? completedAt;

  OrderEntity({
    required this.id,
    required this.code,
    required this.customerName,
    required this.address,
    required this.phone,
    required this.expectedTime,
    required this.status,
    this.cancelNote,
    this.completedAt,
  });

  // Copy with
  OrderEntity copyWith({
    OrderStatus? status,
    String? cancelNote,
    String? completedAt,
  }) {
    return OrderEntity(
      id: id,
      code: code,
      customerName: customerName,
      address: address,
      phone: phone,
      expectedTime: expectedTime,
      status: status ?? this.status,
      cancelNote: cancelNote ?? this.cancelNote,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  String toString() => 'Order($code, $status)';
}
