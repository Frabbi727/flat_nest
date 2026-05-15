import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controller/renter_home_controller.dart';
import '../repository/listing_repository.dart';

class RenterHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RenterHomeController>(
      () => RenterHomeController(
        listingRepository: ListingRepository(apiClient: Get.find<ApiClient>()),
      ),
    );
  }
}
