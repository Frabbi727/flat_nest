class AppVersionModel {
  final int? androidBuildNumber;
  final int? iosBuildNumber;
  final String? updateType;

  const AppVersionModel({
    this.androidBuildNumber,
    this.iosBuildNumber,
    this.updateType,
  });

  factory AppVersionModel.fromJson(Map<String, dynamic> json) {
    int? _parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString());
    }

    return AppVersionModel(
      androidBuildNumber: _parseInt(json['android_build_number']),
      iosBuildNumber: _parseInt(json['ios_build_number']),
      updateType: json['update_type'] as String?,
    );
  }
}
