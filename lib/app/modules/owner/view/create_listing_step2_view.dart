import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/create_listing_controller.dart';

class CreateListingStep2View extends GetView<CreateListingController> {
  const CreateListingStep2View({super.key});

  Future<void> _pickImages(BuildContext context) async {
    final picker = ImagePicker();
    final remaining = 8 - controller.photos.length;
    if (remaining <= 0) return;

    final picked = await picker.pickMultiImage(imageQuality: 80);
    for (final xfile in picked.take(remaining)) {
      controller.addPhoto(File(xfile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add at least 1 clear photo. The first one is your cover.',
            style: AppTextStyles.bodyMedium.copyWith(color: t.inkMid, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final photos = controller.photos;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 8,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, i) {
                if (i < photos.length) {
                  return _PhotoSlot(
                    t: t,
                    file: photos[i],
                    isCover: i == 0,
                    onRemove: () => controller.removePhoto(i),
                  );
                }
                return _AddSlot(
                  t: t,
                  onTap: () => _pickImages(context),
                );
              },
            );
          }),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: t.warningSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Tip: ',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            color: t.ink,
                          ),
                        ),
                        TextSpan(
                          text: 'Daylight photos with windows open get 3× more inquiries.',
                          style: AppTextStyles.caption.copyWith(color: t.ink),
                        ),
                      ],
                    ),
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

class _PhotoSlot extends StatelessWidget {
  final FlatNestTheme t;
  final File file;
  final bool isCover;
  final VoidCallback onRemove;

  const _PhotoSlot({
    required this.t,
    required this.file,
    required this.isCover,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(file, fit: BoxFit.cover),
          if (isCover)
            Positioned(
              top: 6,
              left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: t.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Cover',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddSlot extends StatelessWidget {
  final FlatNestTheme t;
  final VoidCallback onTap;

  const _AddSlot({required this.t, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: t.bgAlt,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: t.borderSoft, width: 1.5),
        ),
        child: Icon(Icons.add_rounded, color: t.inkSoft, size: 28),
      ),
    );
  }
}
