import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controller/auth_controller.dart';
import '../repository/auth_repository.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository(apiClient: Get.find<ApiClient>()));
    Get.lazyPut<AuthController>(() => AuthController(authRepository: Get.find<AuthRepository>()));
  }
}
