import 'dart:developer';
import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  final bool enableLogging;

  LoggingInterceptor({this.enableLogging = true});

  void _log(String message) {
    if (!enableLogging) return;
    log(message, name: 'DIO');
  }

  String _formatJson(dynamic data) {
    if (data == null) return 'null';
    return data.toString();
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final startTime = DateTime.now();
    options.extra['startTime'] = startTime;

    final buffer = StringBuffer();

    buffer.writeln('┌──────────────────────── REQUEST ────────────────────────');
    buffer.writeln('│ METHOD : ${options.method}');
    buffer.writeln('│ URL    : ${options.baseUrl}${options.path}');
    buffer.writeln('│ TIME   : $startTime');

    if (options.queryParameters.isNotEmpty) {
      buffer.writeln('│ QUERY  : ${options.queryParameters}');
    }

    if (options.headers.isNotEmpty) {
      buffer.writeln('│ HEADERS: ${options.headers}');
    }

    if (options.data != null) {
      buffer.writeln('│ BODY   : ${_formatJson(options.data)}');
    }

    buffer.writeln('└──────────────────────────────────────────────────────────');

    _log(buffer.toString());

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['startTime'] as DateTime?;
    final duration = startTime != null
        ? DateTime.now().difference(startTime).inMilliseconds
        : null;

    final buffer = StringBuffer();

    buffer.writeln('┌────────────────────── RESPONSE ────────────────────────');
    buffer.writeln('│ STATUS : ${response.statusCode}');
    buffer.writeln('│ URL    : ${response.requestOptions.path}');
    buffer.writeln('│ TIME   : ${duration != null ? '$duration ms' : 'N/A'}');
    buffer.writeln('│ BODY   : ${_formatJson(response.data)}');
    buffer.writeln('└─────────────────────────────────────────────────────────');

    _log(buffer.toString());

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = err.requestOptions.extra['startTime'] as DateTime?;
    final duration = startTime != null
        ? DateTime.now().difference(startTime).inMilliseconds
        : null;

    final buffer = StringBuffer();

    buffer.writeln('┌──────────────────────── ERROR ──────────────────────────');
    buffer.writeln('│ STATUS : ${err.response?.statusCode}');
    buffer.writeln('│ TYPE   : ${err.type}');
    buffer.writeln('│ URL    : ${err.requestOptions.path}');
    buffer.writeln('│ TIME   : ${duration != null ? '$duration ms' : 'N/A'}');
    buffer.writeln('│ MESSAGE: ${err.message}');
    buffer.writeln('│ ERROR  : ${err.error}');
    buffer.writeln('└─────────────────────────────────────────────────────────');

    _log(buffer.toString());

    handler.next(err);
  }
}