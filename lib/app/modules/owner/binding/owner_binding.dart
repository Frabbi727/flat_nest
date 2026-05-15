import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controller/owner_controller.dart';
import '../repository/owner_repository.dart';

class OwnerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OwnerController>(
      () => OwnerController(
        ownerRepository: OwnerRepository(apiClient: Get.find<ApiClient>()),
      ),
    );
  }
}
