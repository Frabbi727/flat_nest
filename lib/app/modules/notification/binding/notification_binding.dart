import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controller/notification_controller.dart';
import '../repository/notification_repository.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => NotificationController(
        repository: NotificationRepository(
          apiClient: Get.find<ApiClient>(),
        ),
      ),
    );
  }
}
