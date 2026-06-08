import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../chat/controller/chat_controller.dart';
import '../../chat/repository/chat_repository.dart';
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
    Get.lazyPut(() => ChatController(chatRepository: ChatRepository(apiClient: Get.find<ApiClient>())));
  }
}
