import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/create_listing_controller.dart';

class CreateListingStep1View extends GetView<CreateListingController> {
  const CreateListingStep1View({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

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
                  children: CreateListingController.typeOptions.map((x) {
                    final active = controller.selectedType.value == x;
                    return GestureDetector(
                      onTap: () => controller.selectedType.value = x,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: active ? t.primary : t.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: active ? t.primary : t.borderSoft,
                          ),
                        ),
                        child: Text(
                          x,
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
                  child: _Input(
                    t: t,
                    controller: controller.priceController,
                    hint: '28,000',
                    prefix: '৳',
                    suffix: '/mo',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FormGroup(
                  t: t,
                  label: 'Deposit',
                  child: _Input(
                    t: t,
                    controller: controller.depositController,
                    hint: '56,000',
                    prefix: '৳',
                    keyboardType: TextInputType.number,
                  ),
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
                  child: _Input(
                    t: t,
                    controller: controller.bedsController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FormGroup(
                  t: t,
                  label: 'Baths',
                  child: _Input(
                    t: t,
                    controller: controller.bathsController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FormGroup(
                  t: t,
                  label: 'Size',
                  child: _Input(
                    t: t,
                    controller: controller.sizeController,
                    hint: '1100',
                    suffix: 'ft²',
                    keyboardType: TextInputType.number,
                  ),
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
              decoration: _inputDeco(t).copyWith(
                hintText: 'Bright corner unit with park view…',
              ),
            ),
          ),
          _FormGroup(
            t: t,
            label: 'Amenities',
            child: Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _amenities.map((a) {
                    final active = controller.selectedAmenities.contains(a.id);
                    return GestureDetector(
                      onTap: () => controller.toggleAmenity(a.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: active ? t.primarySoft : t.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: active ? t.primary : t.borderSoft,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (active) ...[
                              Icon(Icons.check_rounded, size: 13, color: t.primary),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              a.name,
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
}

// Static amenity list (matches backend IDs)
const _amenities = [
  _Amenity(1, 'Wifi'),
  _Amenity(2, 'Parking'),
  _Amenity(3, 'Gas'),
  _Amenity(4, 'Lift'),
  _Amenity(5, 'Generator'),
  _Amenity(6, 'Gym'),
  _Amenity(7, 'Rooftop'),
  _Amenity(8, 'Furnished'),
  _Amenity(9, 'AC'),
];

class _Amenity {
  final int id;
  final String name;
  const _Amenity(this.id, this.name);
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
