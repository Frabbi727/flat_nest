// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersionModel _$AppVersionModelFromJson(Map<String, dynamic> json) =>
    AppVersionModel(
      androidBuildNumber: _toNullableInt(json['androidBuildNumber']),
      iosBuildNumber: _toNullableInt(json['iosBuildNumber']),
      updateType: json['update_type'] as String?,
    );

Map<String, dynamic> _$AppVersionModelToJson(AppVersionModel instance) =>
    <String, dynamic>{
      'androidBuildNumber': instance.androidBuildNumber,
      'iosBuildNumber': instance.iosBuildNumber,
      'update_type': instance.updateType,
    };
