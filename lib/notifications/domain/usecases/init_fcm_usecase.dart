import '../../data/datasources/fcm_data_source.dart';

class InitFcmUsecase {
  final FCMDataSource _dataSource;

  InitFcmUsecase(this._dataSource);

  Future<void> call() async {
    try {
      await _dataSource.initialize();
      print('✅ FCM usecase executed successfully');
    } catch (e) {
      print('❌ FCM init error: $e');
      rethrow;
    }
  }
}
