import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/order_entity.dart';

abstract class OrderLocalDataSource {
  Future<List<OrderEntity>> getOrders();
  Future<OrderEntity> updateOrderStatus(
    String id,
    OrderStatus status, {
    String? note,
  });
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  List<OrderEntity> _cache = [];

  @override
  Future<List<OrderEntity>> getOrders() async {
    if (_cache.isNotEmpty) return _cache;

    try {
      final jsonStr =
          await rootBundle.loadString('assets/orders_fake.json');
      final List<dynamic> raw = jsonDecode(jsonStr) as List<dynamic>;
      _cache = raw.map((e) => _parseOrder(e as Map<String, dynamic>)).toList();
      return _cache;
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  @override
  Future<OrderEntity> updateOrderStatus(
    String id,
    OrderStatus status, {
    String? note,
  }) async {
    _cache = _cache.map((order) {
      if (order.id != id) return order;
      if (status == OrderStatus.completed) {
        return order.copyWith(
          status: OrderStatus.completed,
          completedAt: DateTime.now().toIso8601String(),
        );
      }
      if (status == OrderStatus.cancelled) {
        return order.copyWith(
          status: OrderStatus.cancelled,
          cancelNote: note ?? '',
        );
      }
      return order.copyWith(status: status);
    }).toList();

    final updated = _cache.firstWhere((o) => o.id == id);
    return updated;
  }

  // Private: parse JSON
  OrderEntity _parseOrder(Map<String, dynamic> json) {
    return OrderEntity(
      id: json['id'] as String,
      code: json['code'] as String,
      customerName: json['customerName'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      expectedTime: json['expectedTime'] as String,
      status: _statusFromString(json['status'] as String),
      cancelNote: json['cancelNote'] as String?,
      completedAt: json['completedAt'] as String?,
    );
  }

  static OrderStatus _statusFromString(String value) {
    switch (value) {
      case 'COMPLETED':
        return OrderStatus.completed;
      case 'CANCELLED':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}
