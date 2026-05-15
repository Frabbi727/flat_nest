import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/create_listing_controller.dart';

class CreateListingStep3View extends GetView<CreateListingController> {
  const CreateListingStep3View({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CascadeSelect(
                t: t,
                label: 'Division',
                placeholder: 'Select division',
                value: controller.division.value,
                options: controller.divisions,
                isOpen: controller.activeDropdown.value == 'division',
                onToggle: () => controller.toggleDropdown('division'),
                onPick: controller.pickDivision,
              ),
              _CascadeSelect(
                t: t,
                label: 'District',
                placeholder: controller.division.value != null
                    ? 'Select district'
                    : 'Select division first',
                value: controller.district.value,
                options: controller.districts,
                isDisabled: controller.division.value == null,
                isOpen: controller.activeDropdown.value == 'district',
                onToggle: () => controller.toggleDropdown('district'),
                onPick: controller.pickDistrict,
              ),
              _CascadeSelect(
                t: t,
                label: 'Upazila / Thana',
                placeholder: controller.district.value != null
                    ? 'Select upazila'
                    : 'Select district first',
                value: controller.upazila.value,
                options: controller.upazilas,
                isDisabled: controller.district.value == null,
                isOpen: controller.activeDropdown.value == 'upazila',
                onToggle: () => controller.toggleDropdown('upazila'),
                onPick: controller.pickUpazila,
              ),
              _CascadeSelect(
                t: t,
                label: 'Union / Area',
                placeholder: controller.upazila.value != null
                    ? 'Select union'
                    : 'Select upazila first',
                value: controller.union.value,
                options: controller.unions,
                isDisabled: controller.upazila.value == null,
                isOpen: controller.activeDropdown.value == 'union',
                onToggle: () => controller.toggleDropdown('union'),
                onPick: controller.pickUnion,
              ),
              _FormGroup(
                t: t,
                label: 'Road & house number',
                hint: 'Shown only to renters you\'ve replied to.',
                child: TextField(
                  controller: controller.roadAndHouse,
                  style:
                      AppTextStyles.bodyMedium.copyWith(color: t.ink, fontSize: 15),
                  decoration: _inputDeco(t).copyWith(
                    hintText: 'House 24, Road 11',
                  ),
                ),
              ),
              // Location preview card
              if (controller.union.value != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: t.primarySoft,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: t.primary.withValues(alpha:0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on_rounded, color: t.primary, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          [
                            controller.union.value,
                            controller.upazila.value,
                            controller.district.value,
                            controller.division.value,
                          ].whereType<String>().join(' · '),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: t.primaryInk,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ],
          )),
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

class _CascadeSelect extends StatelessWidget {
  final FlatNestTheme t;
  final String label;
  final String placeholder;
  final String? value;
  final List<String> options;
  final bool isDisabled;
  final bool isOpen;
  final VoidCallback onToggle;
  final ValueChanged<String> onPick;

  const _CascadeSelect({
    required this.t,
    required this.label,
    required this.placeholder,
    required this.value,
    required this.options,
    required this.isOpen,
    required this.onToggle,
    required this.onPick,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDisabled ? 0.5 : 1,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
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
            GestureDetector(
              onTap: isDisabled ? null : onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isOpen ? t.primary : t.borderSoft,
                    width: isOpen ? 1.5 : 1,
                  ),
                  boxShadow: isOpen
                      ? [
                          BoxShadow(
                            color: t.primary.withValues(alpha:0.12),
                            blurRadius: 0,
                            spreadRadius: 4,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value ?? placeholder,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: value != null ? t.ink : t.inkFaint,
                          fontWeight: value != null ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 200),
                      turns: isOpen ? 0.5 : 0,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: t.inkSoft,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isOpen)
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: t.borderSoft),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: t.bgAlt,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        border: Border(bottom: BorderSide(color: t.borderSoft)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${options.length} option${options.length == 1 ? '' : 's'}',
                            style: AppTextStyles.caption.copyWith(
                              color: t.inkSoft,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        separatorBuilder: (_, __) =>
                            Divider(height: 1, color: t.borderSoft),
                        itemBuilder: (context, i) {
                          final opt = options[i];
                          final selected = opt == value;
                          return GestureDetector(
                            onTap: () => onPick(opt),
                            child: Container(
                              color: selected ? t.primarySoft : t.surface,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      opt,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: selected ? t.primaryInk : t.ink,
                                        fontWeight: selected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  if (selected)
                                    Icon(Icons.check_rounded,
                                        color: t.primary, size: 16),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
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
