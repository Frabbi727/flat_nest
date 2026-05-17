import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
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
        bottom: false,
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
      if (controller.isLoading) return _DashboardShimmer(t: t);

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
                childAspectRatio: 1.35,
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

// ── Dashboard shimmer ─────────────────────────────────────────────────────────

class _DashboardShimmer extends StatelessWidget {
  final FlatNestTheme t;
  const _DashboardShimmer({required this.t});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: t.borderSoft,
      highlightColor: t.surface,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header skeleton
            Container(
              height: 180,
              width: double.infinity,
              color: t.borderSoft,
            ),
            const SizedBox(height: 20),

            // KPI grid skeleton
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.35,
                children: List.generate(
                  4,
                  (_) => Container(
                    decoration: BoxDecoration(
                      color: t.borderSoft,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Button skeleton
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SBox(t: t, w: double.infinity, h: 48, radius: 12),
            ),
            const SizedBox(height: 24),

            // Section title skeleton
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SBox(t: t, w: 120, h: 14),
            ),
            const SizedBox(height: 12),

            // Listing row skeletons
            ...List.generate(
              3,
              (_) => Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Container(
                  height: 88,
                  decoration: BoxDecoration(
                    color: t.borderSoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SBox extends StatelessWidget {
  final FlatNestTheme t;
  final double w;
  final double h;
  final double radius;

  const _SBox({required this.t, required this.w, required this.h, this.radius = 6});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w == double.infinity ? null : w,
      height: h,
      decoration: BoxDecoration(
        color: t.borderSoft,
        borderRadius: BorderRadius.circular(radius),
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

Widget _imgPlaceholder(FlatNestTheme t) => Container(
      color: t.primarySoft,
      child: Icon(Icons.home_work_rounded,
          color: t.primary.withValues(alpha: 0.4), size: 28),
    );

class _ListingRow extends GetView<OwnerController> {
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
    final hasActions = listing.status == 'draft' ||
        listing.status == 'active' ||
        listing.status == 'rejected';

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.borderSoft),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status accent bar
            Container(width: 4, color: _statusColor),
            // Card content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main info row
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 64,
                            height: 64,
                            child: listing.thumbnailUrl != null
                                ? Image.network(
                                    listing.thumbnailUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _imgPlaceholder(t),
                                    loadingBuilder: (_, child, progress) =>
                                        progress == null
                                            ? child
                                            : _imgPlaceholder(t),
                                  )
                                : _imgPlaceholder(t),
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
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: t.ink),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: _statusColor.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      listing.statusLabel,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: _statusColor),
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
                                  Icon(Icons.remove_red_eye_outlined,
                                      size: 12, color: t.inkSoft),
                                  const SizedBox(width: 3),
                                  Text('${listing.views}',
                                      style: TextStyle(
                                          fontSize: 11, color: t.inkMid)),
                                  const SizedBox(width: 12),
                                  Icon(Icons.chat_bubble_outline,
                                      size: 12, color: t.inkSoft),
                                  const SizedBox(width: 3),
                                  Text('${listing.inquiries}',
                                      style: TextStyle(
                                          fontSize: 11, color: t.inkMid)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Availability, floor, facing
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _SmallInfoTag(
                          text: '📅 ${listing.availableFromFormatted}',
                          bgColor: listing.isAvailableNow ? t.successSoft : t.bgAlt,
                          textColor: listing.isAvailableNow ? t.success : t.inkMid,
                        ),
                        if (listing.floorNo != null)
                          _SmallInfoTag(text: '🏢 Floor ${listing.floorNo}', bgColor: t.bgAlt, textColor: t.inkMid),
                        if (listing.facing != null)
                          _SmallInfoTag(text: '🧭 ${listing.facing!.label}', bgColor: t.bgAlt, textColor: t.inkMid),
                      ],
                    ),

                    // Address sub-section
                    if (listing.road != null || listing.houseName != null || listing.block != null || listing.section != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 12, color: t.inkSoft),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              [
                                if (listing.road != null) listing.road!,
                                if (listing.houseName != null) listing.houseName!,
                                if (listing.block != null) 'Block ${listing.block}',
                                if (listing.section != null) 'Section ${listing.section}',
                              ].join(', '),
                              style: TextStyle(fontSize: 10, color: t.inkMid),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],

                    // Owner contact sub-section
                    if (listing.ownerName != null || listing.ownerPhone != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.person_outline, size: 12, color: t.inkSoft),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              [
                                if (listing.ownerName != null) listing.ownerName!,
                                if (listing.ownerPhone != null) listing.ownerPhone!,
                              ].join(' · '),
                              style: TextStyle(fontSize: 10, color: t.inkMid),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (listing.preferredContact != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: t.primarySoft,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _contactLabel(listing.preferredContact!),
                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: t.primaryInk),
                              ),
                            ),
                        ],
                      ),
                    ],

                    // Pending banner
                    if (listing.status == 'pending') ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: t.warningSoft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.hourglass_top_rounded,
                                size: 14, color: t.warning),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Your listing is under review. You\'ll be notified once it\'s approved.',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: t.warning,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Rejection banner
                    if (listing.status == 'rejected') ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: t.errorSoft,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: t.error.withValues(alpha: 0.25)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.cancel_outlined,
                                    size: 14, color: t.error),
                                const SizedBox(width: 6),
                                Text(
                                  'Admin note:',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: t.error),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              listing.rejectionReason ??
                                  'Your listing was rejected. Please fix the issues and resubmit.',
                              style: TextStyle(
                                  fontSize: 12, color: t.error, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Action row
                    if (hasActions) ...[
                      const SizedBox(height: 10),
                      _buildActions(context),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _contactLabel(String contact) => switch (contact) {
    'whatsapp' => 'WhatsApp',
    'both' => 'Call/WA',
    _ => 'Call',
  };

  Widget _buildActions(BuildContext context) {
    switch (listing.status) {
      case 'draft':
        return _actionBtn(
          label: 'Continue',
          icon: Icons.arrow_forward_rounded,
          color: t.primary,
          onTap: () => controller.continueDraft(listing),
        );
      case 'active':
        return Row(
          children: [
            _actionBtn(
              label: 'Edit',
              icon: Icons.edit_rounded,
              color: t.inkMid,
              onTap: () => _onEdit(context),
            ),
            const SizedBox(width: 8),
            _actionBtn(
              label: 'Mark as Rented',
              icon: Icons.check_circle_outline,
              color: t.success,
              onTap: () => _onMarkRented(context),
            ),
          ],
        );
      case 'rejected':
        return _actionBtn(
          label: 'Fix & Resubmit',
          icon: Icons.replay_rounded,
          color: t.error,
          onTap: () => controller.fixAndResubmit(listing),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _actionBtn({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onEdit(BuildContext context) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Text('Save changes?',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            content: const Text(
              'Saving changes will temporarily hide your listing until it\'s re-approved by admin. Continue?',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Continue'),
              ),
            ],
          ),
        ) ??
        false;
    if (confirmed) controller.navigateToEdit(listing);
  }

  Future<void> _onMarkRented(BuildContext context) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Text('Mark as Rented?',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            content: const Text(
              'This will mark your listing as rented and remove it from public search. This action cannot be undone.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: t.success,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Mark as Rented'),
              ),
            ],
          ),
        ) ??
        false;
    if (confirmed) controller.markRented(listing.id);
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
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return Center(child: CircularProgressIndicator(color: t.primary));
              }
              if (controller.myListings.isEmpty) {
                return Center(
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
                );
              }
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification &&
                      notification.metrics.extentAfter < 200) {
                    controller.loadMoreListings();
                  }
                  return false;
                },
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                  itemCount: controller.myListings.length + 1,
                  itemBuilder: (_, i) {
                    if (i == controller.myListings.length) {
                      return Obx(() => controller.isLoadingMore.value
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator(color: t.primary)),
                            )
                          : const SizedBox.shrink());
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ListingRow(t: t, listing: controller.myListings[i]),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      color: t.surface,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      child: Obx(() {
        final currentStatus = controller.filterStatus.value;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _statusChip('All', null, currentStatus == null),
              const SizedBox(width: 6),
              _statusChip('Active', 'active', currentStatus == 'active'),
              const SizedBox(width: 6),
              _statusChip('Pending', 'pending', currentStatus == 'pending'),
              const SizedBox(width: 6),
              _statusChip('Draft', 'draft', currentStatus == 'draft'),
              const SizedBox(width: 6),
              _statusChip('Rejected', 'rejected', currentStatus == 'rejected'),
              const SizedBox(width: 6),
              _statusChip('Rented', 'rented', currentStatus == 'rented'),
            ],
          ),
        );
      }),
    );
  }

  Widget _statusChip(String label, String? status, bool active) {
    return GestureDetector(
      onTap: () => controller.applyOwnerFilters(
        status: status,
        typeId: controller.filterTypeId.value,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? t.primary : t.bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? t.primary : t.borderSoft),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : t.inkMid,
          ),
        ),
      ),
    );
  }
}

class _SmallInfoTag extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;

  const _SmallInfoTag({required this.text, required this.bgColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: textColor)),
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
      body:  Center(
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

    );
  }
}
