import 'package:dio/dio.dart';
import '../network/api_client.dart';

abstract class BaseRepository {
  final ApiClient apiClient;

  BaseRepository({required this.apiClient});

  // Extracts the human-readable message that ErrorInterceptor placed in e.error,
  // falling back to the raw response body or the generic Dio message.
  String parseError(Object e) {
    if (e is DioException) {
      // ErrorInterceptor stores the extracted message in e.error
      final interceptorMsg = e.error?.toString();
      if (interceptorMsg != null && interceptorMsg.isNotEmpty) {
        return interceptorMsg;
      }
      // Fallback: try the raw response body
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      return e.message ?? 'Request failed';
    }
    return e.toString();
  }

  int parseStatusCode(Object e) {
    if (e is DioException) return e.response?.statusCode ?? 500;
    return 500;
  }
}
