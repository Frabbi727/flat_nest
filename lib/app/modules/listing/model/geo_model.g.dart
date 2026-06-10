// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoItemModel _$GeoItemModelFromJson(Map<String, dynamic> json) => GeoItemModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  bnName: json['bn_name'] as String?,
);

Map<String, dynamic> _$GeoItemModelToJson(GeoItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'bn_name': instance.bnName,
    };
