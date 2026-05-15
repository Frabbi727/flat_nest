import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/service/auth_service.dart';
import '../../../route/app_routes.dart';

class HomeController extends BaseController {
  final AuthService _authService = Get.find<AuthService>();

  void logout() async {
    await _authService.logout();
    Get.offAllNamed(Routes.login);
  }
}
