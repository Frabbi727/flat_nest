import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/renter_home_controller.dart';
import 'discovery_view.dart';
import 'wishlist_view.dart';
import 'messages_placeholder_view.dart';
import 'profile_placeholder_view.dart';

class RenterHomeView extends GetView<RenterHomeController> {
  const RenterHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return Obx(() {
      final tab = controller.activeTab.value;
      return Scaffold(
        backgroundColor: t.bg,
        body: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: tab,
            children: const [
              DiscoveryView(),
              _MapPlaceholder(),
              WishlistView(),
              MessagesPlaceholderView(),
              ProfilePlaceholderView(),
            ],
          ),
        ),
        bottomNavigationBar: _BottomNav(t: t, activeTab: tab),
      );
    });
  }
}

class _BottomNav extends GetView<RenterHomeController> {
  final FlatNestTheme t;
  final int activeTab;

  const _BottomNav({required this.t, required this.activeTab});

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
      _NavItem(icon: Icons.map_outlined, activeIcon: Icons.map, label: 'Map'),
      _NavItem(icon: Icons.favorite_outline, activeIcon: Icons.favorite, label: 'Saved'),
      _NavItem(icon: Icons.chat_bubble_outline, activeIcon: Icons.chat_bubble, label: 'Messages'),
      _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'You'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        border: Border(top: BorderSide(color: t.borderSoft, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(items.length, (i) {
              final item = items[i];
              final isActive = i == activeTab;
              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.activeTab.value = i,
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
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;
    return Scaffold(
      backgroundColor: t.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined, size: 64, color: t.inkFaint),
            const SizedBox(height: 16),
            Text('Map view', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: t.ink)),
            const SizedBox(height: 8),
            Text('Coming soon', style: TextStyle(fontSize: 13, color: t.inkMid)),
          ],
        ),
      ),
    );
  }
}
