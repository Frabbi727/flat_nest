import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/network/resource.dart';
import '../model/access_request_model.dart';
import '../repository/access_request_repository.dart';

class AccessRequestController extends BaseController {
  final AccessRequestRepository _repo;

  AccessRequestController({required AccessRequestRepository repository})
      : _repo = repository;

  final requests = <AccessRequestModel>[].obs;
  final selectedStatus = 'pending'.obs;
  int _currentPage = 1;
  int _lastPage = 1;
  final isLoadingMore = false.obs;

  bool get hasMore => _currentPage < _lastPage;

  @override
  void onInit() {
    super.onInit();
    ever(selectedStatus, (_) => loadRequests());
    loadRequests();
  }

  Future<void> loadRequests() async {
    _currentPage = 1;
    _lastPage = 1;
    showLoading();
    final result = await _repo.getAccessRequests(
      status: selectedStatus.value,
      page: 1,
    );
    hideLoading();
    switch (result) {
      case Success(data: final page?):
        requests.assignAll(page.requests);
        _currentPage = page.currentPage;
        _lastPage = page.lastPage;
      case Error(message: final msg):
        showError(msg);
      default:
        break;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore.value) return;
    isLoadingMore.value = true;
    final result = await _repo.getAccessRequests(
      status: selectedStatus.value,
      page: _currentPage + 1,
    );
    isLoadingMore.value = false;
    if (result case Success(data: final page?)) {
      requests.addAll(page.requests);
      _currentPage = page.currentPage;
      _lastPage = page.lastPage;
    }
  }

  Future<void> accept(AccessRequestModel req) async {
    final result = await _repo.acceptRequest(req.id);
    switch (result) {
      case Success(data: final updated?):
        _replaceInList(req, updated);
      case Error(message: final msg):
        showError(msg);
      default:
        break;
    }
  }

  Future<void> reject(AccessRequestModel req) async {
    final result = await _repo.rejectRequest(req.id);
    switch (result) {
      case Success(data: final updated?):
        _replaceInList(req, updated);
      case Error(message: final msg):
        showError(msg);
      default:
        break;
    }
  }

  void _replaceInList(AccessRequestModel old, AccessRequestModel updated) {
    final idx = requests.indexWhere((r) => r.id == old.id);
    if (idx != -1) requests[idx] = updated;
  }
}
