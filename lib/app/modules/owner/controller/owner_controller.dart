import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/network/resource.dart';
import '../../../core/service/app_update_service.dart';
import '../../../core/service/auth_service.dart';
import '../../../core/service/meta_service.dart';
import '../../../route/app_routes.dart';
import '../../listing/model/listing_model.dart';
import '../repository/owner_repository.dart';

class OwnerController extends BaseController with WidgetsBindingObserver {
  final OwnerRepository _ownerRepository;
  final AuthService _authService = Get.find<AuthService>();

  OwnerController({required OwnerRepository ownerRepository})
      : _ownerRepository = ownerRepository;

  final activeTab = 0.obs;
  final myListings = <OwnerListingModel>[].obs;

  // Pagination state
  final _currentPage = 1.obs;
  final _lastPage = 1.obs;
  final isLoadingMore = false.obs;

  bool get hasMorePages => _currentPage.value < _lastPage.value;

  // Filter state
  final filterStatus = RxnString();
  final filterTypeId = RxnInt();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    fetchMyListings();
    Get.find<MetaService>().loadMeta();
    AppUpdateService.checkForUpdate();
    // Refresh when user switches to Dashboard (0) or Listings (1)
    ever(activeTab, (tab) {
      if (tab == 0 || tab == 1) fetchMyListings();
      AppUpdateService.checkForUpdate();
    });
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  // Called by the OS when app returns from background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) fetchMyListings();
  }

  String get ownerName =>
      (_authService.currentUser?.name ?? 'Owner').split(' ').first;

  String get ownerInitials {
    final name = _authService.currentUser?.name ?? 'O';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'O';
  }

  int get activeCount => myListings.where((l) => l.status == 'active').length;
  int get totalViews => myListings.fold(0, (sum, l) => sum + l.views);
  int get totalInquiries => myListings.fold(0, (sum, l) => sum + l.inquiries);

  Future<void> fetchMyListings() async {
    showLoading();
    _currentPage.value = 1;
    final result = await _ownerRepository.getMyListings(
      status: filterStatus.value,
      typeId: filterTypeId.value,
      page: 1,
    );
    hideLoading();

    switch (result) {
      case Success(data: final page?):
        myListings.value = page.listings;
        _currentPage.value = page.currentPage;
        _lastPage.value = page.lastPage;
      case Success():
        myListings.clear();
      case Error(message: final msg):
        showError(msg);
    }
  }

  Future<void> loadMoreListings() async {
    if (isLoadingMore.value || !hasMorePages) return;
    isLoadingMore.value = true;
    final nextPage = _currentPage.value + 1;
    final result = await _ownerRepository.getMyListings(
      status: filterStatus.value,
      typeId: filterTypeId.value,
      page: nextPage,
    );
    isLoadingMore.value = false;

    if (result case Success(data: final page?)) {
      myListings.addAll(page.listings);
      _currentPage.value = page.currentPage;
      _lastPage.value = page.lastPage;
    }
  }

  void applyOwnerFilters({String? status, int? typeId}) {
    filterStatus.value = status;
    filterTypeId.value = typeId;
    fetchMyListings();
  }

  Future<void> goToCreateListing() async {
    await Get.toNamed(Routes.createListing);
    fetchMyListings();
  }

  Future<void> continueDraft(OwnerListingModel listing) async {
    final step = listing.photos.isEmpty ? 1 : (listing.area == null ? 2 : 3);
    await Get.toNamed(Routes.createListing, arguments: {
      'listingId': listing.id,
      'initialStep': step,
      'listing': listing,
    });
    fetchMyListings();
  }

  Future<void> navigateToEdit(OwnerListingModel listing) async {
    await Get.toNamed(Routes.createListing, arguments: {
      'listingId': listing.id,
      'editMode': true,
      'listing': listing,
    });
    fetchMyListings();
  }

  Future<void> fixAndResubmit(OwnerListingModel listing) async {
    await Get.toNamed(Routes.createListing, arguments: {
      'listingId': listing.id,
      'editMode': true,
      'autoSubmit': true,
      'listing': listing,
    });
    fetchMyListings();
  }

  Future<void> markRented(String listingId) async {
    showLoading();
    final result = await _ownerRepository.markRented(listingId);
    hideLoading();
    switch (result) {
      case Success():
        fetchMyListings();
      case Error(message: final msg):
        showError(msg);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed(Routes.login);
  }
}
