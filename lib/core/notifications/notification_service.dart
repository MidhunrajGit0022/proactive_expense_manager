import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  factory NotificationService() => _instance;

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(settings);
  }

  Future<void> showBudgetAlert(double currentTotal, double limit) async {
    const androidDetails = AndroidNotificationDetails(
      'budget_alert',
      'Budget Alerts',
      channelDescription: 'Notifications for budget limit exceeded',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      0,
      '⚠️ Budget Limit Exceeded!',
      'Your monthly expenses (₹${currentTotal.toStringAsFixed(0)}) have exceeded your limit of ₹${limit.toStringAsFixed(0)}.',
      details,
    );
  }
}
