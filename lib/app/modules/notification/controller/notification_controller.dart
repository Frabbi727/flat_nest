import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/network/resource.dart';
import '../../../core/service/notification_service.dart';
import '../../../route/app_routes.dart';
import '../model/notification_model.dart';
import '../repository/notification_repository.dart';

class NotificationController extends BaseController {
  final NotificationRepository _repo;
  final NotificationService _notifService = Get.find<NotificationService>();

  NotificationController({required NotificationRepository repository})
      : _repo = repository;

  final notifications = <NotificationModel>[].obs;
  int _currentPage = 1;
  int _lastPage = 1;
  final isLoadingMore = false.obs;

  bool get hasMore => _currentPage < _lastPage;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    _currentPage = 1;
    _lastPage = 1;
    showLoading();
    final result = await _repo.getNotifications(page: 1);
    hideLoading();
    switch (result) {
      case Success(data: final data?):
        notifications.assignAll(data.items);
        _currentPage = data.currentPage;
        _lastPage = data.lastPage;
        _notifService.setUnreadCount(data.unreadCount);
      case Error(message: final msg):
        showError(msg);
      default:
        break;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore.value) return;
    isLoadingMore.value = true;
    final next = _currentPage + 1;
    final result = await _repo.getNotifications(page: next);
    isLoadingMore.value = false;
    if (result case Success(data: final data?)) {
      notifications.addAll(data.items);
      _currentPage = data.currentPage;
      _lastPage = data.lastPage;
    }
  }

  Future<void> markRead(NotificationModel n) async {
    if (!n.isUnread) {
      _handleNavigation(n);
      return;
    }
    // Optimistic update
    final index = notifications.indexOf(n);
    if (index != -1) notifications[index] = n.copyWith(isUnread: false);
    _notifService.decrementUnread();
    _handleNavigation(n);
    await _repo.markRead(n.id);
  }

  Future<void> markAllRead() async {
    notifications.assignAll(
      notifications.map((n) => n.copyWith(isUnread: false)).toList(),
    );
    _notifService.clearUnread();
    await _repo.markAllRead();
  }

  void _handleNavigation(NotificationModel n) {
    Get.back(); // close notification screen first
    switch (n.kind) {
      case 'listing_approved':
        Get.toNamed(Routes.renterHome);
      case 'listing_submitted':
      case 'listing_rejected':
      case 'listing_review':
        Get.toNamed(Routes.ownerHome);
    }
  }

  bool isToday(String time) {
    final lower = time.toLowerCase();
    return lower.contains('second') ||
        lower.contains('minute') ||
        lower.contains('hour') ||
        lower.contains('just now') ||
        lower == 'today';
  }
}
