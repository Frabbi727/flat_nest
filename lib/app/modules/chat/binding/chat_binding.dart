import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controller/chat_controller.dart';
import '../repository/chat_repository.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(
      () => ChatController(
        chatRepository: ChatRepository(apiClient: Get.find<ApiClient>()),
      ),
    );
  }
}
