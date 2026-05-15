import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/create_listing_controller.dart';

class CreateListingStep1View extends GetView<CreateListingController> {
  const CreateListingStep1View({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return Obx(() {
      if (controller.typesLoading.value) {
        return _Step1Shimmer(t: t);
      }
      return _Step1Form(t: t, controller: controller);
    });
  }
}

// ── Full-page shimmer skeleton ─────────────────────────────────────────────

class _Step1Shimmer extends StatelessWidget {
  final FlatNestTheme t;
  const _Step1Shimmer({required this.t});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: t.borderSoft,
      highlightColor: t.surface,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title label + input
            _SBox(t: t, w: 80, h: 12),
            const SizedBox(height: 8),
            _SBox(t: t, w: double.infinity, h: 48, radius: 10),
            const SizedBox(height: 18),

            // Type label + chips
            _SBox(t: t, w: 40, h: 12),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [72.0, 88.0, 64.0, 80.0, 70.0]
                  .map((w) => _SBox(t: t, w: w, h: 32, radius: 20))
                  .toList(),
            ),
            const SizedBox(height: 18),

            // Rent + Deposit row
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _SBox(t: t, w: 80, h: 12),
                const SizedBox(height: 8),
                _SBox(t: t, w: double.infinity, h: 48, radius: 10),
              ])),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _SBox(t: t, w: 60, h: 12),
                const SizedBox(height: 8),
                _SBox(t: t, w: double.infinity, h: 48, radius: 10),
              ])),
            ]),
            const SizedBox(height: 18),

            // Beds + Baths + Size row
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _SBox(t: t, w: 64, h: 12),
                const SizedBox(height: 8),
                _SBox(t: t, w: double.infinity, h: 48, radius: 10),
              ])),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _SBox(t: t, w: 40, h: 12),
                const SizedBox(height: 8),
                _SBox(t: t, w: double.infinity, h: 48, radius: 10),
              ])),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _SBox(t: t, w: 36, h: 12),
                const SizedBox(height: 8),
                _SBox(t: t, w: double.infinity, h: 48, radius: 10),
              ])),
            ]),
            const SizedBox(height: 18),

            // Description label + textarea
            _SBox(t: t, w: 80, h: 12),
            const SizedBox(height: 8),
            _SBox(t: t, w: double.infinity, h: 100, radius: 10),
            const SizedBox(height: 18),

            // Amenities label + chips
            _SBox(t: t, w: 70, h: 12),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [56.0, 72.0, 48.0, 80.0, 88.0, 60.0, 64.0, 76.0, 52.0]
                  .map((w) => _SBox(t: t, w: w, h: 30, radius: 20))
                  .toList(),
            ),
            const SizedBox(height: 20),
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
      decoration: BoxDecoration(
        color: t.borderSoft,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ── Real form (shown after data loads) ────────────────────────────────────

class _Step1Form extends StatelessWidget {
  final FlatNestTheme t;
  final CreateListingController controller;

  const _Step1Form({required this.t, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FormGroup(
            t: t,
            label: 'Listing title',
            child: _Input(t: t, controller: controller.titleController, hint: 'e.g. Sunlit 2BR in Banani'),
          ),
          _FormGroup(
            t: t,
            label: 'Type',
            child: Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.listingTypes.map((type) {
                    final active = controller.selectedTypeId.value == type.id;
                    return GestureDetector(
                      onTap: () => controller.pickListingType(type),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: active ? t.primary : t.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: active ? t.primary : t.borderSoft),
                        ),
                        child: Text(
                          type.label,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: active ? Colors.white : t.ink,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )),
          ),
          Row(
            children: [
              Expanded(
                child: _FormGroup(
                  t: t,
                  label: 'Monthly rent',
                  child: _Input(t: t, controller: controller.priceController, hint: '28,000', prefix: '৳', suffix: '/mo', keyboardType: TextInputType.number),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FormGroup(
                  t: t,
                  label: 'Deposit',
                  child: _Input(t: t, controller: controller.depositController, hint: '56,000', prefix: '৳', keyboardType: TextInputType.number),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _FormGroup(
                  t: t,
                  label: 'Bedrooms',
                  child: _Input(t: t, controller: controller.bedsController, keyboardType: TextInputType.number),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FormGroup(
                  t: t,
                  label: 'Baths',
                  child: _Input(t: t, controller: controller.bathsController, keyboardType: TextInputType.number),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FormGroup(
                  t: t,
                  label: 'Size',
                  child: _Input(t: t, controller: controller.sizeController, hint: '1100', suffix: 'ft²', keyboardType: TextInputType.number),
                ),
              ),
            ],
          ),
          _FormGroup(
            t: t,
            label: 'Description',
            hint: 'A few honest sentences works better than buzzwords.',
            child: TextField(
              controller: controller.descController,
              maxLines: 4,
              style: AppTextStyles.bodyMedium.copyWith(color: t.ink, fontSize: 15),
              decoration: _inputDeco(t).copyWith(hintText: 'Bright corner unit with park view…'),
            ),
          ),
          _FormGroup(
            t: t,
            label: 'Amenities',
            child: Obx(() => controller.amenities.isEmpty
                ? Text('No amenities available.', style: AppTextStyles.caption.copyWith(color: t.inkSoft))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.amenities.map((a) {
                      final active = controller.selectedAmenities.contains(a.id);
                      return GestureDetector(
                        onTap: () => controller.toggleAmenity(a.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: active ? t.primarySoft : t.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: active ? t.primary : t.borderSoft),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (active) ...[
                                Icon(Icons.check_rounded, size: 13, color: t.primary),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                a.label,
                                style: AppTextStyles.caption.copyWith(
                                  color: active ? t.primaryInk : t.ink,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  )),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  InputDecoration _inputDeco(FlatNestTheme t) => InputDecoration(
        filled: true,
        fillColor: t.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: t.borderSoft)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: t.borderSoft)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: t.primary, width: 1.5)),
      );
}

class _FormGroup extends StatelessWidget {
  final FlatNestTheme t;
  final String label;
  final String? hint;
  final Widget child;

  const _FormGroup({
    required this.t,
    required this.label,
    required this.child,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: t.inkMid,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 6),
          child,
          if (hint != null) ...[
            const SizedBox(height: 4),
            Text(
              hint!,
              style: AppTextStyles.caption.copyWith(color: t.inkSoft, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}

class _Input extends StatelessWidget {
  final FlatNestTheme t;
  final TextEditingController controller;
  final String? hint;
  final String? prefix;
  final String? suffix;
  final TextInputType keyboardType;

  const _Input({
    required this.t,
    required this.controller,
    this.hint,
    this.prefix,
    this.suffix,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final deco = InputDecoration(
      filled: true,
      fillColor: t.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      hintText: hint,
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: t.inkFaint, fontSize: 15),
      prefixText: prefix,
      prefixStyle: AppTextStyles.bodyMedium.copyWith(color: t.inkMid, fontSize: 15),
      suffixText: suffix,
      suffixStyle: AppTextStyles.caption.copyWith(color: t.inkMid, fontSize: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: t.borderSoft),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: t.borderSoft),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: t.primary, width: 1.5),
      ),
    );
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyMedium.copyWith(color: t.ink, fontSize: 15),
      decoration: deco,
    );
  }
}
