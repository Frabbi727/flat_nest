import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/network/resource.dart';
import '../../../core/service/auth_service.dart';
import '../../../route/app_routes.dart';
import '../../listing/model/geo_model.dart';
import '../../listing/model/listing_model.dart';
import '../../listing/model/listing_type_model.dart';
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
  final savedIds = RxSet<String>({});

  // Reference data (from API)
  final listingTypes = <ListingTypeModel>[].obs;
  final amenities = <AmenityModel>[].obs;

  // Active type chip — null means "All"
  final selectedTypeId = RxnInt();

  // Filter sheet state
  final filterMaxPrice = 80000.obs;
  final filterAmenityIds = <int>[].obs;
  final filterDivisionId = RxnInt();
  final filterDistrictId = RxnInt();
  final filterUpazilaId = RxnInt();
  final filterUnionId = RxnInt();

  // Geo dropdown data
  final divisions = <GeoItemModel>[].obs;
  final districts = <GeoItemModel>[].obs;
  final upazilas = <GeoItemModel>[].obs;
  final unions = <GeoItemModel>[].obs;

  final isDivisionsLoading = false.obs;
  final isDistrictsLoading = false.obs;
  final isUpazilasLoading = false.obs;
  final isUnionsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadReferenceData();
    fetchListings();
    fetchWishlist();
  }

  String get userName =>
      (_authService.currentUser?.name ?? 'there').split(' ').first;

  Future<void> _loadReferenceData() async {
    final results = await Future.wait([
      _listingRepository.getListingTypes(),
      _listingRepository.getAmenities(),
      _listingRepository.getDivisions(),
    ]);

    if (results[0] case Success(data: final data?)) {
      listingTypes.value = data as List<ListingTypeModel>;
    }
    if (results[1] case Success(data: final data?)) {
      amenities.value = data as List<AmenityModel>;
    }
    if (results[2] case Success(data: final data?)) {
      divisions.value = data as List<GeoItemModel>;
    }
  }

  Future<void> fetchListings() async {
    showLoading();
    final result = await _listingRepository.getListings(
      listingTypeId: selectedTypeId.value,
      maxPrice: filterMaxPrice.value < 80000 ? filterMaxPrice.value : null,
      amenityIds: filterAmenityIds.isNotEmpty ? [...filterAmenityIds] : null,
      divisionId: filterDivisionId.value,
      districtId: filterDistrictId.value,
      upazilaId: filterUpazilaId.value,
      unionId: filterUnionId.value,
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

  void selectType(int? typeId) {
    selectedTypeId.value = typeId;
    fetchListings();
  }

  // ── Geo cascade ──────────────────────────────────────────────────────────

  Future<void> onDivisionSelected(int? divisionId) async {
    filterDivisionId.value = divisionId;
    filterDistrictId.value = null;
    filterUpazilaId.value = null;
    filterUnionId.value = null;
    districts.clear();
    upazilas.clear();
    unions.clear();

    if (divisionId == null) return;
    isDistrictsLoading.value = true;
    final result = await _listingRepository.getDistricts(divisionId);
    isDistrictsLoading.value = false;
    if (result case Success(data: final data?)) {
      districts.value = data;
    }
  }

  Future<void> onDistrictSelected(int? districtId) async {
    filterDistrictId.value = districtId;
    filterUpazilaId.value = null;
    filterUnionId.value = null;
    upazilas.clear();
    unions.clear();

    if (districtId == null) return;
    isUpazilasLoading.value = true;
    final result = await _listingRepository.getUpazilas(districtId);
    isUpazilasLoading.value = false;
    if (result case Success(data: final data?)) {
      upazilas.value = data;
    }
  }

  Future<void> onUpazilaSelected(int? upazilaId) async {
    filterUpazilaId.value = upazilaId;
    filterUnionId.value = null;
    unions.clear();

    if (upazilaId == null) return;
    isUnionsLoading.value = true;
    final result = await _listingRepository.getUnions(upazilaId);
    isUnionsLoading.value = false;
    if (result case Success(data: final data?)) {
      unions.value = data;
    }
  }

  void onUnionSelected(int? unionId) {
    filterUnionId.value = unionId;
  }

  // ── Filter sheet actions ──────────────────────────────────────────────────

  void applyFilters({
    double? maxPrice,
    List<int>? amenityIds,
  }) {
    if (maxPrice != null) filterMaxPrice.value = maxPrice.round();
    if (amenityIds != null) filterAmenityIds.value = amenityIds;
    fetchListings();
  }

  void resetFilters() {
    filterMaxPrice.value = 80000;
    filterAmenityIds.clear();
    filterDivisionId.value = null;
    filterDistrictId.value = null;
    filterUpazilaId.value = null;
    filterUnionId.value = null;
    districts.clear();
    upazilas.clear();
    unions.clear();
    fetchListings();
  }

  bool get hasActiveFilters =>
      selectedTypeId.value != null ||
      filterMaxPrice.value < 80000 ||
      filterAmenityIds.isNotEmpty ||
      filterDivisionId.value != null;

  // ── Wishlist ──────────────────────────────────────────────────────────────

  void toggleSave(String listingId) async {
    final wasSaved = savedIds.contains(listingId);
    if (wasSaved) {
      savedIds.remove(listingId);
    } else {
      savedIds.add(listingId);
    }

    final result = wasSaved
        ? await _listingRepository.removeFromWishlist(listingId)
        : await _listingRepository.saveToWishlist(listingId);

    if (result is Error<void>) {
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

  void logout() async {
    await _authService.logout();
    Get.offAllNamed(Routes.login);
  }
}
