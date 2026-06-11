import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/network/resource.dart';
import '../../../core/service/auth_service.dart';
import '../../../core/service/notification_service.dart';
import '../../../route/app_routes.dart';
import '../model/user_model.dart';
import '../repository/auth_repository.dart';

class AuthController extends BaseController {
  final AuthRepository _authRepository;
  final AuthService _authService = Get.find<AuthService>();

  AuthController({required AuthRepository authRepository}) : _authRepository = authRepository;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final showPassword = false.obs;
  final showGoogleHint = false.obs;

  @override
  void onInit() {
    super.onInit();
    GoogleSignIn.instance.initialize(
      serverClientId: '305560403551-pprdlkpkgolqhu6ho81bk5cb9sflcqbk.apps.googleusercontent.com',
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePassword() => showPassword.value = !showPassword.value;

  void onEmailChanged(String _) {
    if (showGoogleHint.value) showGoogleHint.value = false;
  }

  void goToRegister() => Get.toNamed(Routes.register);

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
      case Success(data: final authResponse?):
        showGoogleHint.value = false;
        await _authService.login(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
        );
        _authService.saveUser(authResponse.user);
        Get.find<NotificationService>().registerTokenAfterLogin();
        _navigateAfterAuth(authResponse.user);
      case Success():
        showError(TranslationKeys.userDataNotFound.tr);
      case Error(message: final msg, code: final errorCode):
        if (errorCode == 'USE_GOOGLE_SIGN_IN') showGoogleHint.value = true;
        showError(msg);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final account = await GoogleSignIn.instance.authenticate();
      final auth = account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) {
        showError('Google sign-in failed. Please try again.');
        return;
      }

      showLoading();
      final result = await _authRepository.googleSignIn(idToken);
      hideLoading();

      switch (result) {
        case Success(data: final authResponse?):
          await _authService.login(
            accessToken: authResponse.accessToken,
            refreshToken: authResponse.refreshToken,
          );
          _authService.saveUser(authResponse.user);
          Get.find<NotificationService>().registerTokenAfterLogin();
          _navigateAfterAuth(authResponse.user);
        case Success():
          showError(TranslationKeys.userDataNotFound.tr);
        case Error(message: final msg):
          showError(msg);
      }
    } catch (e) {
      hideLoading();
      if (kDebugMode) {
        if (e is PlatformException) {
          debugPrint('Google sign-in PlatformException: ${e.code} | ${e.message}');
        }
        debugPrint('Google sign-in error: $e');
      }
      showError('Google sign-in failed. Please try again.');
    }
  }

  void _navigateAfterAuth(UserModel user) {
    if (!user.isComplete) {
      final step = user.role != null ? 3 : 2;
      Get.offAllNamed(Routes.register, arguments: {'step': step});
      return;
    }
    if (user.isOwner) {
      Get.offAllNamed(Routes.ownerHome);
    } else {
      Get.offAllNamed(Routes.renterHome);
    }
  }
}
