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
    // Show splash for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    if (_authService.isFirstTime) {
      Get.offAllNamed(Routes.onboarding);
    } else if (_authService.isAuthenticated) {
      final user = _authService.currentUser;
      if (user?.isComplete == false) {
        final step = user?.role != null ? 3 : 2;
        Get.offAllNamed(Routes.register, arguments: {'step': step});
      } else if (user?.isOwner == true) {
        Get.offAllNamed(Routes.ownerHome);
      } else {
        Get.offAllNamed(Routes.renterHome);
      }
    } else {
      Get.offAllNamed(Routes.renterHome);
    }
  }
}
