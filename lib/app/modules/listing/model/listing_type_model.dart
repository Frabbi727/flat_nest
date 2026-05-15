import 'package:json_annotation/json_annotation.dart';

part 'listing_type_model.g.dart';

@JsonSerializable()
class ListingTypeModel {
  final int id;
  final String name;
  final String label;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const ListingTypeModel({
    required this.id,
    required this.name,
    required this.label,
    this.createdAt,
    this.updatedAt,
  });

  factory ListingTypeModel.fromJson(Map<String, dynamic> json) =>
      _$ListingTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListingTypeModelToJson(this);
}
