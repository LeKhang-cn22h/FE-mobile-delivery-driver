import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class CancelOrderUsecase {
  final OrderRepository repository;

  CancelOrderUsecase(this.repository);

  Future<OrderEntity> call(String id, String note) =>
      repository.cancelOrder(id, note);
}
