class SaveLocationRequest {
  final String? area;
  final int? divisionId;
  final int? districtId;
  final int? upazilaId;
  final int? unionId;
  final String? road;
  final String? houseName;
  final String? block;
  final String? section;
  final double? lat;
  final double? lng;

  const SaveLocationRequest({
    this.area,
    this.divisionId,
    this.districtId,
    this.upazilaId,
    this.unionId,
    this.road,
    this.houseName,
    this.block,
    this.section,
    this.lat,
    this.lng,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (area != null && area!.isNotEmpty) map['area'] = area;
    if (divisionId != null) map['division_id'] = divisionId;
    if (districtId != null) map['district_id'] = districtId;
    if (upazilaId != null) map['upazila_id'] = upazilaId;
    if (unionId != null) map['union_id'] = unionId;
    if (road != null && road!.isNotEmpty) map['road'] = road;
    if (houseName != null && houseName!.isNotEmpty) map['house_name'] = houseName;
    if (block != null && block!.isNotEmpty) map['block'] = block;
    if (section != null && section!.isNotEmpty) map['section'] = section;
    if (lat != null) map['coord_x'] = lat;
    if (lng != null) map['coord_y'] = lng;
    return map;
  }
}
