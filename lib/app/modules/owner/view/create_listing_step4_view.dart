import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/create_listing_controller.dart';

class CreateListingStep4View extends GetView<CreateListingController> {
  const CreateListingStep4View({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Looks good? Submit to publish. We\'ll review within 24h.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: t.inkMid,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          _PreviewCard(t: t),
          const SizedBox(height: 16),
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

class _PreviewCard extends GetView<CreateListingController> {
  final FlatNestTheme t;

  const _PreviewCard({required this.t});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final photos = controller.photos;
      final title = controller.titleController.text.trim();
      final type = controller.selectedType.value;
      final price = controller.priceController.text.trim();
      final beds = controller.bedsController.text.trim();
      final baths = controller.bathsController.text.trim();
      final area = controller.union.value ?? 'Location not set';

      return Container(
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: t.borderSoft),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo
            AspectRatio(
              aspectRatio: 16 / 9,
              child: photos.isNotEmpty
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(photos.first, fit: BoxFit.cover),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: t.primary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              type,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      color: t.bgAlt,
                      child: Center(
                        child: Icon(Icons.image_rounded,
                            color: t.inkSoft, size: 40),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (photos.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: t.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        type,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  Text(
                    title.isEmpty ? 'Untitled Listing' : title,
                    style: AppTextStyles.h2.copyWith(
                      color: t.ink,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                          size: 13, color: t.inkSoft),
                      const SizedBox(width: 3),
                      Text(
                        area,
                        style: AppTextStyles.caption
                            .copyWith(color: t.inkSoft, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _Stat(t: t, icon: Icons.bed_rounded, label: '$beds bd'),
                      const SizedBox(width: 14),
                      _Stat(
                          t: t,
                          icon: Icons.bathtub_rounded,
                          label: '$baths ba'),
                      const Spacer(),
                      Text(
                        price.isEmpty ? '—' : '৳$price /mo',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: t.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _Stat extends StatelessWidget {
  final FlatNestTheme t;
  final IconData icon;
  final String label;

  const _Stat({required this.t, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: t.inkSoft),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: t.inkMid,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
