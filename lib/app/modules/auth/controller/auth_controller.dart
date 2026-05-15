import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/network/resource.dart';
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
      showError(TranslationKeys.pleaseFillAll.tr);
      return;
    }

    showLoading();
    final result = await _authRepository.login(email, password);
    hideLoading();

    switch (result) {
      case Success(data: final user?):
        await _authService.login(
          accessToken: 'fake_access_token_for_${user.id}',
          refreshToken: 'fake_refresh_token_for_${user.id}',
        );
        Get.offAllNamed(Routes.home);
      case Success():
        showError(TranslationKeys.userDataNotFound.tr);
      case Error(message: final msg):
        showError(msg.tr);
    }
  }
}
