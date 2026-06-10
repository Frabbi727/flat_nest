import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../service/auth_service.dart';
import '../../route/app_routes.dart';
import '../../modules/chat/controller/chat_controller.dart';

// Must be top-level for Firebase background processing
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {}

// Must be top-level for flutter_local_notifications background tap handling (Android)
@pragma('vm:entry-point')
void firebaseLocalNotifBackgroundHandler(NotificationResponse details) {}

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
      settings: const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (details) {
        // We don't have the full data map here easily from payload string, 
        // but kind is stored in payload. For now keep it simple.
        _navigateByKind(details.payload);
      },
      onDidReceiveBackgroundNotificationResponse: firebaseLocalNotifBackgroundHandler,
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
      id: message.hashCode,
      title: n.title ?? '',
      body: n.body ?? '',
      notificationDetails: NotificationDetails(
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
    _navigateByKind(kind, message.data);
  }

  void _navigateByKind(String? kind, [Map<String, dynamic>? data]) {
    switch (kind) {
      case 'listing_approved':
      case 'listing_submitted':
      case 'listing_rejected':
      case 'listing_review':
        Get.offAllNamed(Routes.ownerHome);
        break;
      case 'new_chat_request':
      case 'chat_message':
        final chatId = data?['chat_id'] as String?;
        if (chatId != null) {
          // If already in chat controller, try to open it
          if (Get.isRegistered<ChatController>()) {
            final chatController = Get.find<ChatController>();
            // If the chat list is already loaded, find and open it
            final chat = chatController.chats.firstWhereOrNull((c) => c.id == chatId);
            if (chat != null) {
              chatController.openChat(chat);
            } else {
              // Otherwise go to chat list
              Get.toNamed(Routes.chatList);
            }
          } else {
            Get.toNamed(Routes.chatList);
          }
        } else {
          Get.toNamed(Routes.chatList);
        }
        break;
      case 'contact_info_requested':
        Get.toNamed(Routes.ownerAccessRequests);
        break;
      case 'contact_info_granted':
      case 'contact_info_denied':
        final listingId = data?['reference_id'] as String?;
        if (listingId != null) {
          Get.toNamed(Routes.listingDetail, arguments: listingId);
        }
        break;
    }
  }

  /// Call this immediately after login / Google Sign-In.
  Future<void> registerTokenAfterLogin() => _registerToken();

  Future<void> _registerToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;

      final deviceInfo = DeviceInfoPlugin();
      String deviceModel;
      if (Platform.isIOS) {
        final ios = await deviceInfo.iosInfo;
        deviceModel = ios.utsname.machine;
      } else {
        final android = await deviceInfo.androidInfo;
        deviceModel = '${android.manufacturer} ${android.model}';
      }

      final apiClient = Get.find<ApiClient>();
      await apiClient.post(
        path: ApiEndpoints.deviceFcmToken,
        data: {
          'fcm_token': token,
          'device_type': Platform.isIOS ? 'ios' : 'android',
          'device_model': deviceModel,
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
        final count = data['unread_count'];
        unreadCount.value = count is num ? count.toInt() : int.tryParse(count.toString()) ?? 0;
      }
    } catch (_) {}
  }

  void setUnreadCount(int count) => unreadCount.value = count;
  void decrementUnread() {
    if (unreadCount.value > 0) unreadCount.value--;
  }
  void clearUnread() => unreadCount.value = 0;
}
