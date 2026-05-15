import 'package:get/get.dart';
import '../../../core/service/auth_service.dart';
import '../../../route/app_routes.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onReady() {
    super.onReady();
    _checkNavigation();
  }

  void _checkNavigation() async {
    // Artificial delay for splash visual
    await Future.delayed(const Duration(seconds: 2));

    if (_authService.isFirstTime) {
      // Show onboarding only once
      Get.offAllNamed(Routes.onboarding);
    } else {
      if (_authService.isAuthenticated) {
        // Remembered login
        Get.offAllNamed(Routes.home);
      } else {
        // Must login
        Get.offAllNamed(Routes.login);
      }
    }
  }
}
