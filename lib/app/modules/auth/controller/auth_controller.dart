import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/network/resource.dart';
import '../../../core/service/auth_service.dart';
import '../../../route/app_routes.dart';
import '../model/user_model.dart';
import '../repository/auth_repository.dart';

// ── Google Sign-In access control ─────────────────────────────────────────────
// Only users with these roles (or no role yet) may sign in via Google.
// Owners are excluded — they must use email + password.
const _googleSignInAllowedRoles = ['renter'];
// ──────────────────────────────────────────────────────────────────────────────

class AuthController extends BaseController {
  final AuthRepository _authRepository;
  final AuthService _authService = Get.find<AuthService>();

  AuthController({required AuthRepository authRepository}) : _authRepository = authRepository;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final showPassword = false.obs;
  final _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: '398880175861-f8uusfntm2jpm3ggpgfjoip4lpgmh7gd.apps.googleusercontent.com',
  );

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePassword() => showPassword.value = !showPassword.value;

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
        await _authService.login(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
        );
        _authService.saveUser(authResponse.user);
        _navigateAfterAuth(authResponse.user);
      case Success():
        showError(TranslationKeys.userDataNotFound.tr);
      case Error(message: final msg):
        showError(msg);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return;

      final auth = await account.authentication;
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
          final role = authResponse.user.role;
          if (role != null && !_googleSignInAllowedRoles.contains(role)) {
            await _authRepository.logout();
            showError('Google sign-in is only available for renters.');
            return;
          }
          await _authService.login(
            accessToken: authResponse.accessToken,
            refreshToken: authResponse.refreshToken,
          );
          _authService.saveUser(authResponse.user);
          _navigateAfterAuth(authResponse.user);
        case Success():
          showError(TranslationKeys.userDataNotFound.tr);
        case Error(message: final msg):
          showError(msg);
      }
    } catch (e) {
      hideLoading();
      Get.log('Google sign-in error: $e');
      showError('Google sign-in failed: $e');
    }
  }

  void _navigateAfterAuth(UserModel user) {
    if (!user.isComplete) {
      Get.offAllNamed(Routes.register, arguments: {'step': 2});
      return;
    }
    if (user.isOwner) {
      Get.offAllNamed(Routes.ownerHome);
    } else {
      Get.offAllNamed(Routes.renterHome);
    }
  }
}
