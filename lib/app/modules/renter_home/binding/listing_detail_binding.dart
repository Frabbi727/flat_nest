import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../chat/controller/chat_controller.dart';
import '../../chat/repository/chat_repository.dart';
import '../controller/listing_detail_controller.dart';
import '../repository/listing_repository.dart';

class ListingDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListingDetailController>(
      () => ListingDetailController(
        listingRepository: ListingRepository(apiClient: Get.find<ApiClient>()),
      ),
    );
    if (!Get.isRegistered<ChatController>()) {
      Get.lazyPut(() => ChatController(
        chatRepository: ChatRepository(apiClient: Get.find<ApiClient>()),
      ));
    }
  }
}
