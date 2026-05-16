import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/flat_nest_theme.dart';
import '../../../route/app_routes.dart';
import '../../listing/model/listing_model.dart';
import '../controller/renter_home_controller.dart';

class ListingDetailView extends StatefulWidget {
  const ListingDetailView({super.key});

  @override
  State<ListingDetailView> createState() => _ListingDetailViewState();
}

class _ListingDetailViewState extends State<ListingDetailView> {
  int _photoIndex = 0;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;
    final listing = Get.arguments as ListingModel?;

    if (listing == null) {
      return Scaffold(
        backgroundColor: t.bg,
        body: Center(child: Text('Listing not found', style: TextStyle(color: t.ink))),
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
                child: Obx(() => _PhotoSection(
                  t: t,
                  listing: listing,
                  photoIndex: _photoIndex,
                  onPhotoChange: (i) => setState(() => _photoIndex = i),
                  saved: controller.isSaved(listing.id),
                  onToggleSave: () => controller.toggleSave(listing),
                )),
              ),
              SliverToBoxAdapter(child: _ContentSection(t: t, listing: listing)),
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
          // Sticky CTA
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _StickyBar(t: t, listing: listing),
          ),
        ],
      ),
    );
  }
}

class _PhotoSection extends StatelessWidget {
  final FlatNestTheme t;
  final ListingModel listing;
  final int photoIndex;
  final ValueChanged<int> onPhotoChange;
  final bool saved;
  final VoidCallback onToggleSave;

  const _PhotoSection({
    required this.t,
    required this.listing,
    required this.photoIndex,
    required this.onPhotoChange,
    required this.saved,
    required this.onToggleSave,
  });

  @override
  Widget build(BuildContext context) {
    final photos = listing.photos;
    return SizedBox(
      height: 360,
      child: Stack(
        children: [
          // Main photo
          Positioned.fill(
            child: photos.isNotEmpty
                ? Image.network(
                    photos[photoIndex].url,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          // Gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.1), Colors.transparent, Colors.black.withValues(alpha: 0.2)],
                  stops: const [0, 0.4, 1],
                ),
              ),
            ),
          ),
          // Top actions (share, heart)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: Row(
              children: [
                _CircleBtn(
                  icon: Icons.share_outlined,
                  onTap: () {},
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onToggleSave,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.95),
                    ),
                    child: Icon(
                      saved ? Icons.favorite : Icons.favorite_border,
                      color: saved ? t.secondary : t.inkSoft,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Dots + counter
          if (photos.length > 1) ...[
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(photos.length, (i) {
                  return GestureDetector(
                    onTap: () => onPhotoChange(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == photoIndex ? 22 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: i == photoIndex ? Colors.white : Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              bottom: 12,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${photoIndex + 1}/${photos.length}',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: t.primarySoft,
      child: Center(
        child: Icon(Icons.home_work_rounded, size: 80, color: t.primary.withValues(alpha: 0.3)),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.95),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  final FlatNestTheme t;
  final ListingModel listing;

  const _ContentSection({required this.t, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type badge + title + price
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: t.primarySoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        listing.type,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: t.primaryInk),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      listing.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: t.ink,
                        letterSpacing: -0.4,
                        height: 1.25,
                      ),
                    ),
                    if (listing.area != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: t.inkMid),
                          const SizedBox(width: 3),
                          Text(listing.area!, style: TextStyle(fontSize: 13, color: t.inkMid)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    listing.priceFormatted,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: t.ink),
                  ),
                  Text(
                    'per month',
                    style: TextStyle(fontSize: 11, color: t.inkSoft),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Stat strip
          Container(
            decoration: BoxDecoration(
              color: t.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: t.borderSoft),
            ),
            child: Row(
              children: [
                _Stat(icon: '🛏', value: '${listing.beds ?? '-'}', label: 'Bed'),
                _StatDivider(t: t),
                _Stat(icon: '🚿', value: '${listing.baths ?? '-'}', label: 'Bath'),
                _StatDivider(t: t),
                _Stat(icon: '📐', value: listing.size != null ? '${listing.size}' : '-', label: 'ft²'),
                if (listing.deposit != null) ...[
                  _StatDivider(t: t),
                  _Stat(icon: '💰', value: listing.depositFormatted, label: 'Deposit'),
                ],
              ],
            ),
          ),
          // About
          if (listing.description != null) ...[
            const SizedBox(height: 24),
            Text(
              'About this flat',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: t.ink, letterSpacing: -0.2),
            ),
            const SizedBox(height: 8),
            Text(
              listing.description!,
              style: TextStyle(fontSize: 13, color: t.inkMid, height: 1.55),
            ),
          ],
          // Amenities
          if (listing.amenities.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Amenities',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: t.ink, letterSpacing: -0.2),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: listing.amenities
                  .map((a) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: t.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: t.borderSoft),
                        ),
                        child: Text(
                          '✓ ${a.label}',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: t.ink),
                        ),
                      ))
                  .toList(),
            ),
          ],
          // Owner card
          if (listing.owner != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: t.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: t.borderSoft),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: t.primarySoft),
                    child: Center(
                      child: Text(
                        listing.owner!.initials,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: t.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(listing.owner!.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: t.ink)),
                        Text('Owner', style: TextStyle(fontSize: 12, color: t.inkSoft)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Get.toNamed(Routes.chatList),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: t.primarySoft,
                      foregroundColor: t.primaryInk,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Message', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _Stat({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1E))),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF8A8A8E))),
          ],
        ),
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  final FlatNestTheme t;
  const _StatDivider({required this.t});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: VerticalDivider(color: t.borderSoft, width: 1),
    );
  }
}

class _StickyBar extends StatelessWidget {
  final FlatNestTheme t;
  final ListingModel listing;

  const _StickyBar({required this.t, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: t.surface,
        border: Border(top: BorderSide(color: t.borderSoft)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: t.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: t.borderSoft),
            ),
            child: Icon(Icons.phone_outlined, color: t.ink, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => Get.toNamed(Routes.chatList),
              style: ElevatedButton.styleFrom(
                backgroundColor: t.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                '💬 Message Owner',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
