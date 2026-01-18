import 'package:provider/provider.dart';
import '../data/datasources/order_local_data_source.dart';
import '../data/repositories/order_repository.dart';
import '../domain/repositories/order_repository.dart' as domain_repo;
import '../domain/usecases/get_orders_usecase.dart';
import '../domain/usecases/update_order_status_usecase.dart';
import '../domain/usecases/cancel_order_usecase.dart';
import '../presentation/viewmodels/order_list_viewmodel.dart';

class OrderInjection {
  static List<dynamic> getProviders() {
    final localDataSource = OrderLocalDataSourceImpl();
    final repository = OrderRepositoryImpl(localDataSource: localDataSource);

    return [
      // Data source
      Provider<OrderLocalDataSource>(create: (_) => localDataSource),

      // Repository
      Provider<domain_repo.OrderRepository>(create: (_) => repository),

      // Use cases
      Provider<GetOrdersUsecase>(create: (_) => GetOrdersUsecase(repository)),
      Provider<UpdateOrderStatusUsecase>(
        create: (_) => UpdateOrderStatusUsecase(repository),
      ),
      Provider<CancelOrderUsecase>(
        create: (_) => CancelOrderUsecase(repository),
      ),

      // ViewModel
      ChangeNotifierProvider<OrderListViewmodel>(
        create: (ref) => OrderListViewmodel(
          getOrdersUsecase: GetOrdersUsecase(repository),
          updateOrderStatusUsecase: UpdateOrderStatusUsecase(repository),
          cancelOrderUsecase: CancelOrderUsecase(repository),
        ),
      ),
    ];
  }
}
