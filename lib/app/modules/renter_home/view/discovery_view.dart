import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/renter_home_controller.dart';
import '../../listing/model/listing_model.dart';
import 'listing_card_widget.dart';
import 'filters_sheet.dart';

class DiscoveryView extends GetView<RenterHomeController> {
  const DiscoveryView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return Scaffold(
      backgroundColor: t.bg,
      body: Obx(
        () => Column(
          children: [
            // TopBar
            _TopBar(
              t: t,
              userName: controller.userName,
              locationLabel: controller.locationLabel.value,
            ),
            // Search + filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SearchBar(
                t: t,
                onFilterTap: () => _openFilters(context, t),
              ),
            ),
            // Reset filter strip — only when filters are active
            if (controller.hasActiveFilters)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Row(
                  children: [
                    Icon(Icons.filter_alt_outlined, size: 14, color: t.primary),
                    const SizedBox(width: 6),
                    Text(
                      'Filters applied',
                      style: TextStyle(fontSize: 12, color: t.inkMid),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: controller.resetFilters,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: t.primarySoft,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.close, size: 12, color: t.primary),
                            const SizedBox(width: 4),
                            Text(
                              'Reset',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: t.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Filter chips (All + API listing types)
            SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: controller.listingTypes.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  if (i == 0) {
                    return _Chip(
                      t: t,
                      label: 'All',
                      active: controller.selectedTypeId.value == null,
                      onTap: () => controller.selectType(null),
                    );
                  }
                  final type = controller.listingTypes[i - 1];
                  return _Chip(
                    t: t,
                    label: type.label,
                    active: controller.selectedTypeId.value == type.id,
                    onTap: () => controller.selectType(type.id),
                  );
                },
              ),
            ),
            // Listings
            Expanded(
              child: controller.isLoading
                  ? Center(child: CircularProgressIndicator(color: t.primary))
                  : controller.listings.isEmpty
                  ? _EmptyState(t: t)
                  : RefreshIndicator(
                      onRefresh: controller.fetchListings,
                      color: t.primary,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                        itemCount: controller.listings.length,
                        itemBuilder: (_, i) {
                          final listing = controller.listings[i];
                          final isFeatured = i == 0;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Obx(() {
                              final saved = controller.isSaved(listing.id);
                              final loading = controller.isToggling(listing.id);
                              return isFeatured
                                  ? _FeaturedCard(
                                      t: t,
                                      listing: listing,
                                      saved: saved,
                                      isLoading: loading,
                                      onToggleSave: () =>
                                          controller.toggleSave(listing),
                                      onTap: () =>
                                          controller.openListing(listing),
                                    )
                                  : ListingCardWidget(
                                      t: t,
                                      listing: listing,
                                      saved: saved,
                                      isLoading: loading,
                                      onToggleSave: () =>
                                          controller.toggleSave(listing),
                                      onTap: () =>
                                          controller.openListing(listing),
                                    );
                            }),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFilters(BuildContext context, FlatNestTheme t) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => FiltersSheet(t: t),
    );
  }
}

class _TopBar extends StatelessWidget {
  final FlatNestTheme t;
  final String userName;
  final String locationLabel;

  const _TopBar({
    required this.t,
    required this.userName,
    required this.locationLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, size: 18, color: t.inkSoft),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        locationLabel,
                        style: TextStyle(fontSize: 12, color: t.inkSoft),
                      ),
                    ),
                  ],
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
          Container(
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
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: t.secondary,
                    ),
                  ),
                ),
              ],
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
                'RK',
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

class _SearchBar extends GetView<RenterHomeController> {
  final FlatNestTheme t;
  final VoidCallback onFilterTap;

  const _SearchBar({required this.t, required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.borderSoft),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(Icons.search, color: t.inkSoft, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller.searchTextController,
              onChanged: (v) => controller.searchQuery.value = v,
              style: TextStyle(color: t.ink, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search flats by area or feature',
                hintStyle: TextStyle(color: t.inkFaint, fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              width: 34,
              height: 34,
              margin: const EdgeInsets.only(right: 7),
              decoration: BoxDecoration(
                color: t.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.tune, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final FlatNestTheme t;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _Chip({
    required this.t,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: active ? t.primary : t.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? t.primary : t.borderSoft),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : t.inkMid,
          ),
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final FlatNestTheme t;
  final ListingModel listing;
  final bool saved;
  final bool isLoading;
  final VoidCallback onToggleSave;
  final VoidCallback onTap;

  const _FeaturedCard({
    required this.t,
    required this.listing,
    required this.saved,
    this.isLoading = false,
    required this.onToggleSave,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: t.ink,
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                'See all',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: t.primary,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: t.primarySoft,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Photo or placeholder
                if (listing.thumbnailUrl != null)
                  Positioned.fill(
                    child: Image.network(
                      listing.thumbnailUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholderImage(t),
                    ),
                  )
                else
                  Positioned.fill(child: _placeholderImage(t)),
                // Gradient overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.55),
                        ],
                        stops: const [0.3, 1.0],
                      ),
                    ),
                  ),
                ),
                // Featured badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: t.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '⭐ Featured',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Heart button
                Positioned(
                  top: 8,
                  right: 8,
                  child: _HeartButton(
                    t: t,
                    saved: saved,
                    isLoading: isLoading,
                    onTap: onToggleSave,
                  ),
                ),
                // Info
                Positioned(
                  bottom: 14,
                  left: 14,
                  right: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (listing.area != null)
                        Text(
                          listing.area!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                            letterSpacing: 0.5,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        listing.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '🛏 ${listing.beds ?? '-'} BR · 🚿 ${listing.baths ?? '-'} Bath',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            '${listing.priceFormatted}/mo',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'All Listings',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: t.ink,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _placeholderImage(FlatNestTheme t) {
    return Container(
      color: t.primarySoft,
      child: Center(
        child: Icon(
          Icons.home_work_rounded,
          size: 64,
          color: t.primary.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

class _HeartButton extends StatelessWidget {
  final FlatNestTheme t;
  final bool saved;
  final bool isLoading;
  final VoidCallback onTap;

  const _HeartButton({
    required this.t,
    required this.saved,
    this.isLoading = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.9),
        ),
        child: isLoading
            ? Padding(
                padding: const EdgeInsets.all(9),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: t.inkSoft,
                ),
              )
            : Icon(
                saved ? Icons.favorite : Icons.favorite_border,
                color: saved ? t.secondary : t.inkSoft,
                size: 18,
              ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final FlatNestTheme t;

  const _EmptyState({required this.t});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 64, color: t.inkFaint),
          const SizedBox(height: 16),
          Text(
            'No listings found',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: t.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing your filters',
            style: TextStyle(fontSize: 13, color: t.inkMid),
          ),
        ],
      ),
    );
  }
}
