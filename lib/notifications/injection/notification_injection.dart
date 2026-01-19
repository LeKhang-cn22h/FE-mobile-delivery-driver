import 'package:provider/provider.dart';
import '../data/datasources/fcm_data_source.dart';
import '../domain/usecases/init_fcm_usecase.dart';

class NotificationInjection {
  static List<Provider> getProviders() => [
    // Provider<InitFcmUsecase>(
    //   create: (_) => InitFcmUsecase(),
    // ),
    Provider<FCMDataSource>(
      create: (_) => FCMDataSource(),
    ),

    Provider<InitFcmUsecase>(
      create: (context) => InitFcmUsecase(
        context.read<FCMDataSource>(),
      ),
    ),

  ];
}