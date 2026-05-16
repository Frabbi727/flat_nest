class SaveLocationRequest {
  final String area;
  final int divisionId;
  final int districtId;
  final int upazilaId;
  final int unionId;
  final String? roadAndHouse;
  final double? coordX;
  final double? coordY;

  const SaveLocationRequest({
    required this.area,
    required this.divisionId,
    required this.districtId,
    required this.upazilaId,
    required this.unionId,
    this.roadAndHouse,
    this.coordX,
    this.coordY,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'area': area,
      'division_id': divisionId,
      'district_id': districtId,
      'upazila_id': upazilaId,
      'union_id': unionId,
    };
    if (roadAndHouse != null) map['road_and_house'] = roadAndHouse;
    if (coordX != null) map['coord_x'] = coordX;
    if (coordY != null) map['coord_y'] = coordY;
    return map;
  }
}
