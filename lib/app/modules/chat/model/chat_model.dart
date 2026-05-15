class ChatUserModel {
  final String id;
  final String name;
  final String? avatarUrl;

  const ChatUserModel({required this.id, required this.name, this.avatarUrl});

  factory ChatUserModel.fromJson(Map<String, dynamic> json) => ChatUserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        avatarUrl: json['avatar_url'] as String?,
      );

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

class ChatListingModel {
  final String id;
  final String title;
  final String? area;

  const ChatListingModel({required this.id, required this.title, this.area});

  factory ChatListingModel.fromJson(Map<String, dynamic> json) => ChatListingModel(
        id: json['id'] as String,
        title: json['title'] as String,
        area: json['area'] as String?,
      );
}

class ChatMessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final ChatUserModel? sender;
  final String text;
  final bool isRead;
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

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => ChatMessageModel(
        id: json['id'] as String,
        chatId: json['chat_id'] as String,
        senderId: json['sender_id'] as String,
        sender: json['sender'] != null
            ? ChatUserModel.fromJson(json['sender'] as Map<String, dynamic>)
            : null,
        text: json['text'] as String,
        isRead: json['is_read'] as bool? ?? false,
        createdAt: json['created_at'] as String,
      );
}

class ChatModel {
  final String id;
  final ChatListingModel listing;
  final ChatUserModel otherUser;
  final ChatMessageModel? lastMessage;
  final int unreadCount;
  final String updatedAt;

  const ChatModel({
    required this.id,
    required this.listing,
    required this.otherUser,
    this.lastMessage,
    required this.unreadCount,
    required this.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json['id'] as String,
        listing: ChatListingModel.fromJson(json['listing'] as Map<String, dynamic>),
        otherUser: ChatUserModel.fromJson(json['other_user'] as Map<String, dynamic>),
        lastMessage: json['last_message'] != null
            ? ChatMessageModel.fromJson(json['last_message'] as Map<String, dynamic>)
            : null,
        unreadCount: json['unread_count'] as int? ?? 0,
        updatedAt: json['updated_at'] as String,
      );
}
