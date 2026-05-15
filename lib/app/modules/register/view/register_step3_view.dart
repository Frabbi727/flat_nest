import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/register_controller.dart';
import '../widget/reg_chrome.dart';

class RegisterStep3View extends GetView<RegisterController> {
  const RegisterStep3View({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return RegChrome(
      t: t,
      step: 2,
      onBack: controller.goBack,
      title: 'Add a profile photo',
      subtitle:
          'Helps owners and renters recognize you. You can skip and add it later.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          // Avatar placeholder
          Center(
            child: Stack(
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: t.primarySoft,
                    border: Border.all(color: t.borderSoft, width: 2),
                  ),
                  child: Icon(Icons.person, size: 80, color: t.primary),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: t.primary,
                      border: Border.all(color: t.bg, width: 3),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'No photo yet — square works best.',
              style: TextStyle(fontSize: 14, color: t.inkMid),
            ),
          ),
          const SizedBox(height: 32),
          // Take photo button
          _ActionButton(
            t: t,
            label: 'Take a photo',
            icon: Icons.camera_alt_outlined,
            primary: true,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _ActionButton(
            t: t,
            label: 'Choose from gallery',
            icon: Icons.image_outlined,
            primary: false,
            onTap: () {},
          ),
          const SizedBox(height: 32),
          // Finish button
          GestureDetector(
            onTap: controller.finishRegistration,
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: t.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Finish registration ✓',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Skip
          GestureDetector(
            onTap: controller.skipAvatar,
            child: Container(
              height: 44,
              alignment: Alignment.center,
              child: Text(
                'Skip for now',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: t.inkMid,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final FlatNestTheme t;
  final String label;
  final IconData icon;
  final bool primary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.t,
    required this.label,
    required this.icon,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: primary ? t.primary : t.surface,
          borderRadius: BorderRadius.circular(12),
          border: primary ? null : Border.all(color: t.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: primary ? Colors.white : t.ink, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: primary ? Colors.white : t.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
