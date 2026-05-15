import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controller/create_listing_controller.dart';
import '../repository/create_listing_repository.dart';

class CreateListingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateListingRepository>(
      () => CreateListingRepository(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<CreateListingController>(
      () => CreateListingController(repo: Get.find<CreateListingRepository>()),
    );
  }
}
