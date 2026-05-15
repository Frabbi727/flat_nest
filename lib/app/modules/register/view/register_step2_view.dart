import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/register_controller.dart';
import '../widget/reg_chrome.dart';

class RegisterStep2View extends GetView<RegisterController> {
  const RegisterStep2View({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return RegChrome(
      t: t,
      step: 1,
      onBack: controller.goBack,
      title: 'Tell us about you',
      subtitle: 'Pick the option that fits best — you can switch later.',
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Role section
              Text(
                "I'M HERE TO",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: t.inkMid,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              _RoleCard(
                t: t,
                title: 'Find a flat',
                description:
                    'Browse listings, save favorites, and message owners directly.',
                perks: const ['Renter', 'Free forever'],
                icon: Icons.search,
                selected: controller.selectedRole.value == 'renter',
                onTap: () => controller.selectedRole.value = 'renter',
              ),
              const SizedBox(height: 12),
              _RoleCard(
                t: t,
                title: 'List my flat',
                description:
                    'Post your property, manage inquiries, and rent it out faster.',
                perks: const ['Owner', 'Verified listings'],
                icon: Icons.home_work_outlined,
                selected: controller.selectedRole.value == 'owner',
                onTap: () => controller.selectedRole.value = 'owner',
              ),
              const SizedBox(height: 28),
              // DOB section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'DATE OF BIRTH',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: t.inkMid,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    '${controller.dobLabel} · age ${controller.age}',
                    style: TextStyle(fontSize: 12, color: t.inkSoft),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _DOBPicker(t: t, controller: controller),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.info_outline, size: 12, color: t.inkSoft),
                  const SizedBox(width: 4),
                  Text(
                    'You must be 18 or older to use FlatNest.',
                    style: TextStyle(fontSize: 11, color: t.inkSoft),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _ContinueBtn(
                t: t,
                enabled: controller.selectedRole.value != null,
                loading: controller.isLoading,
                onTap: controller.submitStep2,
              ),
              const SizedBox(height: 28),
            ],
          )),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final FlatNestTheme t;
  final String title;
  final String description;
  final List<String> perks;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.t,
    required this.title,
    required this.description,
    required this.perks,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? t.primarySoft : t.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? t.primary : t.borderSoft,
            width: 1.5,
          ),
          boxShadow: selected
              ? [BoxShadow(color: t.primary.withValues(alpha: 0.18), blurRadius: 18, offset: const Offset(0, 6))]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected ? t.primary : t.bgAlt,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : t.ink,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: selected ? t.primaryInk : t.ink,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: t.inkMid,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    children: perks
                        .map((p) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: selected
                                    ? t.primary.withValues(alpha: 0.15)
                                    : t.bgAlt,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                p.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: selected ? t.primaryInk : t.inkMid,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? t.primary : Colors.transparent,
                border: Border.all(
                  color: selected ? t.primary : t.inkFaint,
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _DOBPicker extends StatelessWidget {
  final FlatNestTheme t;
  final RegisterController controller;

  const _DOBPicker({required this.t, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime(
              controller.dobYear.value,
              controller.dobMonth.value,
              controller.dobDay.value),
          firstDate: DateTime(1920),
          lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: ColorScheme.light(primary: t.primary),
            ),
            child: child!,
          ),
        );
        if (picked != null) {
          controller.dobDay.value = picked.day;
          controller.dobMonth.value = picked.month;
          controller.dobYear.value = picked.year;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: t.borderSoft),
        ),
        child: Row(
          children: [
            Icon(Icons.cake_outlined, color: t.inkSoft, size: 20),
            const SizedBox(width: 12),
            Obx(() => Text(
                  controller.dobLabel,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: t.primary,
                  ),
                )),
            const Spacer(),
            Icon(Icons.chevron_right, color: t.inkSoft),
          ],
        ),
      ),
    );
  }
}

class _ContinueBtn extends StatelessWidget {
  final FlatNestTheme t;
  final bool enabled;
  final bool loading;
  final VoidCallback onTap;

  const _ContinueBtn({
    required this.t,
    required this.enabled,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (enabled && !loading) ? onTap : null,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: enabled ? t.primary : t.bgAlt,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.white),
              )
            : Text(
                'Continue →',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: enabled ? Colors.white : t.inkFaint,
                ),
              ),
      ),
    );
  }
}
