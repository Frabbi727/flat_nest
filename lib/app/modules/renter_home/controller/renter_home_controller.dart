import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/network/resource.dart';
import '../../../core/service/auth_service.dart';
import '../../../route/app_routes.dart';
import '../../listing/model/listing_model.dart';
import '../repository/listing_repository.dart';

class RenterHomeController extends BaseController {
  final ListingRepository _listingRepository;
  final AuthService _authService = Get.find<AuthService>();

  RenterHomeController({required ListingRepository listingRepository})
      : _listingRepository = listingRepository;

  // Navigation
  final activeTab = 0.obs;

  // Discovery
  final listings = <ListingModel>[].obs;
  final selectedChip = 'All'.obs;
  final savedIds = RxSet<String>({});

  // Filters
  final filterType = RxnString();
  final filterMaxPrice = 80000.obs;

  static const filterChips = ['All', 'Family', 'Bachelor', 'Couple', 'Student', 'Sublet'];

  @override
  void onInit() {
    super.onInit();
    fetchListings();
    fetchWishlist();
  }

  String get userName => (_authService.currentUser?.name ?? 'there').split(' ').first;

  Future<void> fetchListings() async {
    showLoading();
    final result = await _listingRepository.getListings(
      type: selectedChip.value == 'All' ? null : selectedChip.value,
    );
    hideLoading();

    switch (result) {
      case Success(data: final data?):
        listings.value = data;
      case Success():
        listings.clear();
      case Error(message: final msg):
        showError(msg);
    }
  }

  Future<void> fetchWishlist() async {
    final result = await _listingRepository.getWishlist();
    if (result case Success(data: final ids?)) {
      savedIds.assignAll(ids);
    }
  }

  void selectChip(String chip) {
    selectedChip.value = chip;
    fetchListings();
  }

  void toggleSave(String listingId) async {
    final wasSaved = savedIds.contains(listingId);
    // Optimistic update
    if (wasSaved) {
      savedIds.remove(listingId);
    } else {
      savedIds.add(listingId);
    }

    final result = wasSaved
        ? await _listingRepository.removeFromWishlist(listingId)
        : await _listingRepository.saveToWishlist(listingId);

    if (result is Error<void>) {
      // Revert on failure
      if (wasSaved) {
        savedIds.add(listingId);
      } else {
        savedIds.remove(listingId);
      }
    }
  }

  bool isSaved(String listingId) => savedIds.contains(listingId);

  List<ListingModel> get wishlistListings =>
      listings.where((l) => savedIds.contains(l.id)).toList();

  void openListing(ListingModel listing) {
    Get.toNamed(Routes.listingDetail, arguments: listing);
  }

  void openFilters() {
    // Will be implemented with bottom sheet
  }

  void logout() async {
    await _authService.logout();
    Get.offAllNamed(Routes.login);
  }
}
