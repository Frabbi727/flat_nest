import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/create_listing_controller.dart';
import 'create_listing_step1_view.dart';
import 'create_listing_step2_view.dart';
import 'create_listing_step3_view.dart';
import 'create_listing_step4_view.dart';

class CreateListingView extends GetView<CreateListingController> {
  const CreateListingView({super.key});

  static const _steps = ['Details', 'Photos', 'Location', 'Preview'];

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(t),
            Expanded(
              child: Obx(() => switch (controller.currentStep.value) {
                    0 => const CreateListingStep1View(),
                    1 => const CreateListingStep2View(),
                    2 => const CreateListingStep3View(),
                    _ => const CreateListingStep4View(),
                  }),
            ),
            _buildFooter(t),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(FlatNestTheme t) {
    return Obx(() {
      final step = controller.currentStep.value;
      return Container(
        color: t.surface,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: controller.goBack,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: t.bgAlt,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.chevron_left_rounded, color: t.ink, size: 22),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Post a flat',
                  style: AppTextStyles.h2.copyWith(color: t.ink, fontSize: 17),
                ),
                const Spacer(),
                Text(
                  'Step ${step + 1} of ${_steps.length}',
                  style: AppTextStyles.caption.copyWith(color: t.inkSoft),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: List.generate(_steps.length, (i) {
                final active = i == step;
                final done = i < step;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i < _steps.length - 1 ? 6 : 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 4,
                          decoration: BoxDecoration(
                            color: (active || done) ? t.primary : t.borderSoft,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _steps[i],
                          style: AppTextStyles.caption.copyWith(
                            color: active ? t.primary : t.inkSoft,
                            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFooter(FlatNestTheme t) {
    return Obx(() {
      final step = controller.currentStep.value;
      final isLoading = controller.isLoading;
      return Container(
        color: t.surface,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Row(
          children: [
            if (step > 0) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.goBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: t.borderSoft),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Back',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: t.ink, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              flex: step > 0 ? 2 : 1,
              child: ElevatedButton(
                onPressed: isLoading ? null : controller.continueStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: t.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        step == _steps.length - 1
                            ? 'Submit for review'
                            : 'Continue →',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
