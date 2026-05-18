import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/flat_nest_theme.dart';
import '../../../listing/model/listing_model.dart';
import '../../controller/renter_home_controller.dart';
import 'listing_detail_content.dart';
import 'listing_detail_photo_section.dart';
import 'listing_detail_sticky_bar.dart';

class ListingDetailView extends StatelessWidget {
  const ListingDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;
    final listing = Get.arguments as ListingModel?;

    if (listing == null) {
      return Scaffold(
        backgroundColor: t.bg,
        body: Center(
          child: Text('Listing not found', style: TextStyle(color: t.ink)),
        ),
      );
    }

    final controller = Get.find<RenterHomeController>();

    return Scaffold(
      backgroundColor: t.bg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Obx(() => ListingDetailPhotoSection(
                      t: t,
                      listing: listing,
                      saved: controller.isSaved(listing.id),
                      isLoading: controller.isToggling(listing.id),
                      onToggleSave: () => controller.toggleSave(listing),
                    )),
              ),
              SliverToBoxAdapter(
                child: ListingDetailContent(t: t, listing: listing),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 110)),
            ],
          ),
          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.95),
                ),
                child: const Icon(Icons.arrow_back_ios_new, size: 16),
              ),
            ),
          ),
          // Sticky CTA bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ListingDetailStickyBar(t: t, listing: listing),
          ),
        ],
      ),
    );
  }
}
