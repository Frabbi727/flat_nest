import 'package:get/get.dart';

abstract class BaseController extends GetxController {
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;
  set errorMessage(String value) => _errorMessage.value = value;

  void showLoading() => isLoading = true;
  void hideLoading() => isLoading = false;

  void showError(String message) {
    errorMessage = message;
    // You can also show a snackbar or dialog here
    Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
  }
}
