import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/service/theme_service.dart';
import '../../../core/service/localization_service.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final fnTheme = Theme.of(context).extension<FlatNestTheme>()!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Get.find<LocalizationService>().toggleLocale(),
            icon: Icon(Icons.language, color: fnTheme.ink),
          ),
          IconButton(
            onPressed: () => Get.find<ThemeService>().toggleTheme(),
            icon: Icon(Icons.brightness_4, color: fnTheme.ink),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              _buildLogo(),
              const SizedBox(height: 24),
              _buildHeader(fnTheme),
              const SizedBox(height: 32),
              _buildEmailField(fnTheme),
              const SizedBox(height: 16),
              _buildPasswordFieldHeader(fnTheme),
              const SizedBox(height: 6),
              _buildPasswordField(fnTheme),
              const SizedBox(height: 24),
              _buildSignInButton(),
              _buildDivider(fnTheme),
              _buildSocialButtons(fnTheme),
              const SizedBox(height: 40),
              _buildFooter(fnTheme),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: Icon(Icons.home_work, color: AppColors.white, size: 32),
        ),
      ),
    );
  }

  Widget _buildHeader(FlatNestTheme theme) {
    return Column(
      children: [
        Text(
          TranslationKeys.welcomeBack.tr,
          style: AppTextStyles.h1.copyWith(color: theme.ink, fontSize: 28, letterSpacing: -0.5),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          TranslationKeys.signInDesc.tr,
          style: AppTextStyles.bodyMedium.copyWith(color: theme.inkMid),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField(FlatNestTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TranslationKeys.email.tr,
          style: AppTextStyles.bodySmall.copyWith(color: theme.inkMid, fontWeight: FontWeight.w600, fontSize: 12),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          style: AppTextStyles.bodyMedium.copyWith(color: theme.ink, fontSize: 15),
          decoration: _getInputDecoration(theme),
        ),
      ],
    );
  }

  Widget _buildPasswordFieldHeader(FlatNestTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          TranslationKeys.password.tr,
          style: AppTextStyles.bodySmall.copyWith(color: theme.inkMid, fontWeight: FontWeight.w600, fontSize: 12),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          child: Text(
            TranslationKeys.forgotPassword.tr,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(FlatNestTheme theme) {
    return Obx(() => TextField(
          controller: controller.passwordController,
          obscureText: !controller.showPassword.value,
          style: AppTextStyles.bodyMedium.copyWith(color: theme.ink, fontSize: 15),
          decoration: _getInputDecoration(theme).copyWith(
            suffixIcon: TextButton(
              onPressed: controller.togglePassword,
              child: Text(
                controller.showPassword.value ? TranslationKeys.hide.tr : TranslationKeys.show.tr,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
          ),
        ));
  }

  Widget _buildSignInButton() {
    return Obx(() => controller.isLoading
        ? const Center(child: CircularProgressIndicator())
        : ElevatedButton(
            onPressed: controller.login,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text(
              TranslationKeys.signIn.tr,
              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600, color: AppColors.white),
            ),
          ));
  }

  Widget _buildDivider(FlatNestTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Expanded(child: Divider(color: theme.borderSoft, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              TranslationKeys.orContinueWith.tr,
              style: AppTextStyles.caption.copyWith(color: theme.inkSoft, letterSpacing: 0.6, fontSize: 11),
            ),
          ),
          Expanded(child: Divider(color: theme.borderSoft, thickness: 1)),
        ],
      ),
    );
  }

  Widget _buildSocialButtons(FlatNestTheme theme) {
    return Row(
      children: [
        Expanded(child: _buildSocialBtn('Google', theme)),
        const SizedBox(width: 12),
        Expanded(child: _buildSocialBtn('Apple', theme)),
        const SizedBox(width: 12),
        Expanded(child: _buildSocialBtn('Phone', theme)),
      ],
    );
  }

  Widget _buildSocialBtn(String label, FlatNestTheme theme) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(color: theme.borderSoft),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(color: theme.ink, fontWeight: FontWeight.w500, fontSize: 13),
      ),
    );
  }

  Widget _buildFooter(FlatNestTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          TranslationKeys.newHere.tr,
          style: AppTextStyles.bodyMedium.copyWith(color: theme.inkMid, fontSize: 13),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          child: Text(
            TranslationKeys.createAccount.tr,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
      ],
    );
  }

  InputDecoration _getInputDecoration(FlatNestTheme theme) {
    return InputDecoration(
      filled: true,
      fillColor: theme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.borderSoft),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.borderSoft),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}
