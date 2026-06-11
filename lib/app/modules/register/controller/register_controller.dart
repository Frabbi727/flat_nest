import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/utils/image_compressor.dart';
import '../../../core/model/role_model.dart';
import '../../../core/network/resource.dart';
import '../../../core/service/auth_service.dart';
import '../../../core/service/meta_service.dart';
import '../../../modules/auth/repository/auth_repository.dart';
import '../../../route/app_routes.dart';

class RegisterController extends BaseController {
  final AuthRepository _authRepository;
  final AuthService _authService = Get.find<AuthService>();
  final MetaService _metaService = Get.find<MetaService>();

  RegisterController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  List<RoleModel> get availableRoles => _metaService.roles;

  // Step tracking
  final currentStep = 0.obs;
  final isGoogleUser = false.obs;

  // Step 1 — Basic info
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final showPassword = false.obs;
  final showConfirmPassword = false.obs;

  // Bumped by text-controller listeners so Obx re-renders on every keystroke
  final formTick = 0.obs;

  // Step 2 — Role + DOB
  final selectedRole = RxnString();
  final dobDay = 14.obs;
  final dobMonth = 6.obs;
  final dobYear = 1998.obs;

  // Step 3 — Avatar (path chosen on device)
  final avatarPath = RxnString();
  final _picker = ImagePicker();

  void _tick() => formTick.value++;

  @override
  void onInit() {
    super.onInit();
    _metaService.loadRoles();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['step'] != null) {
      currentStep.value = (args['step'] as int) - 1;
    }
    isGoogleUser.value = args?['isGoogleUser'] as bool? ?? false;
    for (final c in [
      nameController,
      emailController,
      passwordController,
      confirmPasswordController,
      phoneController,
    ]) {
      c.addListener(_tick);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void togglePassword() => showPassword.value = !showPassword.value;
  void toggleConfirmPassword() => showConfirmPassword.value = !showConfirmPassword.value;

  void goBack() {
    if (currentStep.value == 0) {
      Get.back();
    } else {
      currentStep.value--;
    }
  }

  // Step 1: Register basic info
  void submitStep1() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;
    final phone = phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty || phone.isEmpty) {
      showError('Please fill all fields');
      return;
    }

    // Validate email
    if (!GetUtils.isEmail(email)) {
      showError('Please enter a valid email address');
      return;
    }
    if (password.length < 8) {
      showError('Password must be at least 8 characters');
      return;
    }
    if (password != confirm) {
      showError('Passwords do not match');
      return;
    }

    showLoading();
    final result = await _authRepository.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
    hideLoading();

    switch (result) {
      case Success(data: final authResponse?):
        await _authService.login(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
        );
        _authService.saveUser(authResponse.user);
        currentStep.value = 1;
      case Success():
        showError('Registration failed');
      case Error(message: final msg):
        showError(msg);
    }
  }

  // Step 1 (Google users only): Save phone + password
  void submitGoogleBasicInfo() async {
    final phone = phoneController.text.trim();
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;

    if (phone.isEmpty || password.isEmpty || confirm.isEmpty) {
      showError('Please fill all fields');
      return;
    }
    if (password.length < 8) {
      showError('Password must be at least 8 characters');
      return;
    }
    if (password != confirm) {
      showError('Passwords do not match');
      return;
    }

    showLoading();
    final result = await _authRepository.registerBasic(
      phone: phone,
      password: password,
    );
    hideLoading();

    switch (result) {
      case Success(data: final res?):
        _authService.saveUser(res.user);
        currentStep.value = 1;
      case Success():
        showError('Something went wrong');
      case Error(message: final msg):
        showError(msg);
    }
  }

  // Step 2: Save role + DOB
  void submitStep2() async {
    if (selectedRole.value == null) {
      showError('Please select your role');
      return;
    }

    showLoading();
    final result = await _authRepository.saveDetails(
      role: selectedRole.value!,
     // dateOfBirth: dob,
    );
    hideLoading();

    switch (result) {
      case Success(data: final res?):
        _authService.saveUser(res.user);
        currentStep.value = 2;
      case Success():
        showError('Something went wrong');
      case Error(message: final msg):
        showError(msg);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final xfile = await _picker.pickImage(source: source);
    if (xfile == null) return;
    try {
      final compressed = await ImageCompressor.compress(File(xfile.path));
      avatarPath.value = compressed.path;
    } catch (_) {
      showError('Could not process image. Please try another photo.');
    }
  }

  // Step 3: Upload avatar then go to home
  void finishRegistration() async {
    final path = avatarPath.value;
    if (path == null) {
      showError('Please add a profile photo to continue');
      return;
    }

    showLoading();
    final result = await _authRepository.uploadAvatar(path);
    hideLoading();

    switch (result) {
      case Success(data: final res?):
        final tempPath = avatarPath.value;
        if (tempPath != null) {
          try { await File(tempPath).delete(); } catch (_) {}
        }
        _authService.saveUser(res.user);
        _navigateToHome();
      case Success():
        showError('Something went wrong');
      case Error(message: final msg):
        showError(msg);
    }
  }

  void _navigateToHome() {
    final user = _authService.currentUser;
    if (user?.isOwner == true) {
      Get.offAllNamed(Routes.ownerHome);
    } else {
      Get.offAllNamed(Routes.renterHome);
    }
  }

  String get dobLabel {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${dobDay.value.toString().padLeft(2, '0')} ${months[dobMonth.value - 1]} ${dobYear.value}';
  }

  int get age => DateTime.now().year - dobYear.value;

  int get passwordStrength {
    final p = passwordController.text;
    int s = 0;
    if (p.length >= 8) s++;
    if (p.contains(RegExp(r'[A-Z]'))) s++;
    if (p.contains(RegExp(r'[0-9]'))) s++;
    if (p.contains(RegExp(r'[^A-Za-z0-9]'))) s++;
    return s;
  }

  bool get googleBasicValid {
    final phone = phoneController.text.trim();
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;
    return phone.replaceAll(RegExp(r'\D'), '').length == 11 &&
        password.length >= 8 &&
        password == confirm;
  }

  bool get step1Valid {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;
    final phone = phoneController.text.trim();
    return name.split(' ').where((w) => w.isNotEmpty).length >= 2 &&
        GetUtils.isEmail(email) &&
        password.length >= 8 &&
        password == confirm &&
        phone.replaceAll(RegExp(r'\D'), '').length == 11;
  }
}
