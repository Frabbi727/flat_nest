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
    await Future.delayed(const Duration(seconds: 2));

    if (_authService.isFirstTime) {
      Get.offAllNamed(Routes.onboarding);
    } else if (_authService.isAuthenticated) {
      final user = _authService.currentUser;
      if (user?.isOwner == true) {
        Get.offAllNamed(Routes.ownerHome);
      } else {
        Get.offAllNamed(Routes.renterHome);
      }
    } else {
      Get.offAllNamed(Routes.login);
    }
  }
}
