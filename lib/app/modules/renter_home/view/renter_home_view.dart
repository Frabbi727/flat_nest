import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/renter_home_controller.dart';
import 'discovery/discovery_view.dart';
import 'map/nearby_map_view.dart';
import 'wishlist/wishlist_view.dart';
import '../../chat/view/chat_list_view.dart';
import 'profile/profile_placeholder_view.dart';

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
              NearbyMapView(),
              WishlistView(),
              ChatListView(showBackButton: false),
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
                  onTap: () {
                    if (i > 0) {
                      controller.ensureAuthenticated(
                        () => controller.activeTab.value = i,
                        title: i == 1
                            ? 'Explore Nearby'
                            : i == 2
                                ? 'Save your favorites'
                                : i == 3
                                    ? 'Message owners'
                                    : 'Your Profile',
                        message: i == 1
                            ? 'Log in to see available flats on the map and find homes near you.'
                            : i == 2
                                ? 'Log in to save flats to your wishlist and view them here anytime.'
                                : i == 3
                                    ? 'Log in to message owners, ask questions, and book your new home.'
                                    : 'Log in to manage your profile, view your activity, and access your settings.',
                      );
                    } else {
                      controller.activeTab.value = i;
                    }
                  },
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

