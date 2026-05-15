import 'package:dio/dio.dart';
import 'package:get/get.dart' as get_x;
import '../../service/auth_service.dart';
import '../api_client.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final authService = get_x.Get.find<AuthService>();
    final token = authService.token;

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if error is 401 (Unauthorized)
    if (err.response?.statusCode == 401) {
      final authService = get_x.Get.find<AuthService>();
      
      // Attempt to refresh the token
      final isRefreshed = await authService.refreshAuthToken();
      
      if (isRefreshed) {
        // If refreshed, retry the original request with the new token
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer ${authService.token}';
        
        try {
          // Get the ApiClient's Dio instance to retry
          final dio = get_x.Get.find<ApiClient>().dio;
          final response = await dio.fetch(options);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      } else {
        // If refresh fails, logout and proceed with error
        await authService.logout();
      }
    }
    
    return handler.next(err);
  }
}
