import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
      subtitle: 'Helps owners and renters recognize you. You can skip and add it later.',
      child: Obx(() {
        final path = controller.avatarPath.value;
        final isLoading = controller.isLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),

            // Avatar preview
            Center(
              child: GestureDetector(
                onTap: () => _showPickerSheet(context, t),
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
                      clipBehavior: Clip.antiAlias,
                      child: path != null
                          ? Image.file(File(path), fit: BoxFit.cover)
                          : Icon(Icons.person, size: 80, color: t.primary),
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
            ),
            const SizedBox(height: 12),

            Center(
              child: Text(
                path != null ? 'Tap the photo to change it.' : 'No photo yet — square works best.',
                style: TextStyle(fontSize: 14, color: t.inkMid),
              ),
            ),
            const SizedBox(height: 32),

            // Take photo
            _ActionButton(
              t: t,
              label: 'Take a photo',
              icon: Icons.camera_alt_outlined,
              primary: true,
              onTap: () => controller.pickImage(ImageSource.camera),
            ),
            const SizedBox(height: 12),

            // Choose from gallery
            _ActionButton(
              t: t,
              label: 'Choose from gallery',
              icon: Icons.image_outlined,
              primary: false,
              onTap: () => controller.pickImage(ImageSource.gallery),
            ),
            const SizedBox(height: 32),

            // Finish button
            GestureDetector(
              onTap: isLoading ? null : controller.finishRegistration,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: 54,
                decoration: BoxDecoration(
                  color: t.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        path != null ? 'Finish registration ✓' : 'Continue without photo',
                        style: const TextStyle(
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
              onTap: isLoading ? null : controller.skipAvatar,
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
        );
      }),
    );
  }

  void _showPickerSheet(BuildContext context, FlatNestTheme t) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: t.borderSoft,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.camera_alt_outlined, color: t.ink),
              title: Text('Take a photo', style: TextStyle(color: t.ink, fontWeight: FontWeight.w600)),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.image_outlined, color: t.ink),
              title: Text('Choose from gallery', style: TextStyle(color: t.ink, fontWeight: FontWeight.w600)),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
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
