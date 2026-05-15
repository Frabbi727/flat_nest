import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/core/network/api_client.dart';
import 'app/core/service/auth_service.dart';
import 'app/core/service/theme_service.dart';
import 'app/core/service/localization_service.dart';
import 'app/core/localization/app_translations.dart';
import 'app/route/app_pages.dart';
import 'app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initServices();
  
  runApp(const MyApp());
}

Future<void> initServices() async {
  Get.log('Starting services...');
  
  // Initialize ApiClient
  Get.put(ApiClient(), permanent: true);
  
  // Initialize LocalizationService
  await Get.putAsync(() => LocalizationService().init());
  
  // Initialize ThemeService
  await Get.putAsync(() => ThemeService().init());
  
  // Initialize AuthService
  await Get.putAsync(() => AuthService().init());
  
  Get.log('All services started!');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final localizationService = Get.find<LocalizationService>();

    return GetMaterialApp(
      title: 'Falt Nest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeService.themeMode,
      translations: AppTranslations(),
      locale: localizationService.locale,
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.fade,
    );
  }
}
