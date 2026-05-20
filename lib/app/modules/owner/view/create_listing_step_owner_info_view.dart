import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/create_listing_controller.dart';

class CreateListingStepOwnerInfoView extends GetView<CreateListingController> {
  const CreateListingStepOwnerInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Owner Contact Info',
            style: AppTextStyles.h2.copyWith(
              color: t.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Renters will use this to contact you',
            style: AppTextStyles.bodySmall.copyWith(color: t.inkSoft),
          ),
          const SizedBox(height: 20),

          // Auto-fill button
          OutlinedButton.icon(
            onPressed: controller.fillWithAccountInfo,
            icon: Icon(Icons.person_outline_rounded, size: 16, color: t.primary),
            label: Text(
              'Fill with my account info',
              style: AppTextStyles.bodySmall.copyWith(
                color: t.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: t.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
          const SizedBox(height: 20),

          _FormGroup(
            t: t,
            label: 'Contact Name',
            child: TextField(
              controller: controller.ownerNameController,
              style: AppTextStyles.bodyMedium.copyWith(color: t.ink, fontSize: 15),
              decoration: _inputDeco(t).copyWith(hintText: 'Full name'),
            ),
          ),
          _FormGroup(
            t: t,
            label: 'Primary Phone',
            child: TextField(
              controller: controller.ownerPhoneController,
              keyboardType: TextInputType.phone,
              maxLength: 20,
              style: AppTextStyles.bodyMedium.copyWith(color: t.ink, fontSize: 15),
              decoration: _inputDeco(t).copyWith(hintText: '01XXXXXXXXX', counterText: ''),
            ),
          ),
          _FormGroup(
            t: t,
            label: 'Alternative Phone',
            child: TextField(
              controller: controller.ownerAltPhoneController,
              keyboardType: TextInputType.phone,
              maxLength: 20,
              style: AppTextStyles.bodyMedium.copyWith(color: t.ink, fontSize: 15),
              decoration: _inputDeco(t).copyWith(hintText: 'Optional second number', counterText: ''),
            ),
          ),
          _FormGroup(
            t: t,
            label: 'Email Address',
            child: TextField(
              controller: controller.ownerEmailController,
              keyboardType: TextInputType.emailAddress,
              style: AppTextStyles.bodyMedium.copyWith(color: t.ink, fontSize: 15),
              decoration: _inputDeco(t).copyWith(hintText: 'your@email.com'),
            ),
          ),

          // Preferred contact method
          _FormGroup(
            t: t,
            label: 'Preferred Contact Method',
            child: Obx(() {
              final selected = controller.selectedPreferredContact.value;
              return Row(
                children: [
                  _ContactChip(
                    t: t,
                    label: 'Call',
                    value: 'call',
                    selected: selected == 'call',
                    onTap: () => controller.selectedPreferredContact.value = 'call',
                  ),
                  const SizedBox(width: 8),
                  _ContactChip(
                    t: t,
                    label: 'WhatsApp',
                    value: 'whatsapp',
                    selected: selected == 'whatsapp',
                    onTap: () =>
                        controller.selectedPreferredContact.value = 'whatsapp',
                  ),
                  const SizedBox(width: 8),
                  _ContactChip(
                    t: t,
                    label: 'Both',
                    value: 'both',
                    selected: selected == 'both',
                    onTap: () => controller.selectedPreferredContact.value = 'both',
                  ),
                ],
              );
            }),
          ),

          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: controller.skipOwnerInfoStep,
              child: Text(
                'Skip for now →',
                style: AppTextStyles.bodySmall.copyWith(color: t.inkSoft),
              ),
            ),
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

class _FormGroup extends StatelessWidget {
  final FlatNestTheme t;
  final String label;
  final Widget child;

  const _FormGroup({required this.t, required this.label, required this.child});

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
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  final FlatNestTheme t;
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _ContactChip({
    required this.t,
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? t.primarySoft : t.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? t.primary : t.borderSoft),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: selected ? t.primaryInk : t.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
