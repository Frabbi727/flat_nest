// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessRequestListingSnippet _$AccessRequestListingSnippetFromJson(
  Map<String, dynamic> json,
) => AccessRequestListingSnippet(
  id: json['id'] as String,
  title: json['title'] as String,
);

Map<String, dynamic> _$AccessRequestListingSnippetToJson(
  AccessRequestListingSnippet instance,
) => <String, dynamic>{'id': instance.id, 'title': instance.title};

AccessRequestRequester _$AccessRequestRequesterFromJson(
  Map<String, dynamic> json,
) => AccessRequestRequester(
  id: json['id'] as String,
  name: json['name'] as String,
  avatarUrl: json['avatar_url'] as String?,
);

Map<String, dynamic> _$AccessRequestRequesterToJson(
  AccessRequestRequester instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'avatar_url': instance.avatarUrl,
};

AccessRequestModel _$AccessRequestModelFromJson(Map<String, dynamic> json) =>
    AccessRequestModel(
      id: json['id'] as String,
      status: json['status'] as String,
      listing: json['listing'] == null
          ? null
          : AccessRequestListingSnippet.fromJson(
              json['listing'] as Map<String, dynamic>,
            ),
      requester: json['requester'] == null
          ? null
          : AccessRequestRequester.fromJson(
              json['requester'] as Map<String, dynamic>,
            ),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$AccessRequestModelToJson(AccessRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'listing': instance.listing,
      'requester': instance.requester,
      'created_at': instance.createdAt,
    };
