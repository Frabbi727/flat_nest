class AmenityModel {
  final int id;
  final String name;
  final String label;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AmenityModel({
    required this.id,
    required this.name,
    required this.label,
    this.createdAt,
    this.updatedAt,
  });

  factory AmenityModel.fromJson(Map<String, dynamic> json) => AmenityModel(
        id: (json['id'] as num).toInt(),
        name: json['name'] as String,
        label: json['label'] as String,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'label': label,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}

class ListingPhotoModel {
  final String id;
  final String url;
  final int position;

  const ListingPhotoModel({required this.id, required this.url, required this.position});

  factory ListingPhotoModel.fromJson(Map<String, dynamic> json) => ListingPhotoModel(
        id: json['id'] as String,
        url: json['url'] as String,
        position: json['position'] as int,
      );
}

class ListingOwnerModel {
  final String id;
  final String name;
  final String? phone;
  final String? avatarUrl;

  const ListingOwnerModel({
    required this.id,
    required this.name,
    this.phone,
    this.avatarUrl,
  });

  factory ListingOwnerModel.fromJson(Map<String, dynamic> json) => ListingOwnerModel(
        id: json['id'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String?,
        avatarUrl: json['avatar_url'] as String?,
      );

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

class ListingModel {
  final String id;
  final String title;
  final String? area;
  final String? roadAndHouse;
  final String type;
  final int price;
  final int? deposit;
  final int? beds;
  final int? baths;
  final int? size;
  final String? description;
  final String status;
  final String statusLabel;
  final int views;
  final double? coordX;
  final double? coordY;
  final List<AmenityModel> amenities;
  final ListingOwnerModel? owner;
  final List<ListingPhotoModel> photos;
  final String createdAt;

  const ListingModel({
    required this.id,
    required this.title,
    this.area,
    this.roadAndHouse,
    required this.type,
    required this.price,
    this.deposit,
    this.beds,
    this.baths,
    this.size,
    this.description,
    required this.status,
    required this.statusLabel,
    this.views = 0,
    this.coordX,
    this.coordY,
    this.amenities = const [],
    this.owner,
    this.photos = const [],
    required this.createdAt,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) => ListingModel(
        id: json['id'] as String,
        title: json['title'] as String,
        area: json['area'] as String?,
        roadAndHouse: json['road_and_house'] as String?,
        type: json['type'] as String,
        price: json['price'] as int,
        deposit: json['deposit'] as int?,
        beds: json['beds'] as int?,
        baths: json['baths'] as int?,
        size: json['size'] as int?,
        description: json['description'] as String?,
        status: json['status'] as String,
        statusLabel: json['status_label'] as String? ?? json['status'] as String,
        views: json['views'] as int? ?? 0,
        coordX: (json['coord_x'] as num?)?.toDouble(),
        coordY: (json['coord_y'] as num?)?.toDouble(),
        amenities: (json['amenities'] as List<dynamic>?)
                ?.map((e) => AmenityModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        owner: json['owner'] != null
            ? ListingOwnerModel.fromJson(json['owner'] as Map<String, dynamic>)
            : null,
        photos: (json['photos'] as List<dynamic>?)
                ?.map((e) => ListingPhotoModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        createdAt: json['created_at'] as String,
      );

  String get priceFormatted => '৳${_formatNumber(price)}';
  String get depositFormatted => deposit != null ? '৳${_formatNumber(deposit!)}' : 'N/A';

  static String _formatNumber(int n) {
    if (n >= 100000) return '${(n / 100000).toStringAsFixed(1)}L';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}k';
    return n.toString();
  }

  String? get thumbnailUrl => photos.isNotEmpty
      ? photos.reduce((a, b) => a.position < b.position ? a : b).url
      : null;
}

class OwnerListingModel extends ListingModel {
  final int inquiries;

  const OwnerListingModel({
    required super.id,
    required super.title,
    super.area,
    required super.type,
    required super.price,
    super.beds,
    super.baths,
    super.size,
    super.description,
    required super.status,
    required super.statusLabel,
    super.views = 0,
    super.amenities = const [],
    super.photos = const [],
    required super.createdAt,
    this.inquiries = 0,
  });

  factory OwnerListingModel.fromJson(Map<String, dynamic> json) {
    final base = ListingModel.fromJson(json);
    return OwnerListingModel(
      id: base.id,
      title: base.title,
      area: base.area,
      type: base.type,
      price: base.price,
      beds: base.beds,
      baths: base.baths,
      size: base.size,
      description: base.description,
      status: base.status,
      statusLabel: base.statusLabel,
      views: base.views,
      amenities: base.amenities,
      photos: base.photos,
      createdAt: base.createdAt,
      inquiries: json['inquiries'] as int? ?? 0,
    );
  }
}
