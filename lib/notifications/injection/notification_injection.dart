import 'package:provider/provider.dart';
import '../domain/usecases/init_fcm_usecase.dart';

class NotificationInjection {
  static List<Provider> getProviders() => [
        Provider<InitFcmUsecase>(
          create: (_) => InitFcmUsecase(),
        ),
      ];
}
