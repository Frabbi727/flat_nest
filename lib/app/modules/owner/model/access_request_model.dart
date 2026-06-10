import 'package:json_annotation/json_annotation.dart';

part 'access_request_model.g.dart';

// ── Nested models ─────────────────────────────────────────────────────────────

@JsonSerializable()
class AccessRequestListingSnippet {
  final String id;
  final String title;

  const AccessRequestListingSnippet({required this.id, required this.title});

  factory AccessRequestListingSnippet.fromJson(Map<String, dynamic> json) =>
      _$AccessRequestListingSnippetFromJson(json);

  Map<String, dynamic> toJson() => _$AccessRequestListingSnippetToJson(this);
}

@JsonSerializable()
class AccessRequestRequester {
  final String id;
  final String name;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  const AccessRequestRequester({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  factory AccessRequestRequester.fromJson(Map<String, dynamic> json) =>
      _$AccessRequestRequesterFromJson(json);

  Map<String, dynamic> toJson() => _$AccessRequestRequesterToJson(this);

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

// ── AccessRequestModel ────────────────────────────────────────────────────────

@JsonSerializable()
class AccessRequestModel {
  final String id;
  final String status; // pending | accepted | rejected
  final AccessRequestListingSnippet? listing;
  final AccessRequestRequester? requester;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  const AccessRequestModel({
    required this.id,
    required this.status,
    this.listing,
    this.requester,
    this.createdAt,
  });

  factory AccessRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AccessRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccessRequestModelToJson(this);
}

// ── Paginated wrapper ─────────────────────────────────────────────────────────

class AccessRequestsPage {
  final List<AccessRequestModel> requests;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const AccessRequestsPage({
    required this.requests,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  bool get hasMore => currentPage < lastPage;
}
