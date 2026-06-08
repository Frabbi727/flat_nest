import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

enum ChatStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('rejected')
  rejected,
  @JsonValue('unknown')
  unknown;

  String get label {
    switch (this) {
      case ChatStatus.accepted:
        return 'Accepted';
      case ChatStatus.rejected:
        return 'Rejected';
      case ChatStatus.pending:
      case ChatStatus.unknown:
        return 'Pending';
    }
  }
}

@JsonSerializable()
class ChatUserModel {
  final String id;
  final String name;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  const ChatUserModel({required this.id, required this.name, this.avatarUrl});

  factory ChatUserModel.fromJson(Map<String, dynamic> json) => _$ChatUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatUserModelToJson(this);

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

@JsonSerializable()
class ChatListingModel {
  final String id;
  final String title;
  final String? area;

  const ChatListingModel({required this.id, required this.title, this.area});

  factory ChatListingModel.fromJson(Map<String, dynamic> json) => _$ChatListingModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatListingModelToJson(this);
}

@JsonSerializable()
class ChatMessageModel {
  final String id;
  @JsonKey(name: 'chat_id')
  final String chatId;
  @JsonKey(name: 'sender_id')
  final String senderId;
  final ChatUserModel? sender;
  final String text;
  @JsonKey(name: 'is_read', defaultValue: false)
  final bool isRead;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const ChatMessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    this.sender,
    required this.text,
    required this.isRead,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => _$ChatMessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);
}

@JsonSerializable()
class ChatModel {
  final String id;
  final ChatListingModel listing;
  @JsonKey(name: 'other_user')
  final ChatUserModel otherUser;
  @JsonKey(name: 'last_message')
  final ChatMessageModel? lastMessage;
  @JsonKey(name: 'unread_count', defaultValue: 0)
  final int unreadCount;
  @JsonKey(name: 'status', fromJson: statusFromJson)
  final ChatStatus status;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const ChatModel({
    required this.id,
    required this.listing,
    required this.otherUser,
    this.lastMessage,
    required this.unreadCount,
    required this.status,
    required this.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    // Basic null check for critical nested objects to avoid "type 'Null' is not a subtype of type 'Map<String, dynamic>'"
    if (json['listing'] == null || json['other_user'] == null) {
      throw const FormatException('Missing required chat data');
    }
    return _$ChatModelFromJson(json);
  }
  Map<String, dynamic> toJson() => _$ChatModelToJson(this);

  ChatModel copyWith({
    String? id,
    ChatListingModel? listing,
    ChatUserModel? otherUser,
    ChatMessageModel? lastMessage,
    int? unreadCount,
    ChatStatus? status,
    String? updatedAt,
  }) {
    return ChatModel(
      id: id ?? this.id,
      listing: listing ?? this.listing,
      otherUser: otherUser ?? this.otherUser,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static ChatStatus statusFromJson(String? value) {
    switch (value?.toLowerCase()) {
      case 'accepted':
        return ChatStatus.accepted;
      case 'rejected':
        return ChatStatus.rejected;
      case 'pending':
        return ChatStatus.pending;
      default:
        return ChatStatus.pending; // Default to pending if null or unknown
    }
  }
}
