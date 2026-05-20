import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/service/auth_service.dart';
import '../../../core/service/notification_service.dart';
import '../../../route/app_routes.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/owner_controller.dart';
import '../../listing/model/listing_model.dart';

part 'owner_dashboard_tab.dart';
part 'owner_listing_row.dart';
part 'owner_listings_tab.dart';
part 'owner_messages_tab.dart';
part 'owner_profile_tab.dart';

// ── Root view ─────────────────────────────────────────────────────────────────

class OwnerHomeView extends GetView<OwnerController> {
  const OwnerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return Scaffold(
      backgroundColor: t.bg,
      body: Obx(() {
        final tab = controller.activeTab.value;
        return SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: tab,
                  children: [
                    _DashboardTab(t: t),
                    _MyListingsTab(t: t),
                    _MessagesPlaceholder(t: t),
                    _ProfileTab(t: t),
                  ],
                ),
              ),
              _OwnerBottomNav(t: t, activeTab: tab),
            ],
          ),
        );
      }),
    );
  }
}

// ── Bottom navigation ─────────────────────────────────────────────────────────

class _OwnerBottomNav extends GetView<OwnerController> {
  final FlatNestTheme t;
  final int activeTab;

  const _OwnerBottomNav({required this.t, required this.activeTab});

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavItem(icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart, label: 'Dashboard'),
      _NavItem(icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view, label: 'Listings'),
      _NavItem(icon: Icons.chat_bubble_outline, activeIcon: Icons.chat_bubble, label: 'Messages'),
      _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'You'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        border: Border(top: BorderSide(color: t.borderSoft)),
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              ...List.generate(2, (i) => _navBtn(items[i], i)),
              // FAB-style create button in the center
              Expanded(
                child: GestureDetector(
                  onTap: controller.goToCreateListing,
                  child: Center(
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: t.primary,
                        boxShadow: [
                          BoxShadow(
                            color: t.primary.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ),
              ...List.generate(2, (i) => _navBtn(items[i + 2], i + 2)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navBtn(_NavItem item, int index) {
    final isActive = index == activeTab;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.activeTab.value = index,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? item.activeIcon : item.icon,
              size: 22,
              color: isActive ? t.primary : t.inkSoft,
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? t.primary : t.inkSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}
