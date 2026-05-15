import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiClient {
  late Dio _dio;
  final Logger _logger = Logger();

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com', // Replace with your actual base URL
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token here if needed
          _logger.i('Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.i('Response: ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          _logger.e('Error: ${e.response?.statusCode} ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (_) {
      rethrow;
    }
  }

  // Add other methods (put, delete, etc.) as needed
}
