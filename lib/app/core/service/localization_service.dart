import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationService extends GetxService {
  final Rx<Locale> _locale = const Locale('en', 'US').obs;
  Locale get locale => _locale.value;

  Future<LocalizationService> init() async {
    return this;
  }

  void updateLocale(Locale newLocale) {
    _locale.value = newLocale;
    Get.updateLocale(newLocale);
    // In a real app, save to cache here
  }

  bool get isBangla => _locale.value.languageCode == 'bn';

  void toggleLocale() {
    if (isBangla) {
      updateLocale(const Locale('en', 'US'));
    } else {
      updateLocale(const Locale('bn', 'BD'));
    }
  }
}
