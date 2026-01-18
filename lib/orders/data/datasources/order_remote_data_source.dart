import '../../domain/entities/order_entity.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderEntity>> getOrders();
  Future<OrderEntity> updateOrderStatus(
    String id,
    OrderStatus status, {
    String? note,
  });
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  @override
  Future<List<OrderEntity>> getOrders() async {
    // TODO: call BE microservice /api/orders
    throw UnimplementedError('Call real BE API');
  }

  @override
  Future<OrderEntity> updateOrderStatus(
    String id,
    OrderStatus status, {
    String? note,
  }) async {
    // TODO: call BE microservice PATCH /api/orders/{id}/status
    throw UnimplementedError('Call real BE API');
  }
}
