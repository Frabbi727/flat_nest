import 'package:get/get.dart';
import '../../../core/service/auth_service.dart';
import '../../../route/app_routes.dart';

class OnboardingController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxInt currentPage = 0.obs;

  final List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      title: 'Find your next flat',
      description: 'Browse trusted listings from verified owners across Dhaka. No brokers, no hidden fees.',
      icon: '🔍',
      color: 0xFFFFE0CC,
    ),
    OnboardingPageModel(
      title: 'List your flat in minutes',
      description: 'Upload photos, set your price, and reach thousands of renters looking for a home like yours.',
      icon: '📸',
      color: 0xFFD4E7DA,
    ),
    OnboardingPageModel(
      title: 'Chat & move in',
      description: 'Message owners directly, schedule a visit, and finalize without leaving the app.',
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
