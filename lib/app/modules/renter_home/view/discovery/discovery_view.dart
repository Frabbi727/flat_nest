import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/flat_nest_theme.dart';
import '../../controller/renter_home_controller.dart';
import 'discovery_empty_state.dart';
import 'discovery_top_bar.dart';
import 'discovery_type_chip.dart';
import '../listing/featured_card_widget.dart';
import '../listing/listing_shimmer_card.dart';
import 'filters_sheet.dart';
import '../listing/listing_card_widget.dart';

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
            DiscoveryTopBar(
              t: t,
              userName: controller.userName,
              locationLabel: controller.locationLabel.value,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SearchBar(
                t: t,
                onFilterTap: () => _openFilters(context, t),
              ),
            ),
            // Active filter strip
            if (controller.hasActiveFilters) _ActiveFilterStrip(t: t),
            // Listing type chips
            SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                scrollDirection: Axis.horizontal,
                itemCount: controller.listingTypes.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  if (i == 0) {
                    return DiscoveryTypeChip(
                      t: t,
                      label: 'All',
                      active: controller.selectedTypeId.value == null,
                      onTap: () => controller.selectType(null),
                    );
                  }
                  final type = controller.listingTypes[i - 1];
                  return DiscoveryTypeChip(
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
                  ? _ShimmerList(t: t)
                  : controller.listings.isEmpty
                      ? DiscoveryEmptyState(t: t)
                      : RefreshIndicator(
                          onRefresh: controller.fetchListings,
                          color: t.primary,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                            itemCount: controller.listings.length,
                            itemBuilder: (_, i) {
                              final listing = controller.listings[i];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Obx(() {
                                  final saved = controller.isSaved(listing.id);
                                  final loading =
                                      controller.isToggling(listing.id);
                                  if (i == 0) {
                                    return FeaturedCard(
                                      t: t,
                                      listing: listing,
                                      saved: saved,
                                      isLoading: loading,
                                      onToggleSave: () =>
                                          controller.toggleSave(listing),
                                      onTap: () =>
                                          controller.openListing(listing),
                                    );
                                  }
                                  return ListingCardWidget(
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

// ── Shimmer skeleton list ─────────────────────────────────────────────────────

class _ShimmerList extends StatelessWidget {
  final FlatNestTheme t;

  const _ShimmerList({required this.t});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      itemCount: 5,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: i == 0
            ? FeaturedShimmerCard(t: t)
            : ListingShimmerCard(t: t),
      ),
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────

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

// ── Active filter strip ───────────────────────────────────────────────────────

class _ActiveFilterStrip extends GetView<RenterHomeController> {
  final FlatNestTheme t;

  const _ActiveFilterStrip({required this.t});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          Icon(Icons.filter_alt_outlined, size: 14, color: t.primary),
          const SizedBox(width: 6),
          Text('Filters applied', style: TextStyle(fontSize: 12, color: t.inkMid)),
          const Spacer(),
          GestureDetector(
            onTap: controller.resetFilters,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
    );
  }
}
