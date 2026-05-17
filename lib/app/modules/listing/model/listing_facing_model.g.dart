// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_facing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListingFacingModel _$ListingFacingModelFromJson(Map<String, dynamic> json) =>
    ListingFacingModel(
      id: (json['id'] as num).toInt(),
      label: json['label'] as String,
      slug: json['slug'] as String,
    );

Map<String, dynamic> _$ListingFacingModelToJson(ListingFacingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'slug': instance.slug,
    };
