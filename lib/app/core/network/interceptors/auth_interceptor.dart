import 'package:dio/dio.dart';
import 'package:get/get.dart' as get_x;
import '../../service/auth_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final authService = get_x.Get.find<AuthService>();
    final token = authService.token;

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    super.onRequest(options, handler);
  }
}
