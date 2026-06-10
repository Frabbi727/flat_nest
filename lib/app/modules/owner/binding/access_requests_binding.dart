import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controller/access_request_controller.dart';
import '../repository/access_request_repository.dart';

class OwnerAccessRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccessRequestController>(
      () => AccessRequestController(
        repository:
            AccessRequestRepository(apiClient: Get.find<ApiClient>()),
      ),
    );
  }
}
