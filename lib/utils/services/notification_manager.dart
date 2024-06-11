import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../all_utills.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();

  factory NotificationManager() => _instance;

  NotificationManager._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static NotificationManager get instance => _instance;

  Future<void> requestNotificationsPermission() async {
    //first must request permission for notification
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User Granted Permissions');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User Granted Provisional Permissions');
    } else {
      print('User Declined Permissions');
    }
  }

  Future<String?> getDeviceToken() async {
    String? token = await _firebaseMessaging.getToken();
    print('fcm token $token');
    return token;
  }

  void isTokenRefresh() async {
    _firebaseMessaging.onTokenRefresh.listen((event) async {
      updateFCMToken(event);
    });
  }

  Future<void> firebaseInit() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('App in Foreground call');
      print(message.notification?.title.toString());
      print(message.notification..toString());

      if (Platform.isAndroid) {
        await _showNotification(message);
      }

      if (Platform.isIOS) {
        await _foregroundMessage();
      }
    });
  }

  // Foreground notifications (also known as "heads up") are those which display for a brief period of time above existing applications, and should be used for important events.
  // Android & iOS have different behaviors when handling notifications whilst applications are in the foreground so keep this in mind whilst developing.
  // for iOS Configuration
  static Future<void> _foregroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> setupInteractMessage() async {
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    // Get any messages which caused the application to open from a terminated state.
    if (initialMessage != null) {
      _handleNotificationRedirectionTerminated(initialMessage);
    }
    // A Stream which posts a RemoteMessage when the application is opened from a background state.
    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      _backgroundNotificationOpen(event);
    });
  }

  Future<void> configureNotifications() async {
    WidgetsFlutterBinding.ensureInitialized();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      print('Flutter Notification Payload $payload');
      _handleNotificationRedirection(payload);
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    AndroidNotificationChannel(
        Random.secure().nextInt(1000000).toString(), 'Notification',
        importance: Importance.max);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'high_importance_channel', // Change this to a unique channel ID
            'high_importance_channel', // Change this to a channel name
            channelDescription:
                'Description', // Change this to a channel description
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');

    const DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0, // Notification ID (change this for each notification)
        message.notification?.title.toString(), // Notification title
        message.notification?.body.toString(), // Notification body
        platformChannelSpecifics,
      );
    });
  }

  void _handleNotificationRedirection(
      NotificationResponse? notificationResponse) async {
    print('Flutter Notification Payload');
    print(notificationResponse?.payload);
  }

  void _handleNotificationRedirectionTerminated(
      RemoteMessage remoteMessage) async {
    print('App in Terminate Notification call');
    print(remoteMessage.notification?.title);
  }

  void _backgroundNotificationOpen(RemoteMessage event) {
    print('App in background Notification call');
    print(event.notification?.title);
  }
}
