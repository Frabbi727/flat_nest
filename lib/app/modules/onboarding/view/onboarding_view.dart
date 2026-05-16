import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final fnTheme = Theme.of(context).extension<FlatNestTheme>()!;

    return Scaffold(
      body: Obx(() {
        final currentPage = controller.currentPage.value;
        final pageData = controller.pages[currentPage];

        return Column(
          children: [
            // Illustration Block
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                color: Color(pageData.color),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        pageData.icon,
                        style: const TextStyle(fontSize: 120),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      right: 16,
                      child: TextButton(
                        onPressed: controller.skip,
                        child: Text(
                          TranslationKeys.skip.tr,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: fnTheme.ink,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content Block
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pageData.title,
                      style: AppTextStyles.h2.copyWith(color: fnTheme.ink),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      pageData.description,
                      style: AppTextStyles.bodyMedium.copyWith(color: fnTheme.inkMid),
                    ),
                    const Spacer(),
                    // Bottom Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Dots
                        Row(
                          children: List.generate(
                            controller.pages.length,
                            (index) => Container(
                              margin: const EdgeInsets.only(right: 6),
                              width: index == currentPage ? 22 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: index == currentPage ? AppColors.primary : fnTheme.inkSoft,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                        // Next Button
                        ElevatedButton(
                          onPressed: controller.next,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            currentPage == controller.pages.length - 1 ? TranslationKeys.getStarted.tr : TranslationKeys.next.tr,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
