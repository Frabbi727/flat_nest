import 'package:json_annotation/json_annotation.dart';

part 'listing_facing_model.g.dart';

@JsonSerializable()
class ListingFacingModel {
  final int id;
  final String label;
  final String slug;

  const ListingFacingModel({
    required this.id,
    required this.label,
    required this.slug,
  });

  factory ListingFacingModel.fromJson(Map<String, dynamic> json) =>
      _$ListingFacingModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListingFacingModelToJson(this);
}
