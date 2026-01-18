import 'package:flutter/foundation.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';
import '../../domain/usecases/cancel_order_usecase.dart';

class OrderListViewmodel extends ChangeNotifier {
  final GetOrdersUsecase getOrdersUsecase;
  final UpdateOrderStatusUsecase updateOrderStatusUsecase;
  final CancelOrderUsecase cancelOrderUsecase;

  OrderListViewmodel({
    required this.getOrdersUsecase,
    required this.updateOrderStatusUsecase,
    required this.cancelOrderUsecase,
  });

  List<OrderEntity> _orders = [];
  bool _loading = false;
  String? _updatingId;
  String? _error;

  List<OrderEntity> get orders => _orders;
  bool get loading => _loading;
  String? get updatingId => _updatingId;
  String? get error => _error;

  Future<void> loadOrders() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _orders = await getOrdersUsecase.call();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> completeOrder(String id) async {
    _updatingId = id;
    notifyListeners();

    try {
      final updated =
          await updateOrderStatusUsecase(id, OrderStatus.completed);
      _orders = _orders.map((o) => o.id == id ? updated : o).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _updatingId = null;
      notifyListeners();
    }
  }

  Future<void> cancelOrderWithNote(String id, String note) async {
    _updatingId = id;
    notifyListeners();

    try {
      final updated = await cancelOrderUsecase(id, note);
      _orders = _orders.map((o) => o.id == id ? updated : o).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _updatingId = null;
      notifyListeners();
    }
  }
}
