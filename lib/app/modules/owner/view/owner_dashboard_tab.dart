part of 'owner_home_view.dart';

// ── Dashboard tab ─────────────────────────────────────────────────────────────

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
          SliverToBoxAdapter(child: _Header(t: t)),
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
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            sliver: SliverToBoxAdapter(
              child: _ContactRequestsCard(t: t),
            ),
          ),
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

// ── Dashboard header ──────────────────────────────────────────────────────────

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
              GestureDetector(
                onTap: () => Get.toNamed(Routes.notifications),
                child: Obx(() {
                  final count = Get.find<NotificationService>().unreadCount.value;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                        child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
                      ),
                      if (count > 0)
                        Positioned(
                          top: -2,
                          right: 8,
                          child: Container(
                            padding: count > 9 ? const EdgeInsets.symmetric(horizontal: 3, vertical: 1) : null,
                            width: count > 9 ? null : 14,
                            height: 14,
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(7)),
                            child: Center(
                              child: Text(
                                count > 9 ? '9+' : '$count',
                                style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.18)),
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
            Container(height: 180, width: double.infinity, color: t.borderSoft),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.35,
                children: List.generate(4, (_) => Container(
                  decoration: BoxDecoration(color: t.borderSoft, borderRadius: BorderRadius.circular(16)),
                )),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SBox(t: t, w: double.infinity, h: 48, radius: 12),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SBox(t: t, w: 120, h: 14),
            ),
            const SizedBox(height: 12),
            ...List.generate(3, (_) => Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Container(
                height: 88,
                decoration: BoxDecoration(color: t.borderSoft, borderRadius: BorderRadius.circular(16)),
              ),
            )),
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
      decoration: BoxDecoration(color: t.borderSoft, borderRadius: BorderRadius.circular(radius)),
    );
  }
}

// ── KPI card ──────────────────────────────────────────────────────────────────

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

// ── Contact requests card ─────────────────────────────────────────────────────

class _ContactRequestsCard extends StatelessWidget {
  final FlatNestTheme t;
  const _ContactRequestsCard({required this.t});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.ownerAccessRequests),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: t.borderSoft),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: t.warningSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.contacts_outlined, size: 20, color: t.warning),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Requests',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: t.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Renters requesting your contact info',
                    style: TextStyle(fontSize: 12, color: t.inkSoft),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: t.inkSoft),
          ],
        ),
      ),
    );
  }
}
