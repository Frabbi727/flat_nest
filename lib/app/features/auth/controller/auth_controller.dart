import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/service/auth_service.dart';
import '../../../route/app_routes.dart';
import '../repository/auth_repository.dart';

class AuthController extends BaseController {
  final AuthRepository _authRepository;
  final AuthService _authService = Get.find<AuthService>();

  AuthController({required AuthRepository authRepository}) : _authRepository = authRepository;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final showPassword = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePassword() => showPassword.value = !showPassword.value;

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showError('Please fill all fields');
      return;
    }

    try {
      showLoading();
      final user = await _authRepository.login(email, password);
      await _authService.login('fake_token_for_${user.id}');
      hideLoading();
      Get.offAllNamed(Routes.home);
    } catch (e) {
      hideLoading();
      showError(e.toString());
    }
  }
}
