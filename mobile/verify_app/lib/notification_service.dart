import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await _notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    
    // Request notification permission for Android 13+
    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showRegistrationSuccess(String username) async {
    await _notifications.show(
      0,
      'Добро пожаловать!',
      'Регистрация прошла успешно, $username',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'auth_channel',
          'Авторизация',
          channelDescription: 'Уведомления об авторизации',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  static Future<void> showLoginSuccess() async {
    await _notifications.show(
      1,
      'Успешный вход',
      'Вы вошли в приложение Verify',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'auth_channel',
          'Авторизация',
          channelDescription: 'Уведомления об авторизации',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  static Future<void> showPinChanged() async {
    await _notifications.show(
      2,
      'PIN изменен',
      'Ваш PIN-код успешно обновлен',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'security_channel',
          'Безопасность',
          channelDescription: 'Уведомления о безопасности',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}