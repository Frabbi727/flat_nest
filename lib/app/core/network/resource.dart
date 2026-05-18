import 'error_model.dart';

sealed class Resource<T> {
  const Resource();
}

class Success<T> extends Resource<T> {
  final T? data;
  final List<T> list;
  final int? statusCode;

  const Success({this.data, this.list = const [], this.statusCode});
}

class Error<T> extends Resource<T> {
  final String message;
  final String? messageBn;
  final int? statusCode;
  final String? code;
  final ErrorModel? errorModel;
  final dynamic exception;

  const Error(this.message, {this.messageBn, this.statusCode, this.code, this.errorModel, this.exception});
}
