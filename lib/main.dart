import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'app/core/network/api_client.dart';
import 'app/core/cache/cache_manager.dart';
import 'app/core/service/auth_service.dart';
import 'app/core/service/banner_service.dart';
import 'app/core/service/meta_service.dart';
import 'app/core/service/notification_service.dart';
import 'app/core/service/theme_service.dart';
import 'app/core/service/localization_service.dart';
import 'app/core/localization/app_translations.dart';
import 'app/route/app_pages.dart';
import 'app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initServices();

  runApp(const MyApp());
}

Future<void> initServices() async {
  Get.log('Starting services...');

  Get.put(CacheManager(), permanent: true);
  Get.put(ApiClient(), permanent: true);
  await Get.putAsync(() => LocalizationService().init());
  await Get.putAsync(() => ThemeService().init());
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => MetaService().init(), permanent: true);
  await Get.putAsync(() => NotificationService().init(), permanent: true);
  await Get.putAsync(() => BannerService().init(), permanent: true);

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

      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // 👈 required
          // statusBarIconBrightness: Brightness.dark, // adjust if needed
        ),
        child: SafeArea(top: false, bottom: true, child: child!),
      ),
    );
  }
}
