import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<List<OrderEntity>> getOrders();
  Future<OrderEntity> updateOrderStatus(
    String id,
    OrderStatus status, {
    String? note,
  });
  Future<OrderEntity> cancelOrder(String id, String note);
}
