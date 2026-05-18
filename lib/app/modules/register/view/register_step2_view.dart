import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/model/role_model.dart';
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
      title: 'Your role',
      subtitle: 'Pick how you\'ll use FlatNest. This cannot be changed later.',
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
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
              ...controller.availableRoles.map((role) {
                final config = _roleConfig(role);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _RoleCard(
                    t: t,
                    title: config.title,
                    description: config.description,
                    perks: config.perks,
                    icon: config.icon,
                    selected: controller.selectedRole.value == role.value,
                    onTap: () => controller.selectedRole.value = role.value,
                  ),
                );
              }),
              const SizedBox(height: 16),
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

class _RoleConfig {
  final String title;
  final String description;
  final List<String> perks;
  final IconData icon;
  const _RoleConfig({required this.title, required this.description, required this.perks, required this.icon});
}

_RoleConfig _roleConfig(RoleModel role) {
  switch (role.value) {
    case 'renter':
      return const _RoleConfig(
        title: 'Find a flat',
        description: 'Browse listings, save favorites, and message owners directly.',
        perks: ['Renter', 'Free forever'],
        icon: Icons.search,
      );
    case 'owner':
      return const _RoleConfig(
        title: 'List my flat',
        description: 'Post your property, manage inquiries, and rent it out faster.',
        perks: ['Owner', 'Verified listings'],
        icon: Icons.home_work_outlined,
      );
    default:
      return _RoleConfig(
        title: role.label,
        description: '',
        perks: [role.label],
        icon: Icons.person_outline,
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
