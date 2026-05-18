import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/notification_controller.dart';
import '../model/notification_model.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(t: t),
            Expanded(
              child: Obx(() {
                if (controller.isLoading) return _ShimmerList(t: t);

                if (controller.notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.notifications_off_outlined,
                            size: 56, color: t.inkFaint),
                        const SizedBox(height: 14),
                        Text(
                          'No notifications yet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: t.inkSoft,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'You\'ll be notified when something happens.',
                          style: TextStyle(fontSize: 13, color: t.inkFaint),
                        ),
                      ],
                    ),
                  );
                }

                final today = controller.notifications
                    .where((n) => controller.isToday(n.time))
                    .toList();
                final earlier = controller.notifications
                    .where((n) => !controller.isToday(n.time))
                    .toList();

                return RefreshIndicator(
                  onRefresh: controller.loadNotifications,
                  color: t.primary,
                  child: NotificationListener<ScrollEndNotification>(
                    onNotification: (s) {
                      if (s.metrics.extentAfter < 120) controller.loadMore();
                      return false;
                    },
                    child: ListView(
                      children: [
                        if (today.isNotEmpty) ...[
                          _SectionLabel(label: 'Today', t: t),
                          ...today.map((n) => _NotifTile(n: n, t: t)),
                        ],
                        if (earlier.isNotEmpty) ...[
                          _SectionLabel(label: 'Earlier', t: t),
                          ...earlier.map((n) => _NotifTile(n: n, t: t)),
                        ],
                        Obx(() => controller.isLoadingMore.value
                            ? Padding(
                                padding: const EdgeInsets.all(16),
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: t.primary,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink()),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────

class _AppBar extends GetView<NotificationController> {
  final FlatNestTheme t;
  const _AppBar({required this.t});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 4),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: t.ink, size: 18),
            onPressed: Get.back,
          ),
          Expanded(
            child: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: t.ink,
                letterSpacing: -0.3,
              ),
            ),
          ),
          Obx(() {
            if (!controller.notifications.any((n) => n.isUnread)) {
              return const SizedBox.shrink();
            }
            return GestureDetector(
              onTap: controller.markAllRead,
              child: Text(
                'Mark all read',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: t.primary,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final FlatNestTheme t;
  const _SectionLabel({required this.label, required this.t});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: t.inkSoft,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

// ── Notification tile ─────────────────────────────────────────────────────────

class _NotifTile extends GetView<NotificationController> {
  final NotificationModel n;
  final FlatNestTheme t;
  const _NotifTile({required this.n, required this.t});

  IconData _icon() {
    return switch (n.kind) {
      'listing_approved' => Icons.check_circle_outline_rounded,
      'listing_rejected' => Icons.cancel_outlined,
      'listing_submitted' => Icons.upload_rounded,
      'listing_review' => Icons.rate_review_outlined,
      _ => Icons.notifications_outlined,
    };
  }

  Color _iconBg() {
    return switch (n.kind) {
      'listing_approved' => t.successSoft,
      'listing_rejected' => const Color(0xFFFFEBEB),
      'listing_submitted' => t.primarySoft,
      'listing_review' => t.bgAlt,
      _ => t.bgAlt,
    };
  }

  Color _iconColor() {
    return switch (n.kind) {
      'listing_approved' => t.success,
      'listing_rejected' => const Color(0xFFD93636),
      _ => t.primary,
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.markRead(n),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: n.isUnread ? t.primarySoft : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: n.isUnread ? t.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(17, 14, 20, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _iconBg(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_icon(), size: 20, color: _iconColor()),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          n.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: n.isUnread
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: t.ink,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        n.time,
                        style: TextStyle(fontSize: 11, color: t.inkSoft),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    n.body,
                    style: TextStyle(
                      fontSize: 13,
                      color: t.inkMid,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            if (n.isUnread) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: t.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Shimmer skeleton ──────────────────────────────────────────────────────────

class _ShimmerList extends StatelessWidget {
  final FlatNestTheme t;
  const _ShimmerList({required this.t});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0);
    final highlight =
        isDark ? const Color(0xFF3D3D3D) : const Color(0xFFF5F5F5);

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8),
        itemCount: 8,
        itemBuilder: (_, i) => _ShimmerTile(base: base),
      ),
    );
  }
}

class _ShimmerTile extends StatelessWidget {
  final Color base;
  const _ShimmerTile({required this.base});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 10, 20, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: base,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 13,
                    width: double.infinity,
                    color: base,
                    margin: const EdgeInsets.only(bottom: 6)),
                Container(height: 12, width: 200, color: base),
                const SizedBox(height: 6),
                Container(height: 12, width: 140, color: base),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
