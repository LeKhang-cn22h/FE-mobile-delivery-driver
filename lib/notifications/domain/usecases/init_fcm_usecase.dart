class InitFcmUsecase {
  Future<void> call() async {
    try {
      // TODO: Cài firebase_messaging khi backend ready
      print('✅ FCM initialization ready');
    } catch (e) {
      print('❌ FCM init error: $e');
    }
  }
}
