import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/register_controller.dart';
import '../widget/reg_chrome.dart';
import '../widget/fn_field.dart';

class RegisterStep1View extends GetView<RegisterController> {
  const RegisterStep1View({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return RegChrome(
      t: t,
      step: 0,
      onBack: controller.goBack,
      title: 'Create your account',
      subtitle: 'A few details and you\'re in. We\'ll never share your information.',
      child: Obx(() {
        final pwStrength = controller.passwordStrength;
        final pwColors = [t.error, t.error, t.warning, t.primary, t.success];
        final pwLabels = ['Too short', 'Weak', 'Fair', 'Good', 'Strong'];
        final name = controller.nameController.text;
        final email = controller.emailController.text;
        final password = controller.passwordController.text;
        final phone = controller.phoneController.text;

        bool nameOk = name.split(' ').where((w) => w.isNotEmpty).length >= 2;
        bool emailOk = GetUtils.isEmail(email);
        bool passOk = password.length >= 8;
        bool phoneOk = phone.replaceAll(RegExp(r'\D'), '').length >= 9;

        FieldState stateFor(bool ok, String val) {
          if (val.isEmpty) return FieldState.idle;
          return ok ? FieldState.valid : FieldState.error;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            // Full name
            FNField(
              t: t,
              label: 'Full name',
              placeholder: 'e.g. Rashid Karim',
              controller: controller.nameController,
              state: stateFor(nameOk, name),
              error: name.isNotEmpty && !nameOk
                  ? 'Please enter your first and last name.'
                  : null,
              leadingIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            // Email
            FNField(
              t: t,
              label: 'Email address',
              placeholder: 'you@example.com',
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              state: stateFor(emailOk, email),
              error: email.isNotEmpty && !emailOk
                  ? 'Enter a valid email address.'
                  : null,
              leadingIcon: Icons.mail_outline,
            ),
            const SizedBox(height: 16),
            // Password
            FNField(
              t: t,
              label: 'Password',
              placeholder: 'At least 8 characters',
              controller: controller.passwordController,
              obscureText: !controller.showPassword.value,
              state: stateFor(passOk, password),
              leadingIcon: Icons.lock_outline,
              trailing: TextButton(
                onPressed: controller.togglePassword,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  controller.showPassword.value ? 'Hide' : 'Show',
                  style: TextStyle(
                    color: t.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            if (password.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: List.generate(4, (i) {
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: i < pwStrength
                                  ? pwColors[pwStrength]
                                  : t.borderSoft,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    pwLabels[pwStrength],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color:
                          pwStrength >= 3 ? t.success : t.inkMid,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            // Phone
            FNField(
              t: t,
              label: 'Phone number',
              placeholder: '1712 345 678',
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              state: stateFor(phoneOk, phone),
              fixedPrefix: '+880',
              hint: "We'll verify this number.",
            ),
            const SizedBox(height: 12),
            Text(
              "By continuing, you agree to FlatNest's Terms and Privacy Policy.",
              style: TextStyle(fontSize: 12, color: t.inkSoft, height: 1.5),
            ),
            const SizedBox(height: 24),
            _ContinueButton(
              t: t,
              enabled: controller.step1Valid,
              loading: controller.isLoading,
              onTap: controller.submitStep1,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(fontSize: 13, color: t.inkMid),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 13,
                      color: t.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
          ],
        );
      }),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final FlatNestTheme t;
  final bool enabled;
  final bool loading;
  final VoidCallback onTap;

  const _ContinueButton({
    required this.t,
    required this.enabled,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (enabled && !loading) ? onTap : null,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: enabled ? t.primary : t.bgAlt,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: loading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              )
            : Text(
                'Continue →',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: enabled ? Colors.white : t.inkFaint,
                ),
              ),
      ),
    );
  }
}
