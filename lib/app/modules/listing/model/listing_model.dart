import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../core/network/api_config.dart';
import 'listing_facing_model.dart';

part 'listing_model.g.dart';

// ── Shared converters ─────────────────────────────────────────────────────────

int _toInt(dynamic v) => (v as num?)?.toInt() ?? 0;
int? _toNullableInt(dynamic v) => (v as num?)?.toInt();
double? _toNullableDouble(dynamic v) => (v as num?)?.toDouble();
String _createdAtFromJson(dynamic v) => v as String? ?? '';

// readValue helpers — receive the whole map so we can read sibling keys
dynamic _typeReadValue(Map json, String key) =>
    json['type'] ?? (json['listing_type'] as Map?)?['slug'] ?? '';

dynamic _statusReadValue(Map json, String key) => json['status'] ?? 'draft';

dynamic _statusLabelReadValue(Map json, String key) =>
    json['status_label'] ?? json['status'] ?? 'Draft';

// ── AmenityModel ──────────────────────────────────────────────────────────────

@JsonSerializable()
class AmenityModel {
  final int id;
  final String name;
  final String label;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const AmenityModel({
    required this.id,
    required this.name,
    required this.label,
    this.createdAt,
    this.updatedAt,
  });

  factory AmenityModel.fromJson(Map<String, dynamic> json) =>
      _$AmenityModelFromJson(json);

  Map<String, dynamic> toJson() => _$AmenityModelToJson(this);
}

// ── ListingPhotoModel ─────────────────────────────────────────────────────────

@JsonSerializable()
class ListingPhotoModel {
  final String id;
  final String url;
  final int position;

  const ListingPhotoModel({
    required this.id,
    required this.url,
    required this.position,
  });

