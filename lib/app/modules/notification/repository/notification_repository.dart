import '../../../core/base/base_repository.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/resource.dart';
import '../model/notification_model.dart';

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
            currentPage: (meta['current_page'] as num).toInt(),
            lastPage: (meta['last_page'] as num).toInt(),
            unreadCount: (meta['unread_count'] as num).toInt(),
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
          data: (data['unread_count'] as num).toInt(),
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
