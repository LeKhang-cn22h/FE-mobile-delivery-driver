import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class UpdateOrderStatusUsecase {
  final OrderRepository repository;

  UpdateOrderStatusUsecase(this.repository);

  Future<OrderEntity> call(
    String id,
    OrderStatus status, {
    String? note,
  }) =>
      repository.updateOrderStatus(id, status, note: note);
}
