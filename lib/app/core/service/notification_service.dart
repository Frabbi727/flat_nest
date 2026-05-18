import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../service/auth_service.dart';
import '../../route/app_routes.dart';

// Must be top-level for Firebase background processing
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {}

class NotificationService extends GetxService {
  final unreadCount = 0.obs;

  static final _localNotifs = FlutterLocalNotificationsPlugin();
  static const _channelId = 'flatnest_default';
  static const _channelName = 'FlatNest';

  Future<NotificationService> init() async {
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

    // Request permission (iOS + Android 13+); guard against duplicate calls on hot-restart
    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (_) {}

    await _initLocalNotifications();

    // Foreground push messages — show local notification + increment badge
    FirebaseMessaging.onMessage.listen(_onForeground);

    // User tapped a notification while app was in background
    FirebaseMessaging.onMessageOpenedApp.listen(_onTap);

    // App launched by tapping a notification (was terminated)
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) _onTap(initial);

    // Re-register when Firebase rotates the token
    FirebaseMessaging.instance.onTokenRefresh.listen((_) => _registerToken());

    // If user is already logged in (returning user), refresh count + token
    final auth = Get.find<AuthService>();
    if (auth.isAuthenticated) {
      await Future.wait([refreshUnreadCount(), _registerToken()]);
    }

    // Reset badge when user logs out (token becomes null)
    ever(auth.tokenNotifier, (token) {
      if (token == null) clearUnread();
    });

    return this;
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _localNotifs.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (details) {
        // payload = kind field from the FCM message data
        _navigateByKind(details.payload);
      },
    );

    await _localNotifs
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            importance: Importance.high,
          ),
        );
  }

  void _onForeground(RemoteMessage message) {
    final n = message.notification;
    if (n == null) return;

    unreadCount.value++;

    _localNotifs.show(
      message.hashCode,
      n.title ?? '',
      n.body ?? '',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data['kind'] as String?,
    );
  }

  void _onTap(RemoteMessage message) {
    final kind = message.data['kind'] as String?;
    _navigateByKind(kind);
  }

  void _navigateByKind(String? kind) {
    switch (kind) {
      case 'listing_approved':
      case 'listing_submitted':
      case 'listing_rejected':
      case 'listing_review':
        Get.offAllNamed(Routes.ownerHome);
    }
  }

  /// Call this immediately after login / Google Sign-In.
  Future<void> registerTokenAfterLogin() => _registerToken();

  Future<void> _registerToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      final apiClient = Get.find<ApiClient>();
      await apiClient.post(
        path: ApiEndpoints.deviceFcmToken,
        data: {
          'fcm_token': token,
          'device_type': Platform.isIOS ? 'ios' : 'android',
        },
      );
    } catch (_) {}
  }

  Future<void> refreshUnreadCount() async {
    try {
      final apiClient = Get.find<ApiClient>();
      final response =
          await apiClient.get(path: ApiEndpoints.notificationsUnreadCount);
      final raw = response.data as Map<String, dynamic>;
      if (raw['success'] == true) {
        final data = raw['data'] as Map<String, dynamic>;
        unreadCount.value = (data['unread_count'] as num).toInt();
      }
    } catch (_) {}
  }

  void setUnreadCount(int count) => unreadCount.value = count;
  void decrementUnread() {
    if (unreadCount.value > 0) unreadCount.value--;
  }
  void clearUnread() => unreadCount.value = 0;
}
