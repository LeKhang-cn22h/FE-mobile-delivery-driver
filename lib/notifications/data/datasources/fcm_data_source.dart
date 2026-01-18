import 'package:firebase_messaging/firebase_messaging.dart';

class FCMDataSource {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request notification permissions
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ User granted notification permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('⚠️ User granted provisional notification permission');
    } else {
      print('❌ User denied notification permission');
    }

    // Get FCM token
    final token = await _messaging.getToken();
    print('🔑 FCM Token: $token');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📨 Foreground message received');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Data: ${message.data}');
      _handleMessage(message);
    });

    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📨 App opened from notification');
      _handleMessage(message);
    });

    // Handle background messages (app terminated)
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // Get initial message if app was opened from notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      print('📨 App opened from notification (initial)');
      _handleMessage(initialMessage);
    }

    print('✅ FCM initialized successfully');
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('📨 Background message received');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
  }

  void _handleMessage(RemoteMessage message) {
    // Handle notification data
    if (message.data.isNotEmpty) {
      print('Notification data: ${message.data}');
      // TODO: Parse data và navigate hoặc update UI
    }
  }

  Future<String?> getToken() => _messaging.getToken();

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    print('✅ Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    print('✅ Unsubscribed from topic: $topic');
  }
}
