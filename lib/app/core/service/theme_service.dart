import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeService extends GetxService {
  final RxBool _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;

  Future<ThemeService> init() async {
    return this;
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  ThemeMode get themeMode => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
}
