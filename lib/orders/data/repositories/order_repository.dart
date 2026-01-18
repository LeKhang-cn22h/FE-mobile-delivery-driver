import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource localDataSource;

  OrderRepositoryImpl({required this.localDataSource});

  @override
  Future<List<OrderEntity>> getOrders() => localDataSource.getOrders();

  @override
  Future<OrderEntity> updateOrderStatus(
    String id,
    OrderStatus status, {
    String? note,
  }) =>
      localDataSource.updateOrderStatus(id, status, note: note);

  @override
  Future<OrderEntity> cancelOrder(String id, String note) =>
      updateOrderStatus(id, OrderStatus.cancelled, note: note);
}
