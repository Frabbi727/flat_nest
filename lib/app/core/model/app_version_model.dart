import 'package:json_annotation/json_annotation.dart';

part 'app_version_model.g.dart';

int? _toNullableInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString());
}

@JsonSerializable()
class AppVersionModel {
  @JsonKey(name: 'androidBuildNumber', fromJson: _toNullableInt)
  final int? androidBuildNumber;
  @JsonKey(name: 'iosBuildNumber', fromJson: _toNullableInt)
  final int? iosBuildNumber;
  @JsonKey(name: 'update_type')
  final String? updateType;

  const AppVersionModel({
    this.androidBuildNumber,
    this.iosBuildNumber,
    this.updateType,
  });

  factory AppVersionModel.fromJson(Map<String, dynamic> json) =>
      _$AppVersionModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppVersionModelToJson(this);
}
