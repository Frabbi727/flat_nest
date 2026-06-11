import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../service/auth_service.dart';
import '../../route/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthService>();
    if (!auth.isAuthenticated) {
      return const RouteSettings(name: Routes.login);
    }
    final user = auth.currentUser;
    if (user?.isComplete == false) {
      final step = user?.role != null ? 3 : 2;
      return RouteSettings(name: Routes.register, arguments: {'step': step});
    }
    return null;
  }
}
