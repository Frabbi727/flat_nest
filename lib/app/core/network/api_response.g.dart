// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

part of 'api_response.dart';

// ── ApiResponse ───────────────────────────────────────────────────────────────

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiResponse<T>(
      success: json['success'] as bool,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      message: json['message'] as String?,
      code: json['code'] as String?,
      errors: (json['errors'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(
          k,
          (v as List<dynamic>).map((e) => e as String).toList(),
        ),
      ),
      meta: json['meta'] == null
          ? null
          : PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'success': instance.success,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
      'message': instance.message,
      'code': instance.code,
      'errors': instance.errors,
      'meta': instance.meta?.toJson(),
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJsonT,
) =>
    input == null ? null : fromJsonT(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJsonT,
) =>
    input == null ? null : toJsonT(input);

// ── PaginationMeta ────────────────────────────────────────────────────────────

PaginationMeta _$PaginationMetaFromJson(Map<String, dynamic> json) =>
    PaginationMeta(
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
    );

Map<String, dynamic> _$PaginationMetaToJson(PaginationMeta instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
    };
