// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUserModel _$ChatUserModelFromJson(Map<String, dynamic> json) =>
    ChatUserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$ChatUserModelToJson(ChatUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar_url': instance.avatarUrl,
    };

ChatListingModel _$ChatListingModelFromJson(Map<String, dynamic> json) =>
    ChatListingModel(
      id: json['id'] as String,
      title: json['title'] as String,
      area: json['area'] as String?,
    );

Map<String, dynamic> _$ChatListingModelToJson(ChatListingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'area': instance.area,
    };

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    ChatMessageModel(
      id: json['id'] as String,
      chatId: json['chat_id'] as String,
      senderId: json['sender_id'] as String,
      sender: json['sender'] == null
          ? null
          : ChatUserModel.fromJson(json['sender'] as Map<String, dynamic>),
      text: json['text'] as String,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$ChatMessageModelToJson(ChatMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chat_id': instance.chatId,
      'sender_id': instance.senderId,
      'sender': instance.sender,
      'text': instance.text,
      'is_read': instance.isRead,
      'created_at': instance.createdAt,
    };

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => ChatModel(
  id: json['id'] as String,
  listing: ChatListingModel.fromJson(json['listing'] as Map<String, dynamic>),
  otherUser: ChatUserModel.fromJson(json['other_user'] as Map<String, dynamic>),
  lastMessage: json['last_message'] == null
      ? null
      : ChatMessageModel.fromJson(json['last_message'] as Map<String, dynamic>),
  unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
  status: ChatModel.statusFromJson(json['status'] as String?),
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
  'id': instance.id,
  'listing': instance.listing,
  'other_user': instance.otherUser,
  'last_message': instance.lastMessage,
  'unread_count': instance.unreadCount,
  'status': _$ChatStatusEnumMap[instance.status]!,
  'updated_at': instance.updatedAt,
};

const _$ChatStatusEnumMap = {
  ChatStatus.pending: 'pending',
  ChatStatus.accepted: 'accepted',
  ChatStatus.rejected: 'rejected',
  ChatStatus.unknown: 'unknown',
};
