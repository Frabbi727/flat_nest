import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/flat_nest_theme.dart';
import '../../controller/renter_home_controller.dart';
import '../listing/listing_card_widget.dart';

class WishlistView extends GetView<RenterHomeController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return Scaffold(
      backgroundColor: t.bg,
      body:  Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                children: [
                  Text(
                    'Saved flats',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: t.ink,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.tune, color: t.inkMid, size: 20),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final items = controller.wishlistListings;
                if (items.isEmpty) {
                  return _EmptyWishlist(t: t);
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: Text(
                        '${items.length} ${items.length == 1 ? 'flat' : 'flats'}',
                        style: TextStyle(fontSize: 13, color: t.inkSoft),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        itemCount: items.length,
                        itemBuilder: (_, i) {
                          final item = items[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Obx(() => ListingCardWidget(
                              t: t,
                              listing: item,
                              saved: controller.isSaved(item.id),
                              isLoading: controller.isToggling(item.id),
                              onToggleSave: () => controller.toggleSave(item),
                              onTap: () => controller.openListing(item),
                            )),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),

    );
  }
}

class _EmptyWishlist extends StatelessWidget {
  final FlatNestTheme t;

  const _EmptyWishlist({required this.t});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('💔', style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            'Nothing saved yet',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: t.ink,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the heart on any flat to save it here.',
            style: TextStyle(
              fontSize: 13,
              color: t.inkMid,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.find<RenterHomeController>().activeTab.value = 0,
            style: ElevatedButton.styleFrom(
              backgroundColor: t.primarySoft,
              foregroundColor: t.primaryInk,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Browse flats', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
