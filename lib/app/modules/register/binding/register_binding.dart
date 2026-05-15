import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../auth/repository/auth_repository.dart';
import '../controller/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(
      () => RegisterController(
        authRepository: AuthRepository(apiClient: Get.find<ApiClient>()),
      ),
    );
  }
}
