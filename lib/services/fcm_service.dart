import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

/// Background message handler — must be a top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase already initialized in main.dart
  await FcmService._showLocalNotification(
    title: message.notification?.title ?? 'LIFETAP',
    body: message.notification?.body ?? '',
    payload: jsonEncode(message.data),
  );
}

class FcmService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'lifetap_emergency',
    'Alertas de Emergencia',
    description: 'Notificaciones de alertas de emergencia LIFETAP',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  // ── Initialize ────────────────────────────────────────────────────────────
  static Future<void> init() async {
    // Local notifications setup
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _localNotifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    // Create high-priority channel (Android)
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // Request FCM permission (iOS)
    await FirebaseMessaging.instance.requestPermission(
      alert: true, badge: true, sound: true,
    );

    // Background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(
        title: message.notification?.title ?? 'LIFETAP',
        body: message.notification?.body ?? '',
        payload: jsonEncode(message.data),
      );
    });
  }

  // ── Get FCM Token ─────────────────────────────────────────────────────────
  static Future<String?> getToken() async {
    return FirebaseMessaging.instance.getToken();
  }

  // ── Save token to Firestore (call after login) ────────────────────────────
  static Future<void> saveFcmToken(String uid) async {
    final token = await getToken();
    if (token == null) return;
    // Update in Firestore (imported in service that needs it)
    // This is called from auth_provider after sign in
  }

  // ── Show local notification ───────────────────────────────────────────────
  static Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFFD32F2F),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  // ── Subscribe / Unsubscribe to topics ────────────────────────────────────
  static Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  // ── Stream of notification taps (for navigation) ──────────────────────────
  static Stream<RemoteMessage> get onMessageOpened =>
      FirebaseMessaging.onMessageOpenedApp;
}
