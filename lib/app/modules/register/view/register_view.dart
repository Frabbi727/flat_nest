import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/register_controller.dart';
import 'register_step1_view.dart';
import 'register_step2_view.dart';
import 'register_step3_view.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return switch (controller.currentStep.value) {
        0 => const RegisterStep1View(),
        1 => const RegisterStep2View(),
        2 => const RegisterStep3View(),
        _ => const RegisterStep1View(),
      };
    });
  }
}
