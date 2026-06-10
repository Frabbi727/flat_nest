import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../../chat/controller/chat_controller.dart';
import '../../../chat/repository/chat_repository.dart';
import '../../../../theme/flat_nest_theme.dart';
import '../../controller/listing_detail_controller.dart';
import '../../controller/renter_home_controller.dart';
import 'listing_detail_content.dart';
import 'listing_detail_photo_section.dart';
import 'listing_detail_sticky_bar.dart';

class ListingDetailView extends GetView<ListingDetailController> {
  const ListingDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    // Ensure ChatController is available for sticky bar actions
    if (!Get.isRegistered<ChatController>()) {
      Get.lazyPut(() => ChatController(
          chatRepository: ChatRepository(apiClient: Get.find<ApiClient>())));
    }

    return Obx(() {
      final listing = controller.listing.value;

      if (listing == null) {
        return Scaffold(
          backgroundColor: t.bg,
          body: Center(
            child: controller.isLoading
                ? CircularProgressIndicator(color: t.primary)
                : Text('Listing not found', style: TextStyle(color: t.ink)),
          ),
        );
      }

      // Wishlist toggle is owned by RenterHomeController (if available)
      final hasRenterHome = Get.isRegistered<RenterHomeController>();
      final renterHome =
          hasRenterHome ? Get.find<RenterHomeController>() : null;

      return Scaffold(
        backgroundColor: t.bg,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Builder(builder: (_) {
                    if (renterHome == null) {
                      return ListingDetailPhotoSection(
                        t: t,
                        listing: listing,
                        saved: false,
                        isLoading: false,
                        onToggleSave: () {},
                      );
                    }
                    return Obx(() => ListingDetailPhotoSection(
                          t: t,
                          listing: listing,
                          saved: renterHome.isSaved(listing.id),
                          isLoading: renterHome.isToggling(listing.id),
                          onToggleSave: () => renterHome.toggleSave(listing),
                        ));
                  }),
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
    });
  }
}
