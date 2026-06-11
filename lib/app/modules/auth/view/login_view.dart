import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/network/api_config.dart';
import '../../../shared/web_view_screen.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return Scaffold(
      backgroundColor: t.bg,
      body:  SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 24),
              _buildLogo(t),
              const SizedBox(height: 24),
              _buildHeader(t),
              const SizedBox(height: 32),
              _buildEmailField(t),
              const SizedBox(height: 12),
              Obx(() => controller.showGoogleHint.value
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildPasswordLabel(t),
                        const SizedBox(height: 6),
                        _buildPasswordField(t),
                        const SizedBox(height: 24),
                        _buildSignInButton(t),
                      ],
                    )),
              _buildDivider(t),
              _buildSocialButtons(t),
              const SizedBox(height: 40),
              _buildFooter(t),
              const SizedBox(height: 16),
              _buildLegalLinks(t, context),
              const SizedBox(height: 24),
            ],
          ),
        ),

    );
  }

  Widget _buildLogo(FlatNestTheme t) {
    return Image.asset(
      'assets/images/flatnest_icon_v4.png',
      width: 72,
      height: 72,
    );
  }

  Widget _buildHeader(FlatNestTheme t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TranslationKeys.welcomeBack.tr,
          style: AppTextStyles.h1.copyWith(
            color: t.ink,
            fontSize: 28,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          TranslationKeys.signInDesc.tr,
          style: AppTextStyles.bodyMedium.copyWith(color: t.inkMid),
        ),
      ],
    );
  }

  Widget _buildEmailField(FlatNestTheme t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TranslationKeys.email.tr,
          style: AppTextStyles.bodySmall.copyWith(
            color: t.inkMid,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: controller.onEmailChanged,
          style: AppTextStyles.bodyMedium.copyWith(color: t.ink, fontSize: 15),
          decoration: _inputDecoration(t),
        ),
      ],
    );
  }

  Widget _buildPasswordLabel(FlatNestTheme t) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          TranslationKeys.password.tr,
          style: AppTextStyles.bodySmall.copyWith(
            color: t.inkMid,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            TranslationKeys.forgotPassword.tr,
            style: AppTextStyles.bodySmall.copyWith(
              color: t.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(FlatNestTheme t) {
    return Obx(() => TextField(
          controller: controller.passwordController,
          obscureText: !controller.showPassword.value,
          style: AppTextStyles.bodyMedium.copyWith(color: t.ink, fontSize: 15),
          decoration: _inputDecoration(t).copyWith(
            suffixIcon: TextButton(
              onPressed: controller.togglePassword,
              child: Text(
                controller.showPassword.value
                    ? TranslationKeys.hide.tr
                    : TranslationKeys.show.tr,
                style: AppTextStyles.bodySmall.copyWith(
                  color: t.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildSignInButton(FlatNestTheme t) {
    return Obx(() => controller.isLoading
        ? Center(child: CircularProgressIndicator(color: t.primary))
        : ElevatedButton(
            onPressed: controller.login,
            style: ElevatedButton.styleFrom(
              backgroundColor: t.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              TranslationKeys.signIn.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ));
  }

  Widget _buildDivider(FlatNestTheme t) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Expanded(child: Divider(color: t.borderSoft, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              TranslationKeys.orContinueWith.tr,
              style: AppTextStyles.caption.copyWith(
                color: t.inkSoft,
                letterSpacing: 0.6,
                fontSize: 11,
              ),
            ),
          ),
          Expanded(child: Divider(color: t.borderSoft, thickness: 1)),
        ],
      ),
    );
  }

  Widget _buildSocialButtons(FlatNestTheme t) {
    return Obx(() {
      final hinted = controller.showGoogleHint.value;
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: controller.signInWithGoogle,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: BorderSide(
              color: hinted ? t.primary : Colors.grey.shade300,
              width: hinted ? 2 : 1,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/img.png',
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 10),
              Text(
                hinted ? 'Continue with Google' : 'Sign in with Google',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: hinted ? t.primary : t.ink,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFooter(FlatNestTheme t) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          TranslationKeys.newHere.tr,
          style: AppTextStyles.bodyMedium.copyWith(
            color: t.inkMid,
            fontSize: 13,
          ),
        ),
        GestureDetector(
          onTap: controller.goToRegister,
          child: Text(
            TranslationKeys.createAccount.tr,
            style: AppTextStyles.bodyMedium.copyWith(
              color: t.primary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegalLinks(FlatNestTheme t, BuildContext context) {
    final base = ApiConfig.storageBaseUrl;
    final linkStyle = AppTextStyles.caption.copyWith(
      color: t.primary,
      fontWeight: FontWeight.w600,
      fontSize: 11,
      decoration: TextDecoration.underline,
      decorationColor: t.primary,
    );
    final sepStyle = AppTextStyles.caption.copyWith(color: t.inkSoft, fontSize: 11);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => WebViewScreen.open(context, title: 'Privacy Policy', url: '$base/privacy-policy'),
          child: Text('Privacy Policy', style: linkStyle),
        ),
        Text('  ·  ', style: sepStyle),
        GestureDetector(
          onTap: () => WebViewScreen.open(context, title: 'Terms & Conditions', url: '$base/terms-and-conditions'),
          child: Text('Terms & Conditions', style: linkStyle),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(FlatNestTheme t) {
    return InputDecoration(
      filled: true,
      fillColor: t.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: t.borderSoft),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: t.borderSoft),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: t.primary, width: 1.5),
      ),
    );
  }
}
