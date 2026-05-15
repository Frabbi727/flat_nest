import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ErrorInterceptor extends Interceptor {
  final Logger _logger = Logger();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = 'Something went wrong';

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Connection timed out';
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final data = err.response?.data;
        
        if (statusCode == 401) {
          errorMessage = 'Session expired. Please login again.';
        } else if (data is Map && data.containsKey('message')) {
          errorMessage = data['message'];
        } else {
          errorMessage = 'Error $statusCode: ${err.message}';
        }
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request cancelled';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'No internet connection';
        break;
      default:
        errorMessage = 'Unexpected error occurred';
    }

    _logger.e('API Error: $errorMessage', error: err);

    // Create a customized exception
    final customError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: errorMessage,
    );

    return handler.next(customError);
  }
}
