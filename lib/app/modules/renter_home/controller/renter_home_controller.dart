import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/resource.dart';
import '../../../core/service/auth_service.dart';
import '../../../core/service/meta_service.dart';
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

  // Wishlist — independent of the discovery filter state
  final _wishlistItems = <ListingModel>[].obs;

  // Location
  final locationLabel = 'Fetching location...'.obs;
  final isLocationRefreshing = false.obs;
  double? _lat;
  double? _lng;

  // Search
  final searchQuery = ''.obs;
  final searchTextController = TextEditingController();

  // Per-listing toggle loading state
  final _togglingIds = RxSet<String>({});

  // Reference data (from API)
  final listingTypes = <ListingTypeModel>[].obs;
  final amenities = <AmenityModel>[].obs;

  // Active type chip — null means "All"
  final selectedTypeId = RxnInt();

  // Filter sheet state
  final filterMaxPrice = 80000.obs;
  final filterPriceMin = 0.obs;
  final filterAmenityIds = <int>[].obs;
  final filterDivisionId = RxnInt();
  final filterDistrictId = RxnInt();
  final filterUpazilaId = RxnInt();
  final filterUnionId = RxnInt();
  // New filter fields
  final filterBaths = RxnInt();
  final filterFacingId = RxnInt();
  final filterFloorMin = RxnInt();
  final filterFloorMax = RxnInt();
  final filterSizeMin = RxnInt();
  final filterSizeMax = RxnInt();
  final filterAvailableFromStart = RxnString();
  final filterAvailableFromEnd = RxnString();
  final filterSortBy = RxnString();

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
    showLoading(); // show shimmer immediately — _fetchLocation → fetchListings will call hideLoading
    debounce(
      searchQuery,
      (_) => fetchListings(),
      time: const Duration(milliseconds: 500),
    );
    _loadReferenceData();
    _fetchLocation();
    fetchWishlist();
    Get.find<MetaService>().loadMeta();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  String get userName =>
      (_authService.currentUser?.name ?? 'there').split(' ').first;

  // ── Location ──────────────────────────────────────────────────────────────

  Future<void> _fetchLocation() => refreshLocation();

  Future<void> refreshLocation() async {
    if (isLocationRefreshing.value) return;
    isLocationRefreshing.value = true;
    locationLabel.value = 'Updating location...';
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        locationLabel.value = 'Location unavailable';
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      ).timeout(const Duration(seconds: 10));
      _lat = position.latitude;
      _lng = position.longitude;
      locationLabel.value = await _reverseGeocode(_lat!, _lng!);
      _sendLocationToBackend(_lat!, _lng!);
    } catch (_) {
      locationLabel.value = 'Location unavailable';
    } finally {
      isLocationRefreshing.value = false;
    }
    fetchListings();
  }

  Future<String> _reverseGeocode(double lat, double lng) async {
    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        headers: {
          'User-Agent': 'FlatNest/1.0 (rental listing app)',
          'Accept-Language': 'en',
        },
      ));
      final response = await dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'json',
          'lat': lat,
          'lon': lng,
          'addressdetails': 1,
          'zoom': 18,
        },
      );
      final data = response.data as Map<String, dynamic>;
      final addr = data['address'] as Map<String, dynamic>? ?? {};
      final displayName = data['display_name'] as String?;
      return _buildLocationLabel(addr, displayName);
    } catch (_) {
      return 'Your location';
    }
  }

  String _buildLocationLabel(Map<String, dynamic> addr, String? displayName) {
    // Same priority order as map_picker_view — most specific first
    final candidates = [
      addr['road'],
      addr['neighbourhood'],
      addr['hamlet'],
      addr['suburb'],
      addr['village'],
      addr['town'],
      addr['city_district'],
      addr['city'],
      addr['county'],
      addr['state'],
    ];

    final parts = candidates
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .take(2)
        .toList();

    if (parts.isNotEmpty) return parts.join(', ');

    // Fallback: first 2 segments of display_name
    if (displayName != null) {
      final segments = displayName
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .take(2)
          .toList();
      if (segments.isNotEmpty) return segments.join(', ');
    }

    return 'Your location';
  }

  Future<void> _sendLocationToBackend(double lat, double lng) async {
    try {
      await Get.find<ApiClient>().patch(
        path: ApiEndpoints.userLocation,
        data: {'lat': lat, 'lng': lng},
      );
    } catch (_) {}
  }

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
    final query = searchQuery.value.trim();
    final result = await _listingRepository.getListings(
      listingTypeId: selectedTypeId.value,
      priceMin: filterPriceMin.value > 0 ? filterPriceMin.value : null,
      priceMax: filterMaxPrice.value < 80000 ? filterMaxPrice.value : null,
      baths: filterBaths.value,
      facingId: filterFacingId.value,
      floorMin: filterFloorMin.value,
      floorMax: filterFloorMax.value,
      sizeMin: filterSizeMin.value,
      sizeMax: filterSizeMax.value,
      availableFromStart: filterAvailableFromStart.value,
      availableFromEnd: filterAvailableFromEnd.value,
      sortBy: filterSortBy.value,
      amenityIds: filterAmenityIds.isNotEmpty ? [...filterAmenityIds] : null,
      divisionId: filterDivisionId.value,
      districtId: filterDistrictId.value,
      upazilaId: filterUpazilaId.value,
      unionId: filterUnionId.value,
      search: query.isEmpty ? null : query,
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
    if (result case Success(data: final items?)) {
      _wishlistItems.value = items;
      savedIds.assignAll(items.map((l) => l.id).toSet());
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
    double? minPrice,
    List<int>? amenityIds,
    int? baths,
    int? facingId,
    int? floorMin,
    int? floorMax,
    int? sizeMin,
    int? sizeMax,
    String? availableFromStart,
    String? availableFromEnd,
    String? sortBy,
  }) {
    if (maxPrice != null) filterMaxPrice.value = maxPrice.round();
    if (minPrice != null) filterPriceMin.value = minPrice.round();
    if (amenityIds != null) filterAmenityIds.value = amenityIds;
    filterBaths.value = baths;
    filterFacingId.value = facingId;
    filterFloorMin.value = floorMin;
    filterFloorMax.value = floorMax;
    filterSizeMin.value = sizeMin;
    filterSizeMax.value = sizeMax;
    filterAvailableFromStart.value = availableFromStart;
    filterAvailableFromEnd.value = availableFromEnd;
    filterSortBy.value = sortBy;
    fetchListings();
  }

  void resetFilters() {
    selectedTypeId.value = null;
    filterMaxPrice.value = 80000;
    filterPriceMin.value = 0;
    filterAmenityIds.clear();
    filterDivisionId.value = null;
    filterDistrictId.value = null;
    filterUpazilaId.value = null;
    filterUnionId.value = null;
    filterBaths.value = null;
    filterFacingId.value = null;
    filterFloorMin.value = null;
    filterFloorMax.value = null;
    filterSizeMin.value = null;
    filterSizeMax.value = null;
    filterAvailableFromStart.value = null;
    filterAvailableFromEnd.value = null;
    filterSortBy.value = null;
    districts.clear();
    upazilas.clear();
    unions.clear();
    searchQuery.value = '';
    searchTextController.clear();
    fetchListings();
  }

  int get activeFilterCount {
    int count = 0;
    if (filterMaxPrice.value < 80000) count++;
    if (filterPriceMin.value > 0) count++;
    if (filterAmenityIds.isNotEmpty) count++;
    if (filterDivisionId.value != null) count++;
    if (filterBaths.value != null) count++;
    if (filterFacingId.value != null) count++;
    if (filterFloorMin.value != null || filterFloorMax.value != null) count++;
    if (filterSizeMin.value != null || filterSizeMax.value != null) count++;
    if (filterAvailableFromStart.value != null ||
        filterAvailableFromEnd.value != null) count++;
    if (filterSortBy.value != null) count++;
    return count;
  }

  bool get hasActiveFilters =>
      selectedTypeId.value != null ||
      filterMaxPrice.value < 80000 ||
      filterPriceMin.value > 0 ||
      filterAmenityIds.isNotEmpty ||
      filterDivisionId.value != null ||
      filterBaths.value != null ||
      filterFacingId.value != null ||
      filterFloorMin.value != null ||
      filterFloorMax.value != null ||
      filterSizeMin.value != null ||
      filterSizeMax.value != null ||
      filterAvailableFromStart.value != null ||
      filterAvailableFromEnd.value != null ||
      filterSortBy.value != null ||
      searchQuery.value.isNotEmpty;

  // ── Nearby / Map ─────────────────────────────────────────────────────────

  final nearbyListings = <ListingModel>[].obs;
  final nearbyLoading = false.obs;
  final nearbyError = RxnString();
  final nearbyRadius = 5.0.obs;

  Future<void> fetchNearbyListings({
    required double lat,
    required double lng,
    double? radius,
  }) async {
    nearbyLoading.value = true;
    nearbyError.value = null;
    final r = radius ?? nearbyRadius.value;
    // API: coord_x = longitude, coord_y = latitude
    final result = await _listingRepository.fetchNearbyListings(
      coordX: lng,
      coordY: lat,
      radius: r,
    );
    nearbyLoading.value = false;
    switch (result) {
      case Success(data: final data?):
        nearbyListings.value = data;
      case Success():
        nearbyListings.clear();
      case Error(message: final msg):
        nearbyError.value = msg;
    }
  }

  // ── Wishlist ──────────────────────────────────────────────────────────────

  void toggleSave(ListingModel listing) async {
    if (_togglingIds.contains(listing.id)) return;
    final wasSaved = savedIds.contains(listing.id);

    // Optimistic update — instant visual feedback
    _togglingIds.add(listing.id);
    if (wasSaved) {
      savedIds.remove(listing.id);
      _wishlistItems.removeWhere((l) => l.id == listing.id);
    } else {
      savedIds.add(listing.id);
      if (!_wishlistItems.any((l) => l.id == listing.id)) {
        _wishlistItems.add(listing);
      }
    }

    final result = await _listingRepository.toggleWishlist(listing.id);
    _togglingIds.remove(listing.id);

    switch (result) {
      case Success(data: final isSaved?):
        // Sync with server truth
        if (isSaved && !savedIds.contains(listing.id)) {
          savedIds.add(listing.id);
          if (!_wishlistItems.any((l) => l.id == listing.id)) {
            _wishlistItems.add(listing);
          }
        } else if (!isSaved && savedIds.contains(listing.id)) {
          savedIds.remove(listing.id);
          _wishlistItems.removeWhere((l) => l.id == listing.id);
        }
      case Error(message: final msg):
        // Revert optimistic update
        if (wasSaved) {
          savedIds.add(listing.id);
          if (!_wishlistItems.any((l) => l.id == listing.id)) {
            _wishlistItems.add(listing);
          }
        } else {
          savedIds.remove(listing.id);
          _wishlistItems.removeWhere((l) => l.id == listing.id);
        }
        showError(msg);
      default:
        break;
    }
  }

  bool isSaved(String listingId) => savedIds.contains(listingId);

  bool isToggling(String listingId) => _togglingIds.contains(listingId);

  List<ListingModel> get wishlistListings => _wishlistItems;

  void openListing(ListingModel listing) {
    Get.toNamed(Routes.listingDetail, arguments: listing);
  }

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed(Routes.login);
  }
}
