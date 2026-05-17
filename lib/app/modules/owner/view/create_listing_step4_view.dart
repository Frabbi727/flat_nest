import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/create_listing_controller.dart';

class CreateListingStep4View extends GetView<CreateListingController> {
  const CreateListingStep4View({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    final isEdit = controller.editMode;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEdit
                ? 'Review your changes before saving.'
                : 'Looks good? Submit to publish. We\'ll review within 24h.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: t.inkMid,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // ── Photos ──────────────────────────────────────────────────────
          _PhotoStrip(t: t),
          const SizedBox(height: 16),

          // ── Listing details ─────────────────────────────────────────────
          _Section(
            t: t,
            icon: Icons.apartment_rounded,
            title: 'Listing details',
            child: _DetailsCard(t: t),
          ),
          const SizedBox(height: 12),

          // ── Location ────────────────────────────────────────────────────
          _Section(
            t: t,
            icon: Icons.location_on_rounded,
            title: 'Location',
            child: _LocationCard(t: t),
          ),
          const SizedBox(height: 12),

          // ── What happens next ───────────────────────────────────────────
          if (!isEdit)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: t.primarySoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What happens next?',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: t.primaryInk,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'We\'ll verify your details and your flat goes live within a day. You\'ll get a push notification and email when it\'s approved.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: t.primaryInk,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ── Photo strip ───────────────────────────────────────────────────────────────

class _PhotoStrip extends GetView<CreateListingController> {
  final FlatNestTheme t;
  const _PhotoStrip({required this.t});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final existing = controller.existingPhotos;
      final newPhotos = controller.photos;
      final total = existing.length + newPhotos.length;

      if (total == 0) {
      return Container(
        height: 140,
        decoration: BoxDecoration(
          color: t.bgAlt,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: t.borderSoft),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.image_outlined, color: t.inkFaint, size: 32),
              const SizedBox(height: 6),
              Text('No photos added',
                  style: TextStyle(fontSize: 13, color: t.inkSoft)),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: total,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final isFirst = i == 0;
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 4 / 3,
                      child: i < existing.length
                          ? Image.network(
                              existing[i].url,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: t.bgAlt,
                                child: Icon(Icons.broken_image_rounded,
                                    color: t.inkFaint),
                              ),
                            )
                          : Image.file(
                              newPhotos[i - existing.length],
                              fit: BoxFit.cover,
                            ),
                    ),
                    if (isFirst)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: t.primary,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'Cover',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$total photo${total == 1 ? '' : 's'}',
          style: AppTextStyles.caption.copyWith(color: t.inkSoft, fontSize: 11),
        ),
      ],
    );
    });
  }
}

// ── Details card ──────────────────────────────────────────────────────────────

class _DetailsCard extends GetView<CreateListingController> {
  final FlatNestTheme t;
  const _DetailsCard({required this.t});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final c = controller;
      final price = c.priceController.text.trim();
      final deposit = c.depositController.text.trim();
      final beds = c.bedsController.text.trim();
      final baths = c.bathsController.text.trim();
      final size = c.sizeController.text.trim();
      final desc = c.descController.text.trim();
      final type = c.selectedType.value;
      final amenities = c.amenities
          .where((a) => c.selectedAmenities.contains(a.id))
          .toList();

      return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Type badge + title
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: t.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                type.isEmpty ? '—' : type,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                c.titleController.text.trim().isEmpty
                    ? 'Untitled Listing'
                    : c.titleController.text.trim(),
                style: AppTextStyles.h2.copyWith(color: t.ink, fontSize: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Price + deposit row
        Row(
          children: [
            _DetailChip(
              t: t,
              icon: Icons.payments_rounded,
              label: price.isEmpty ? '—' : '৳$price /mo',
              highlight: true,
            ),
            if (deposit.isNotEmpty) ...[
              const SizedBox(width: 8),
              _DetailChip(
                t: t,
                icon: Icons.account_balance_wallet_rounded,
                label: 'Deposit ৳$deposit',
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        // Beds / baths / size row
        Row(
          children: [
            _DetailChip(
                t: t, icon: Icons.bed_rounded, label: '$beds bd'),
            const SizedBox(width: 8),
            _DetailChip(
                t: t, icon: Icons.bathtub_rounded, label: '$baths ba'),
            if (size.isNotEmpty) ...[
              const SizedBox(width: 8),
              _DetailChip(
                  t: t,
                  icon: Icons.square_foot_rounded,
                  label: '$size sqft'),
            ],
          ],
        ),
        if (desc.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            desc,
            style: AppTextStyles.bodySmall
                .copyWith(color: t.inkMid, height: 1.5, fontSize: 13),
          ),
        ],
        if (amenities.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: amenities
                .map((a) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: t.primarySoft,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        a.name,
                        style: TextStyle(
                            fontSize: 11,
                            color: t.primaryInk,
                            fontWeight: FontWeight.w600),
                      ),
                    ))
                .toList(),
          ),
        ],
      ],
      );
    });
  }
}

// ── Location card ─────────────────────────────────────────────────────────────

class _LocationCard extends GetView<CreateListingController> {
  final FlatNestTheme t;
  const _LocationCard({required this.t});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final c = controller;
      final breadcrumb = [
        c.division.value,
        c.district.value,
        c.upazila.value,
        c.union.value,
      ].whereType<String>().join(' › ');
      final roadHouse = c.roadAndHouse.text.trim();
      final lat = c.lat.value;
      final lng = c.lng.value;
      final hasPin = lat != null && lng != null;

      return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Breadcrumb
        if (breadcrumb.isNotEmpty)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.place_rounded, size: 16, color: t.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  breadcrumb,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: t.ink,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        if (roadHouse.isNotEmpty) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.home_rounded, size: 15, color: t.inkSoft),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  roadHouse,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: t.inkMid, fontSize: 13),
                ),
              ),
            ],
          ),
        ],
        if (breadcrumb.isEmpty && roadHouse.isEmpty)
          Text(
            'No location added',
            style: TextStyle(fontSize: 13, color: t.inkFaint),
          ),

        // Mini map
        if (hasPin) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 180,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(lat, lng),
                  initialZoom: 15,
                  interactionOptions:
                      const InteractionOptions(flags: InteractiveFlag.none),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.fatnest.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(lat, lng),
                        width: 40,
                        height: 44,
                        child: Column(
                          children: [
                            Icon(Icons.location_on_rounded,
                                color: t.primary, size: 32),
                            Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color:
                                      t.primary.withValues(alpha: 0.4),
                                  shape: BoxShape.circle,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}',
            style: TextStyle(
              fontSize: 11,
              color: t.inkSoft,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ],
      );
    });
  }
}

// ── Shared widgets ─────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final FlatNestTheme t;
  final IconData icon;
  final String title;
  final Widget child;

  const _Section({
    required this.t,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: t.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: t.primary),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTextStyles.bodySmall.copyWith(
                  color: t.inkMid,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final FlatNestTheme t;
  final IconData icon;
  final String label;
  final bool highlight;

  const _DetailChip({
    required this.t,
    required this.icon,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: highlight ? t.primarySoft : t.bgAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: highlight
              ? t.primary.withValues(alpha: 0.3)
              : t.borderSoft,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 13,
              color: highlight ? t.primary : t.inkSoft),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: highlight ? t.primaryInk : t.inkMid,
            ),
          ),
        ],
      ),
    );
  }
}
