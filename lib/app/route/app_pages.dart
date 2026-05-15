import 'package:get/get.dart';

import '../features/auth/binding/auth_binding.dart';
import '../features/auth/view/login_view.dart';
import '../features/home/binding/home_binding.dart';
import '../features/home/view/home_view.dart';
import '../features/splash/binding/splash_binding.dart';
import '../features/splash/view/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