  factory ListingPhotoModel.fromJson(Map<String, dynamic> json) {
    final raw = json['url'] as String;
    // Resolve relative paths like /storage/... to a full URL
    final resolvedUrl =
        raw.startsWith('/') ? '${ApiConfig.storageBaseUrl}$raw' : raw;
    return ListingPhotoModel(
      id: json['id'] as String,
      url: resolvedUrl,
      position: (json['position'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => _$ListingPhotoModelToJson(this);
}

// ── ListingOwnerModel ─────────────────────────────────────────────────────────

@JsonSerializable()
class ListingOwnerModel {
  final String id;
  final String name;
  final String? phone;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  const ListingOwnerModel({
    required this.id,
    required this.name,
    this.phone,
    this.avatarUrl,
  });

  factory ListingOwnerModel.fromJson(Map<String, dynamic> json) =>
      _$ListingOwnerModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListingOwnerModelToJson(this);

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

// ── ListingModel ──────────────────────────────────────────────────────────────

@JsonSerializable(explicitToJson: true)
class ListingModel {
  final String id;
  final String title;
  final String? area;
  @JsonKey(name: 'road_and_house')
  final String? roadAndHouse;
  @JsonKey(name: 'available_from')
  final String? availableFrom;
  @JsonKey(name: 'floor_no', fromJson: _toNullableInt)
  final int? floorNo;
  @JsonKey(name: 'facing_id', fromJson: _toNullableInt)
  final int? facingId;
  final ListingFacingModel? facing;
  final String? road;
  @JsonKey(name: 'house_name')
  final String? houseName;
  final String? block;
  final String? section;
  @JsonKey(name: 'owner_name')
  final String? ownerName;
  @JsonKey(name: 'owner_phone')
  final String? ownerPhone;
  @JsonKey(name: 'owner_alt_phone')
  final String? ownerAltPhone;
  @JsonKey(name: 'owner_email')
  final String? ownerEmail;
  @JsonKey(name: 'preferred_contact')
  final String? preferredContact;
  @JsonKey(name: 'division_id', fromJson: _toNullableInt)
  final int? divisionId;
  @JsonKey(name: 'district_id', fromJson: _toNullableInt)
  final int? districtId;
  @JsonKey(name: 'upazila_id', fromJson: _toNullableInt)
  final int? upazilaId;
  @JsonKey(name: 'union_id', fromJson: _toNullableInt)
  final int? unionId;
  // API may return 'type' as a plain string or as a nested listing_type object
  @JsonKey(readValue: _typeReadValue)
  final String type;
  @JsonKey(fromJson: _toInt)
  final int price;
  @JsonKey(fromJson: _toNullableInt)
  final int? deposit;
  @JsonKey(fromJson: _toNullableInt)
  final int? beds;
  @JsonKey(fromJson: _toNullableInt)
  final int? baths;
  @JsonKey(fromJson: _toNullableInt)
  final int? size;
  final String? description;
  @JsonKey(readValue: _statusReadValue)
  final String status;
  @JsonKey(name: 'status_label', readValue: _statusLabelReadValue)
  final String statusLabel;
  @JsonKey(fromJson: _toInt)
  final int views;
  @JsonKey(name: 'coord_x', fromJson: _toNullableDouble)
  final double? coordX;
  @JsonKey(name: 'coord_y', fromJson: _toNullableDouble)
  final double? coordY;
  @JsonKey(defaultValue: [])
  final List<AmenityModel> amenities;
  final ListingOwnerModel? owner;
  @JsonKey(defaultValue: [])
  final List<ListingPhotoModel> photos;
  @JsonKey(name: 'created_at', fromJson: _createdAtFromJson)
  final String createdAt;

  const ListingModel({
    required this.id,
    required this.title,
    this.area,
    this.roadAndHouse,
    this.availableFrom,
    this.floorNo,
    this.facingId,
    this.facing,
    this.road,
    this.houseName,
    this.block,
    this.section,
    this.ownerName,
    this.ownerPhone,
    this.ownerAltPhone,
    this.ownerEmail,
    this.preferredContact,
    this.divisionId,
    this.districtId,
    this.upazilaId,
    this.unionId,
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

  factory ListingModel.fromJson(Map<String, dynamic> json) =>
      _$ListingModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListingModelToJson(this);

  static final _amountFmt = NumberFormat('#,##0.00');

  String get priceFormatted => '৳${_amountFmt.format(price)}';
  String get depositFormatted =>
      deposit != null ? '৳${_amountFmt.format(deposit!)}' : 'N/A';

  String get availableFromFormatted {
    if (availableFrom == null) return 'Available Now';
    final dt = DateTime.tryParse(availableFrom!);
    if (dt == null) return availableFrom!;
    return DateFormat('MMM d, yyyy').format(dt);
  }

  bool get isAvailableNow => availableFrom == null;

  String? get thumbnailUrl => photos.isNotEmpty
      ? photos.reduce((a, b) => a.position < b.position ? a : b).url
      : null;
}

// ── OwnerListingModel ─────────────────────────────────────────────────────────

@JsonSerializable(explicitToJson: true)
class OwnerListingModel extends ListingModel {
  @JsonKey(fromJson: _toInt)
  final int inquiries;
  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;

  const OwnerListingModel({
    required super.id,
    required super.title,
    super.area,
    super.roadAndHouse,
    super.availableFrom,
    super.floorNo,
    super.facingId,
    super.facing,
    super.road,
    super.houseName,
    super.block,
    super.section,
    super.ownerName,
    super.ownerPhone,
    super.ownerAltPhone,
    super.ownerEmail,
    super.preferredContact,
    super.divisionId,
    super.districtId,
    super.upazilaId,
    super.unionId,
    required super.type,
    required super.price,
    super.deposit,
    super.beds,
    super.baths,
    super.size,
    super.description,
    required super.status,
    required super.statusLabel,
    super.views = 0,
    super.coordX,
    super.coordY,
    super.amenities = const [],
    super.owner,
    super.photos = const [],
    required super.createdAt,
    this.inquiries = 0,
    this.rejectionReason,
  });

  factory OwnerListingModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerListingModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OwnerListingModelToJson(this);
}
