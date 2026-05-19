// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_facing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

int _parseId(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? 0;
}

ListingFacingModel _$ListingFacingModelFromJson(Map<String, dynamic> json) =>
    ListingFacingModel(
      id: _parseId(json['id']),
      label: json['label'] as String,
      slug: json['slug'] as String,
    );

Map<String, dynamic> _$ListingFacingModelToJson(ListingFacingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'slug': instance.slug,
    };
