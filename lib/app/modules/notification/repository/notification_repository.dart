import '../../../core/base/base_repository.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/resource.dart';
import '../model/notification_model.dart';

int _parseInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? 0;
}

class NotificationRepository extends BaseRepository {
  NotificationRepository({required super.apiClient});

  Future<Resource<NotificationPageResult>> getNotifications({int page = 1}) async {
    try {
      final response = await apiClient.get(
        path: ApiEndpoints.notifications,
        queryParameters: {'page': page},
      );
      final raw = response.data as Map<String, dynamic>;
      if (raw['success'] == true) {
        final items = (raw['data'] as List)
            .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
            .toList();
        final meta = raw['meta'] as Map<String, dynamic>;
        return Success(
          data: NotificationPageResult(
            items: items,
            currentPage: _parseInt(meta['current_page']),
            lastPage: _parseInt(meta['last_page']),
            unreadCount: _parseInt(meta['unread_count']),
          ),
          statusCode: response.statusCode ?? 200,
        );
      }
      return Error(raw['message']?.toString() ?? 'Failed to load notifications');
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<int>> getUnreadCount() async {
    try {
      final response =
          await apiClient.get(path: ApiEndpoints.notificationsUnreadCount);
      final raw = response.data as Map<String, dynamic>;
      if (raw['success'] == true) {
        final data = raw['data'] as Map<String, dynamic>;
        return Success(
          data: _parseInt(data['unread_count']),
          statusCode: 200,
        );
      }
      return Error(raw['message']?.toString() ?? 'Failed');
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<void>> markRead(String id) async {
    try {
      final response =
          await apiClient.patch(path: ApiEndpoints.notificationRead(id));
      return parseVoidResponse(response);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<void>> markAllRead() async {
    try {
      final response =
          await apiClient.patch(path: ApiEndpoints.notificationsReadAll);
      return parseVoidResponse(response);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }
}
