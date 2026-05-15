import 'package:json_annotation/json_annotation.dart';
part 'geo_model.g.dart';
@JsonSerializable()
class GeoItemModel {
  final int id;
  final String name;
  @JsonKey(name: 'bn_name')

  final String? bnName;

  const GeoItemModel({required this.id, required this.name, this.bnName});

  factory GeoItemModel.fromJson(Map<String, dynamic> json) =>
      _$GeoItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeoItemModelToJson(this);

  @override
  String toString() {
    return 'GeoItemModel{id: $id, name: $name, bnName: $bnName}';
  }
}
