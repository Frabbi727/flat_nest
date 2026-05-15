import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/service/theme_service.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../controller/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: [
          IconButton(
            onPressed: () => Get.find<ThemeService>().toggleTheme(),
            icon: const Icon(Icons.brightness_4),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome Back',
                style: AppTextStyles.h1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Login to continue',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              TextField(
                onChanged: (value) => controller.email.value = value,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) => controller.password.value = value,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 32),
              Obx(() => controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: controller.login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                      ),
                      child: const Text('Login'),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
