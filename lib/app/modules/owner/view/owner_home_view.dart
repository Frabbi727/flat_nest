import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/owner_controller.dart';
import '../../listing/model/listing_model.dart';

class OwnerHomeView extends GetView<OwnerController> {
  const OwnerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return Scaffold(
      backgroundColor: t.bg,
      body: Obx(() {
        final tab = controller.activeTab.value;
        return Column(
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
        );
      }),
    );
  }
}

class _OwnerBottomNav extends GetView<OwnerController> {
  final FlatNestTheme t;
  final int activeTab;

  const _OwnerBottomNav({required this.t, required this.activeTab});

  @override
  Widget build(BuildContext context) {
    final items = [
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
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              ...List.generate(2, (i) => _navBtn(items[i], i)),
              // FAB-style center button
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

class _DashboardTab extends GetView<OwnerController> {
  final FlatNestTheme t;
  const _DashboardTab({required this.t});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final kpis = [
        _KPI(label: 'Active listings', value: '${controller.activeCount}', delta: 'this month', kind: 'primary'),
        _KPI(label: 'Total views', value: _fmt(controller.totalViews), delta: '7 days', kind: 'success'),
        _KPI(label: 'Inquiries', value: '${controller.totalInquiries}', delta: 'total', kind: 'warning'),
        _KPI(label: 'Listings', value: '${controller.myListings.length}', delta: 'posted', kind: 'neutral'),
      ];

      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _Header(t: t),
          ),
          // KPIs
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, i) => _KPICard(t: t, kpi: kpis[i]),
                childCount: kpis.length,
              ),
            ),
          ),
          // Post new flat button
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            sliver: SliverToBoxAdapter(
              child: ElevatedButton.icon(
                onPressed: controller.goToCreateListing,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Post a new flat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: t.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
          // Your listings
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Your listings', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: t.ink, letterSpacing: -0.2)),
                  GestureDetector(
                    onTap: () => controller.activeTab.value = 1,
                    child: Text('Manage', style: TextStyle(fontSize: 13, color: t.primary, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ListingRow(t: t, listing: controller.myListings[i]),
                ),
                childCount: controller.myListings.length,
              ),
            ),
          ),
        ],
      );
    });
  }

  String _fmt(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}

class _Header extends GetView<OwnerController> {
  final FlatNestTheme t;
  const _Header({required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 12, 20, 20),
      decoration: BoxDecoration(
        color: t.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back,', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.75))),
                    const SizedBox(height: 2),
                    Text(
                      controller.ownerName,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.4),
                    ),
                  ],
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.18),
                ),
                child: Center(
                  child: Text(
                    controller.ownerInitials,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Revenue mini card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("This week's revenue", style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.75))),
                      const SizedBox(height: 4),
                      const Text('৳1,18,000', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                    ],
                  ),
                ),
                // Mini bar chart
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [12, 18, 22, 28, 34, 30, 44].map((h) {
                    return Container(
                      margin: const EdgeInsets.only(left: 3),
                      width: 5,
                      height: h.toDouble(),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KPI {
  final String label;
  final String value;
  final String delta;
  final String kind;
  const _KPI({required this.label, required this.value, required this.delta, required this.kind});
}

class _KPICard extends StatelessWidget {
  final FlatNestTheme t;
  final _KPI kpi;

  const _KPICard({required this.t, required this.kpi});

  Color get _badgeColor {
    switch (kpi.kind) {
      case 'primary': return t.primarySoft;
      case 'success': return t.successSoft;
      case 'warning': return t.warningSoft;
      default: return t.bgAlt;
    }
  }

  Color get _badgeText {
    switch (kpi.kind) {
      case 'primary': return t.primaryInk;
      case 'success': return t.success;
      case 'warning': return t.warning;
      default: return t.inkMid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.borderSoft),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(kpi.label, style: TextStyle(fontSize: 11, color: t.inkSoft, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(kpi.value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: t.ink, letterSpacing: -0.4)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: _badgeColor, borderRadius: BorderRadius.circular(20)),
            child: Text(kpi.delta, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _badgeText)),
          ),
        ],
      ),
    );
  }
}

class _ListingRow extends StatelessWidget {
  final FlatNestTheme t;
  final OwnerListingModel listing;

  const _ListingRow({required this.t, required this.listing});

  Color get _statusColor {
    switch (listing.status) {
      case 'active': return t.success;
      case 'pending': return t.warning;
      case 'rejected': return t.error;
      case 'rented': return t.primary;
      default: return t.inkSoft;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.borderSoft),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 64,
              height: 64,
              child: listing.thumbnailUrl != null
                  ? Image.network(listing.thumbnailUrl!, fit: BoxFit.cover)
                  : Container(
                      color: t.primarySoft,
                      child: Icon(Icons.home_work_rounded, color: t.primary.withValues(alpha: 0.4), size: 28),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        listing.title,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: t.ink),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        listing.statusLabel,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _statusColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${listing.area ?? 'Unknown'} · ${listing.priceFormatted}/mo',
                  style: TextStyle(fontSize: 11, color: t.inkSoft),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.remove_red_eye_outlined, size: 12, color: t.inkSoft),
                    const SizedBox(width: 3),
                    Text('${listing.views}', style: TextStyle(fontSize: 11, color: t.inkMid)),
                    const SizedBox(width: 12),
                    Icon(Icons.chat_bubble_outline, size: 12, color: t.inkSoft),
                    const SizedBox(width: 3),
                    Text('${listing.inquiries}', style: TextStyle(fontSize: 11, color: t.inkMid)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MyListingsTab extends GetView<OwnerController> {
  final FlatNestTheme t;
  const _MyListingsTab({required this.t});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: t.bg,
      appBar: AppBar(
        backgroundColor: t.bg,
        elevation: 0,
        title: Text('My Listings', style: TextStyle(color: t.ink, fontWeight: FontWeight.w700, fontSize: 20)),
        actions: [
          IconButton(
            onPressed: controller.goToCreateListing,
            icon: Icon(Icons.add, color: t.primary),
          ),
        ],
      ),
      body: Obx(() => controller.isLoading
          ? Center(child: CircularProgressIndicator(color: t.primary))
          : controller.myListings.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.home_work_outlined, size: 64, color: t.inkFaint),
                      const SizedBox(height: 16),
                      Text('No listings yet', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: t.ink)),
                      const SizedBox(height: 8),
                      Text('Post your first flat to get started.', style: TextStyle(fontSize: 13, color: t.inkMid)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: controller.goToCreateListing,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: t.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Post a flat'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                  itemCount: controller.myListings.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ListingRow(t: t, listing: controller.myListings[i]),
                  ),
                )),
    );
  }
}

class _MessagesPlaceholder extends StatelessWidget {
  final FlatNestTheme t;
  const _MessagesPlaceholder({required this.t});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: t.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: t.inkFaint),
            const SizedBox(height: 16),
            Text('Messages', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: t.ink)),
            const SizedBox(height: 8),
            Text('Renter inquiries will appear here.', style: TextStyle(fontSize: 13, color: t.inkMid)),
          ],
        ),
      ),
    );
  }
}

class _ProfileTab extends GetView<OwnerController> {
  final FlatNestTheme t;
  const _ProfileTab({required this.t});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(shape: BoxShape.circle, color: t.primarySoft),
                child: Center(
                  child: Text(
                    controller.ownerInitials,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: t.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(controller.ownerName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: t.ink)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: t.primarySoft, borderRadius: BorderRadius.circular(20)),
                child: Text('Owner', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: t.primaryInk)),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: controller.logout,
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: t.errorSoft,
                  foregroundColor: t.error,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
