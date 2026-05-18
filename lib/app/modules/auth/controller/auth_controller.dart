import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final showGoogleHint = false.obs;
  final _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: '638776596608-n6qd2nk8pu2jmoobko04kdoa18kr3564.apps.googleusercontent.com',
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
        showGoogleHint.value = false;
        await _authService.login(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
        );
        _authService.saveUser(authResponse.user);
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
      if (e is PlatformException) {
        Get.log('Google sign-in PlatformException');
        Get.log('  code: ${e.code}');
        Get.log('  message: ${e.message}');
        Get.log('  details: ${e.details}');
      }
      Get.log('Google sign-in error: $e');
      showError('Google sign-in failed. Please try again.');
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
