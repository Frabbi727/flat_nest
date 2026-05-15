import 'package:get/get.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/service/auth_service.dart';
import '../../../route/app_routes.dart';

class OnboardingController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxInt currentPage = 0.obs;

  final List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      title: TranslationKeys.onboarding1Title.tr,
      description: TranslationKeys.onboarding1Desc.tr,
      icon: '🔍',
      color: 0xFFFFE0CC,
    ),
    OnboardingPageModel(
      title: TranslationKeys.onboarding2Title.tr,
      description: TranslationKeys.onboarding2Desc.tr,
      icon: '📸',
      color: 0xFFD4E7DA,
    ),
    OnboardingPageModel(
      title: TranslationKeys.onboarding3Title.tr,
      description: TranslationKeys.onboarding3Desc.tr,
      icon: '💬',
      color: 0xFFD7DFFC,
    ),
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void skip() async {
    await _authService.completeOnboarding();
    Get.offAllNamed(Routes.login);
  }

  void next() async {
    if (currentPage.value < pages.length - 1) {
      currentPage.value++;
    } else {
      await _authService.completeOnboarding();
      Get.offAllNamed(Routes.login);
    }
  }
}

class OnboardingPageModel {
  final String title;
  final String description;
  final String icon;
  final int color;

  OnboardingPageModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
