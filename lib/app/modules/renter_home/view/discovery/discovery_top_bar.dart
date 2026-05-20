import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/service/notification_service.dart';
import '../../../../route/app_routes.dart';
import '../../../../theme/flat_nest_theme.dart';

class DiscoveryTopBar extends StatelessWidget {
  final FlatNestTheme t;
  final String locationLabel;
  final VoidCallback? onRefreshLocation;
  final bool isRefreshing;

  const DiscoveryTopBar({
    super.key,
    required this.t,
    required this.locationLabel,
    this.onRefreshLocation,
    this.isRefreshing = false,
  });

  @override
  Widget build(BuildContext context) {
    final notifService = Get.find<NotificationService>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onRefreshLocation,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: t.borderSoft),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 16, color: t.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        locationLabel,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: t.ink,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    isRefreshing
                        ? SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: t.primary,
                            ),
                          )
                        : Icon(Icons.refresh_rounded, size: 16, color: t.inkSoft),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Notification bell
          GestureDetector(
            onTap: () => Get.toNamed(Routes.notifications),
            child: Container(
              width: 42,
              height: 42,
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
                            ? const Center(
                                child: Text(
                                  '9+',
                                  style: TextStyle(
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
        ],
      ),
    );
  }
}
