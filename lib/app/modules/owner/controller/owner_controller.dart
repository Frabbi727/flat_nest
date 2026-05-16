import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/network/resource.dart';
import '../../../core/service/auth_service.dart';
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

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    fetchMyListings();
    // Refresh when user switches to Dashboard (0) or Listings (1)
    ever(activeTab, (tab) {
      if (tab == 0 || tab == 1) fetchMyListings();
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
    final result = await _ownerRepository.getMyListings();
    hideLoading();

    switch (result) {
      case Success(data: final data?):
        myListings.value = data;
      case Success():
        myListings.clear();
      case Error(message: final msg):
        showError(msg);
    }
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
