// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmenityModel _$AmenityModelFromJson(Map<String, dynamic> json) => AmenityModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      label: json['label'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$AmenityModelToJson(AmenityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'label': instance.label,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

Map<String, dynamic> _$ListingPhotoModelToJson(ListingPhotoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'position': instance.position,
    };

ListingOwnerModel _$ListingOwnerModelFromJson(Map<String, dynamic> json) =>
    ListingOwnerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$ListingOwnerModelToJson(ListingOwnerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'avatar_url': instance.avatarUrl,
    };

ListingModel _$ListingModelFromJson(Map<String, dynamic> json) => ListingModel(
      id: json['id'] as String,
      title: json['title'] as String,
      area: json['area'] as String?,
      roadAndHouse: json['road_and_house'] as String?,
      availableFrom: json['available_from'] as String?,
      floorNo: _toNullableInt(json['floor_no']),
      facingId: _toNullableInt(json['facing_id']),
      facing: json['facing'] == null
          ? null
          : ListingFacingModel.fromJson(
              json['facing'] as Map<String, dynamic>),
      road: json['road'] as String?,
      houseName: json['house_name'] as String?,
      block: json['block'] as String?,
      section: json['section'] as String?,
      ownerName: json['owner_name'] as String?,
      ownerPhone: json['owner_phone'] as String?,
      ownerAltPhone: json['owner_alt_phone'] as String?,
      ownerEmail: json['owner_email'] as String?,
      preferredContact: json['preferred_contact'] as String?,
      divisionId: _toNullableInt(json['division_id']),
      districtId: _toNullableInt(json['district_id']),
      upazilaId: _toNullableInt(json['upazila_id']),
      unionId: _toNullableInt(json['union_id']),
      type: _typeReadValue(json, 'type') as String,
      price: _toInt(json['price']),
      deposit: _toNullableInt(json['deposit']),
      beds: _toNullableInt(json['beds']),
      baths: _toNullableInt(json['baths']),
      size: _toNullableInt(json['size']),
      description: json['description'] as String?,
      status: _statusReadValue(json, 'status') as String,
      statusLabel: _statusLabelReadValue(json, 'status_label') as String,
      views: _toInt(json['views']),
      lat: _toNullableDouble(json['coord_x']),
      lng: _toNullableDouble(json['coord_y']),
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => AmenityModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      owner: json['owner'] == null
          ? null
          : ListingOwnerModel.fromJson(json['owner'] as Map<String, dynamic>),
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => ListingPhotoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: _createdAtFromJson(json['created_at']),
    );

Map<String, dynamic> _$ListingModelToJson(ListingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'area': instance.area,
      'road_and_house': instance.roadAndHouse,
      'available_from': instance.availableFrom,
      'floor_no': instance.floorNo,
      'facing_id': instance.facingId,
      'facing': instance.facing?.toJson(),
      'road': instance.road,
      'house_name': instance.houseName,
      'block': instance.block,
      'section': instance.section,
      'owner_name': instance.ownerName,
      'owner_phone': instance.ownerPhone,
      'owner_alt_phone': instance.ownerAltPhone,
      'owner_email': instance.ownerEmail,
      'preferred_contact': instance.preferredContact,
      'division_id': instance.divisionId,
      'district_id': instance.districtId,
      'upazila_id': instance.upazilaId,
      'union_id': instance.unionId,
      'type': instance.type,
      'price': instance.price,
      'deposit': instance.deposit,
      'beds': instance.beds,
      'baths': instance.baths,
      'size': instance.size,
      'description': instance.description,
      'status': instance.status,
      'status_label': instance.statusLabel,
      'views': instance.views,
      'coord_x': instance.lat,
      'coord_y': instance.lng,
      'amenities': instance.amenities.map((e) => e.toJson()).toList(),
      'owner': instance.owner?.toJson(),
      'photos': instance.photos.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt,
    };

OwnerListingModel _$OwnerListingModelFromJson(Map<String, dynamic> json) =>
    OwnerListingModel(
      id: json['id'] as String,
      title: json['title'] as String,
      area: json['area'] as String?,
      roadAndHouse: json['road_and_house'] as String?,
      availableFrom: json['available_from'] as String?,
      floorNo: _toNullableInt(json['floor_no']),
      facingId: _toNullableInt(json['facing_id']),
      facing: json['facing'] == null
          ? null
          : ListingFacingModel.fromJson(
              json['facing'] as Map<String, dynamic>),
      road: json['road'] as String?,
      houseName: json['house_name'] as String?,
      block: json['block'] as String?,
      section: json['section'] as String?,
      ownerName: json['owner_name'] as String?,
      ownerPhone: json['owner_phone'] as String?,
      ownerAltPhone: json['owner_alt_phone'] as String?,
      ownerEmail: json['owner_email'] as String?,
      preferredContact: json['preferred_contact'] as String?,
      divisionId: _toNullableInt(json['division_id']),
      districtId: _toNullableInt(json['district_id']),
      upazilaId: _toNullableInt(json['upazila_id']),
      unionId: _toNullableInt(json['union_id']),
      type: _typeReadValue(json, 'type') as String,
      price: _toInt(json['price']),
      deposit: _toNullableInt(json['deposit']),
      beds: _toNullableInt(json['beds']),
      baths: _toNullableInt(json['baths']),
      size: _toNullableInt(json['size']),
      description: json['description'] as String?,
      status: _statusReadValue(json, 'status') as String,
      statusLabel: _statusLabelReadValue(json, 'status_label') as String,
      views: _toInt(json['views']),
      lat: _toNullableDouble(json['coord_x']),
      lng: _toNullableDouble(json['coord_y']),
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => AmenityModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      owner: json['owner'] == null
          ? null
          : ListingOwnerModel.fromJson(json['owner'] as Map<String, dynamic>),
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => ListingPhotoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: _createdAtFromJson(json['created_at']),
      inquiries: _toInt(json['inquiries']),
      rejectionReason: json['rejection_reason'] as String?,
    );

Map<String, dynamic> _$OwnerListingModelToJson(OwnerListingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'area': instance.area,
      'road_and_house': instance.roadAndHouse,
      'available_from': instance.availableFrom,
      'floor_no': instance.floorNo,
      'facing_id': instance.facingId,
      'facing': instance.facing?.toJson(),
      'road': instance.road,
      'house_name': instance.houseName,
      'block': instance.block,
      'section': instance.section,
      'owner_name': instance.ownerName,
      'owner_phone': instance.ownerPhone,
      'owner_alt_phone': instance.ownerAltPhone,
      'owner_email': instance.ownerEmail,
      'preferred_contact': instance.preferredContact,
      'division_id': instance.divisionId,
      'district_id': instance.districtId,
      'upazila_id': instance.upazilaId,
      'union_id': instance.unionId,
      'type': instance.type,
      'price': instance.price,
      'deposit': instance.deposit,
      'beds': instance.beds,
      'baths': instance.baths,
      'size': instance.size,
      'description': instance.description,
      'status': instance.status,
      'status_label': instance.statusLabel,
      'views': instance.views,
      'coord_x': instance.lat,
      'coord_y': instance.lng,
      'amenities': instance.amenities.map((e) => e.toJson()).toList(),
      'owner': instance.owner?.toJson(),
      'photos': instance.photos.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt,
      'inquiries': instance.inquiries,
      'rejection_reason': instance.rejectionReason,
    };
