import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final String id;
  final String kind;
  final String title;
  final String body;
  final String time;
  @JsonKey(name: 'is_unread')
  final bool isUnread;
  @JsonKey(name: 'reference_id')
  final String? referenceId;

  const NotificationModel({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.time,
    required this.isUnread,
    this.referenceId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  NotificationModel copyWith({bool? isUnread}) => NotificationModel(
        id: id,
        kind: kind,
        title: title,
        body: body,
        time: time,
        isUnread: isUnread ?? this.isUnread,
        referenceId: referenceId,
      );
}

class NotificationPageResult {
  final List<NotificationModel> items;
  final int currentPage;
  final int lastPage;
  final int unreadCount;

  const NotificationPageResult({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.unreadCount,
  });
}
