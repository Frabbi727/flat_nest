// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

int _parseId(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? 0;
}

GeoItemModel _$GeoItemModelFromJson(Map<String, dynamic> json) => GeoItemModel(
      id: _parseId(json['id']),
      name: json['name'] as String,
      bnName: json['bn_name'] as String?,
    );

Map<String, dynamic> _$GeoItemModelToJson(GeoItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'bn_name': instance.bnName,
    };
