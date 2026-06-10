class BannerResponse {
  final bool success;
  final BannerData? data;
  final String? message;

  BannerResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory BannerResponse.fromJson(Map<dynamic, dynamic> json) {
    return BannerResponse(
      success: _toBool(json['success']),
      data: json['data'] != null ? BannerData.fromJson(Map<String, dynamic>.from(json['data'])) : null,
      message: json['message']?.toString(),
    );
  }
}

class BannerData {
  final int id;
  final String title;
  final String? description;
  final bool isActive;
  final List<BannerImage> images;

  BannerData({
    required this.id,
    required this.title,
    this.description,
    required this.isActive,
    required this.images,
  });

  factory BannerData.fromJson(Map<dynamic, dynamic> json) {
    var list = json['images'] as List? ?? [];
    return BannerData(
      id: _toInt(json['id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      isActive: _toBool(json['is_active']),
      images: list.map((i) => BannerImage.fromJson(Map<String, dynamic>.from(i))).toList(),
    );
  }
}

class BannerImage {
  final int id;
  final int bannerId;
  final String imageUrl;
  final String? targetUrl;
  final int order;
  final bool isActive;

  BannerImage({
    required this.id,
    required this.bannerId,
    required this.imageUrl,
    this.targetUrl,
    required this.order,
    required this.isActive,
  });

  factory BannerImage.fromJson(Map<dynamic, dynamic> json) {
    return BannerImage(
      id: _toInt(json['id']),
      bannerId: _toInt(json['banner_id']),
      imageUrl: json['image_url']?.toString() ?? '',
      targetUrl: json['target_url']?.toString(),
      order: _toInt(json['order']),
      isActive: _toBool(json['is_active']),
    );
  }
}

bool _toBool(dynamic v) {
  if (v == null) return false;
  if (v is bool) return v;
  if (v is int) return v == 1;
  if (v is String) return v.toLowerCase() == 'true' || v == '1';
  return false;
}

int _toInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v) ?? 0;
  return 0;
}
