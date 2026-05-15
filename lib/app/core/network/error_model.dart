class ErrorModel {
  final String? code;
  final String? details;

  ErrorModel({this.code, this.details});

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      code: json['code'] as String?,
      details: json['details'] as String?,
    );
  }

  @override
  String toString() => 'ErrorModel(code: $code, details: $details)';
}
