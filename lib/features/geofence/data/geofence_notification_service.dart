import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class GeofenceNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'geofence_entry';
  static const _channelName = 'Geofence alerts';

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: 'Alerts when you enter a saved location',
            importance: Importance.high,
          ),
        );

    _initialized = true;
  }

  static Future<void> showEntry(String locationName) async {
    await init();
    await _plugin.show(
      id: locationName.hashCode,
      title: 'Location entered',
      body: 'You entered $locationName',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
