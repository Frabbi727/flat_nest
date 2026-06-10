// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListingTypeModel _$ListingTypeModelFromJson(Map<String, dynamic> json) =>
    ListingTypeModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      label: json['label'] as String,
      slug: json['slug'] as String? ?? '',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ListingTypeModelToJson(ListingTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'label': instance.label,
      'slug': instance.slug,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
