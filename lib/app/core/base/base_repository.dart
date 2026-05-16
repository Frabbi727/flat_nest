import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../network/api_response.dart';
import '../network/resource.dart';

abstract class BaseRepository {
  final ApiClient apiClient;

  BaseRepository({required this.apiClient});

  // ── Response parsers ────────────────────────────────────────────────────────

  /// Unwraps a single-object envelope: `{ "success": true, "data": {} }`
  Resource<T> parseResponse<T>(
    Response response,
    T Function(Map<String, dynamic> json) fromData,
  ) {
    final body = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (j) => fromData(j as Map<String, dynamic>),
    );
    if (body.success && body.data != null) {
      return Success(data: body.data, statusCode: response.statusCode ?? 200);
    }
    return Error(body.errorMessage, statusCode: response.statusCode ?? 500);
  }

  /// Unwraps a list envelope: `{ "success": true, "data": [] }`
  Resource<List<T>> parseListResponse<T>(
    Response response,
    T Function(Map<String, dynamic> json) fromData,
  ) {
    final body = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (j) => (j as List)
          .map((e) => fromData(e as Map<String, dynamic>))
          .toList(),
    );
    if (body.success) {
      return Success(data: body.data ?? [], statusCode: response.statusCode ?? 200);
    }
    return Error(body.errorMessage, statusCode: response.statusCode ?? 500);
  }

  /// Unwraps a void envelope: `{ "success": true, "data": null }`
  Resource<void> parseVoidResponse(Response response) {
    final body = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (_) => null,
    );
    if (body.success) return const Success(data: null, statusCode: 200);
    return Error(body.errorMessage, statusCode: response.statusCode ?? 500);
  }

  // ── Error helpers ───────────────────────────────────────────────────────────

  /// Extracts the human-readable message the ErrorInterceptor placed in e.error,
  /// falling back to the raw response body or the generic Dio message.
  String parseError(Object e) {
    if (e is DioException) {
      final interceptorMsg = e.error?.toString();
      if (interceptorMsg != null && interceptorMsg.isNotEmpty) {
        return interceptorMsg;
      }
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
