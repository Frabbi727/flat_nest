import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/service/notification_service.dart';
import '../../../../route/app_routes.dart';
import '../../../../theme/flat_nest_theme.dart';

class DiscoveryTopBar extends StatelessWidget {
  final FlatNestTheme t;
  final String userName;
  final String locationLabel;
  final VoidCallback? onRefreshLocation;
  final bool isRefreshing;

  const DiscoveryTopBar({
    super.key,
    required this.t,
    required this.userName,
    required this.locationLabel,
    this.onRefreshLocation,
    this.isRefreshing = false,
  });

  @override
  Widget build(BuildContext context) {
    final notifService = Get.find<NotificationService>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tappable location row
                GestureDetector(
                  onTap: onRefreshLocation,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      isRefreshing
                          ? SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: t.inkSoft,
                              ),
                            )
                          : Icon(Icons.location_on, size: 18, color: t.inkSoft),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          locationLabel,
                          style: TextStyle(fontSize: 12, color: t.inkSoft),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.refresh_rounded, size: 13, color: t.inkFaint),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Hello, $userName 👋',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: t.ink,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ),
          // Notification bell
          GestureDetector(
            onTap: () => Get.toNamed(Routes.notifications),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: t.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: t.borderSoft),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.notifications_outlined, color: t.ink, size: 20),
                  Obx(() {
                    final count = notifService.unreadCount.value;
                    if (count == 0) return const SizedBox.shrink();
                    return Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: count > 9 ? 14 : 8,
                        height: count > 9 ? 14 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: t.secondary,
                        ),
                        child: count > 9
                            ? Center(
                                child: Text(
                                  '9+',
                                  style: const TextStyle(
                                    fontSize: 7,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: t.primarySoft,
            ),
            child: Center(
              child: Text(
                userName.length >= 2
                    ? userName.substring(0, 2).toUpperCase()
                    : userName.toUpperCase(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: t.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
