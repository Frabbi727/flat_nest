import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/network/resource.dart';
import '../../../route/app_routes.dart';
import '../../listing/model/geo_model.dart';
import '../../listing/model/listing_model.dart';
import '../../listing/model/listing_type_model.dart';
import '../model/create_listing_request.dart';
import '../model/edit_listing_request.dart';
import '../model/save_location_request.dart';
import '../repository/create_listing_repository.dart';

class CreateListingController extends BaseController {
  final CreateListingRepository _repo;

  CreateListingController({required CreateListingRepository repo})
      : _repo = repo;

  // Wizard state
  final currentStep = 0.obs;
  String? _listingId;
  bool _editMode = false;
  bool _autoSubmit = false;
  bool _anyStepChanged = false;

  bool get editMode => _editMode;

  // Edit-mode initial snapshots — set once from the listing, used for dirty checking
  String _initTitle = '';
  int _initPrice = 0;
  int? _initDeposit;
  int _initBeds = 0;
  int _initBaths = 0;
  int? _initSize;
  String _initDesc = '';
  String _initTypeName = '';
  List<int> _initAmenities = const [];
  int? _initDivisionId;
  int? _initDistrictId;
  int? _initUpazilaId;
  int? _initUnionId;
  String _initRoadHouse = '';
  double? _initCoordX;
  double? _initCoordY;

  bool get _step1Unchanged {
    if (!_editMode) return false;
    final price = int.tryParse(priceController.text.replaceAll(',', '')) ?? 0;
    final deposit = int.tryParse(depositController.text.replaceAll(',', ''));
    final size = int.tryParse(sizeController.text);
    final beds = int.tryParse(bedsController.text) ?? 0;
    final baths = int.tryParse(bathsController.text) ?? 0;
    final currentAmenities = (List<int>.from(selectedAmenities)..sort()).join(',');
    final initAmenities = (List<int>.from(_initAmenities)..sort()).join(',');
    return titleController.text.trim() == _initTitle &&
        price == _initPrice &&
        deposit == _initDeposit &&
        beds == _initBeds &&
        baths == _initBaths &&
        size == _initSize &&
        descController.text.trim() == _initDesc &&
        selectedType.value == _initTypeName &&
        currentAmenities == initAmenities;
  }

  bool get _step3Unchanged {
    if (!_editMode) return false;
    return _divisionId == _initDivisionId &&
        _districtId == _initDistrictId &&
        _upazilaId == _initUpazilaId &&
        _unionId == _initUnionId &&
        roadAndHouse.text.trim() == _initRoadHouse &&
        coordX.value == _initCoordX &&
        coordY.value == _initCoordY;
  }

  // Step 1 — Details
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final depositController = TextEditingController();
  final bedsController = TextEditingController(text: '2');
  final bathsController = TextEditingController(text: '2');
  final sizeController = TextEditingController();
  final selectedType = ''.obs;
  final selectedTypeId = RxnInt();
  final selectedAmenities = <int>[].obs;
  final listingTypes = <ListingTypeModel>[].obs;
  final amenities = <AmenityModel>[].obs;
  final typesLoading = false.obs;

  void pickListingType(ListingTypeModel type) {
    selectedType.value = type.name;
    selectedTypeId.value = type.id;
  }

  // Step 2 — Photos
  final photos = <File>[].obs;
  // Existing photos in edit mode (network images already uploaded)
  final existingPhotos = <ListingPhotoModel>[].obs;

  // Step 3 — Location (display labels)
  final division = RxnString();
  final district = RxnString();
  final upazila = RxnString();
  final union = RxnString();
  final roadAndHouse = TextEditingController();
  final activeDropdown = RxnString();
  final coordX = RxnDouble();
  final coordY = RxnDouble();
  final pinnedAddress = RxnString();

  void setCoordinates(double lat, double lng, {String? address}) {
    coordX.value = lat;
    coordY.value = lng;
    pinnedAddress.value = address;
    if (address != null && roadAndHouse.text.trim().isEmpty) {
      roadAndHouse.text = address;
    }
  }

  void clearCoordinates() {
    coordX.value = null;
    coordY.value = null;
    pinnedAddress.value = null;
  }

  // Geo API item lists
  final divisionItems = <GeoItemModel>[].obs;
  final districtItems = <GeoItemModel>[].obs;
  final upazilaItems = <GeoItemModel>[].obs;
  final unionItems = <GeoItemModel>[].obs;

  // Per-level loading flags
  final divisionsLoading = false.obs;
  final districtsLoading = false.obs;
  final upazilasLoading = false.obs;
  final unionsLoading = false.obs;

  // Selected geo IDs — sent to the location API
  int? _divisionId;
  int? _districtId;
  int? _upazilaId;
  int? _unionId;

  void pickDivision(GeoItemModel item) {
    _divisionId = item.id;
    division.value = item.name;
    _districtId = null;
    district.value = null;
    _upazilaId = null;
    upazila.value = null;
    _unionId = null;
    union.value = null;
    districtItems.clear();
    upazilaItems.clear();
    unionItems.clear();
    activeDropdown.value = null;
    _fetchDistricts(item.id);
  }

  void pickDistrict(GeoItemModel item) {
    _districtId = item.id;
    district.value = item.name;
    _upazilaId = null;
    upazila.value = null;
    _unionId = null;
    union.value = null;
    upazilaItems.clear();
    unionItems.clear();
    activeDropdown.value = null;
    _fetchUpazilas(item.id);
  }

  void pickUpazila(GeoItemModel item) {
    _upazilaId = item.id;
    upazila.value = item.name;
    _unionId = null;
    union.value = null;
    unionItems.clear();
    activeDropdown.value = null;
    _fetchUnions(item.id);
  }

  void pickUnion(GeoItemModel item) {
    _unionId = item.id;
    union.value = item.name;
    activeDropdown.value = null;
  }

  void toggleDropdown(String key) {
    activeDropdown.value = activeDropdown.value == key ? null : key;
  }

  Future<void> _fetchDistricts(int divisionId) async {
    districtsLoading.value = true;
    final result = await _repo.getDistricts(divisionId);
    districtsLoading.value = false;
    if (result case Success(data: final data?)) {
      districtItems.assignAll(data);
      activeDropdown.value = 'district';
    }
  }

  Future<void> _fetchUpazilas(int districtId) async {
    upazilasLoading.value = true;
    final result = await _repo.getUpazilas(districtId);
    upazilasLoading.value = false;
    if (result case Success(data: final data?)) {
      upazilaItems.assignAll(data);
      activeDropdown.value = 'upazila';
    }
  }

  Future<void> _fetchUnions(int upazilaId) async {
    unionsLoading.value = true;
    final result = await _repo.getUnions(upazilaId);
    unionsLoading.value = false;
    if (result case Success(data: final data?)) {
      unionItems.assignAll(data);
      activeDropdown.value = 'union';
    }
  }

  bool get step1Valid {
    final title = titleController.text.trim();
    final price = int.tryParse(priceController.text.replaceAll(',', '')) ?? 0;
    final beds = int.tryParse(bedsController.text) ?? 0;
    final baths = int.tryParse(bathsController.text) ?? 0;
    return title.isNotEmpty && price > 0 && beds > 0 && baths > 0 && selectedTypeId.value != null;
  }

  bool get step3Valid => _unionId != null;

  void goBack() {
    if (currentStep.value == 0) {
      Get.back();
    } else {
      currentStep.value--;
    }
  }

  void continueStep() {
    switch (currentStep.value) {
      case 0:
        _submitStep1();
      case 1:
        _submitStep2();
      case 2:
        _submitStep3();
      case 3:
        _submitStep4();
    }
  }

  Future<void> _submitStep1() async {
    if (!step1Valid) {
      final title = titleController.text.trim();
      final price = int.tryParse(priceController.text.replaceAll(',', '')) ?? 0;
      final beds = int.tryParse(bedsController.text) ?? 0;
      final baths = int.tryParse(bathsController.text) ?? 0;
      if (selectedTypeId.value == null) {
        showError('Please select a listing type');
      } else if (title.isEmpty) {
        showError('Please enter a listing title');
      } else if (price <= 0) {
        showError('Please enter the monthly rent');
      } else if (beds <= 0) {
        showError('Please enter the number of bedrooms');
      } else if (baths <= 0) {
        showError('Please enter the number of bathrooms');
      }
      return;
    }

    final price = int.tryParse(priceController.text.replaceAll(',', '')) ?? 0;
    final deposit = int.tryParse(depositController.text.replaceAll(',', ''));
    final size = int.tryParse(sizeController.text);
    final beds = int.tryParse(bedsController.text) ?? 0;
    final baths = int.tryParse(bathsController.text) ?? 0;
    final desc = descController.text.trim();

    // Skip API if nothing changed
    if (_step1Unchanged) {
      Get.snackbar(
        'No changes',
        'Nothing was changed — moving to the next step.',
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
      currentStep.value = 1;
      return;
    }

    showLoading();

    if (_editMode && _listingId != null) {
      final result = await _repo.patchListing(
        _listingId!,
        EditListingRequest(
          title: titleController.text.trim(),
          listingTypeId: selectedTypeId.value,
          price: price,
          beds: beds,
          baths: baths,
          deposit: deposit,
          size: size,
          description: desc.isEmpty ? null : desc,
          amenities: selectedAmenities.isNotEmpty ? selectedAmenities.toList() : null,
        ),
      );
      hideLoading();
      switch (result) {
        case Success():
          _anyStepChanged = true;
          currentStep.value = 1;
        case Error(message: final msg):
          showError(msg);
      }
      return;
    }

    final result = await _repo.createListing(CreateListingRequest(
      title: titleController.text.trim(),
      listingTypeId: selectedTypeId.value!,
      price: price,
      beds: beds,
      baths: baths,
      deposit: deposit,
      size: size,
      description: desc.isEmpty ? null : desc,
      amenities: selectedAmenities.isNotEmpty ? selectedAmenities.toList() : null,
    ));
    hideLoading();

    switch (result) {
      case Success(data: final data?):
        _listingId = data['id'] as String?;
        currentStep.value = 1;
      case Success():
        showError('Failed to create listing');
      case Error(message: final msg):
        showError(msg);
    }
  }

  Future<void> _submitStep2() async {
    // In edit mode, skip upload if no new photos were added
    if (_editMode && photos.isEmpty) {
      currentStep.value = 2;
      return;
    }

    if (photos.isEmpty) {
      showError('Please add at least one photo');
      return;
    }
    if (_listingId == null) return;

    showLoading();
    final result = await _repo.uploadPhotos(
      listingId: _listingId!,
      photos: photos.toList(),
    );
    hideLoading();

    switch (result) {
      case Success():
        _anyStepChanged = true;
        currentStep.value = 2;
      case Error(message: final msg):
        showError(msg);
    }
  }

  Future<void> _submitStep3() async {
    // Skip API if nothing changed
    if (_step3Unchanged) {
      Get.snackbar(
        'No changes',
        'Nothing was changed — moving to the next step.',
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
      currentStep.value = 3;
      return;
    }

    if (!step3Valid) {
      showError('Please select at least the union/area');
      return;
    }
    if (_listingId == null) return;

    final rh = roadAndHouse.text.trim();
    showLoading();
    final result = await _repo.saveLocation(
      _listingId!,
      SaveLocationRequest(
        area: union.value!,
        divisionId: _divisionId!,
        districtId: _districtId!,
        upazilaId: _upazilaId!,
        unionId: _unionId!,
        roadAndHouse: rh.isEmpty ? null : rh,
        coordX: coordX.value,
        coordY: coordY.value,
      ),
    );
    hideLoading();

    switch (result) {
      case Success():
        _anyStepChanged = true;
        currentStep.value = 3;
      case Error(message: final msg):
        showError(msg);
    }
  }

  Future<void> _submitStep4() async {
    if (_listingId == null) return;

    if (_editMode) {
      if (_autoSubmit) {
        showLoading();
        final result = await _repo.submitListing(listingId: _listingId!);
        hideLoading();
        switch (result) {
          case Success():
            Get.offAllNamed(Routes.ownerHome);
            Get.snackbar(
              'Submitted for Review',
              'Your listing has been sent for re-approval.',
              duration: const Duration(seconds: 4),
            );
          case Error(message: final msg):
            showError(msg);
        }
      } else {
        Get.back();
        if (_anyStepChanged) {
          Get.snackbar(
            'Changes Saved',
            'Your listing has been sent for re-approval.',
            duration: const Duration(seconds: 4),
          );
        } else {
          Get.snackbar(
            'No changes made',
            'Everything looks the same — no updates were sent.',
            duration: const Duration(seconds: 3),
          );
        }
      }
      return;
    }

    showLoading();
    final result = await _repo.submitListing(listingId: _listingId!);
    hideLoading();

    switch (result) {
      case Success():
        Get.offAllNamed(Routes.ownerHome);
        Get.snackbar(
          'Submitted!',
          'Your listing is under review. You\'ll be notified within 24h.',
          duration: const Duration(seconds: 4),
        );
      case Error(message: final msg):
        showError(msg);
    }
  }

  void _prefillFromListing(OwnerListingModel listing) {
    titleController.text = listing.title;
    priceController.text = '${listing.price}';
    if (listing.deposit != null) depositController.text = '${listing.deposit}';
    if (listing.beds != null) bedsController.text = '${listing.beds}';
    if (listing.baths != null) bathsController.text = '${listing.baths}';
    if (listing.size != null) sizeController.text = '${listing.size}';
    if (listing.description != null) descController.text = listing.description!;
    selectedType.value = listing.type;
    if (listing.area != null) union.value = listing.area;
    if (listing.roadAndHouse != null) roadAndHouse.text = listing.roadAndHouse!;
    selectedAmenities.assignAll(listing.amenities.map((a) => a.id));
    // Geo IDs for cascade-loading dropdowns
    _divisionId = listing.divisionId;
    _districtId = listing.districtId;
    _upazilaId = listing.upazilaId;
    _unionId = listing.unionId;
    // Coordinates from map pin
    if (listing.coordX != null && listing.coordY != null) {
      coordX.value = listing.coordX;
      coordY.value = listing.coordY;
    }
    // Existing photos for preview
    existingPhotos.assignAll(listing.photos);

    // Snapshot for dirty checking
    _initTitle = listing.title;
    _initPrice = listing.price;
    _initDeposit = listing.deposit;
    _initBeds = listing.beds ?? 0;
    _initBaths = listing.baths ?? 0;
    _initSize = listing.size;
    _initDesc = listing.description ?? '';
    _initTypeName = listing.type;
    _initAmenities = listing.amenities.map((a) => a.id).toList();
    _initDivisionId = listing.divisionId;
    _initDistrictId = listing.districtId;
    _initUpazilaId = listing.upazilaId;
    _initUnionId = listing.unionId;
    _initRoadHouse = listing.roadAndHouse ?? '';
    _initCoordX = listing.coordX;
    _initCoordY = listing.coordY;
  }

  void addPhoto(File file) {
    if (photos.length < 8) photos.add(file);
  }

  void removePhoto(int index) {
    if (index >= 0 && index < photos.length) photos.removeAt(index);
  }

  void toggleAmenity(int id) {
    if (selectedAmenities.contains(id)) {
      selectedAmenities.remove(id);
    } else {
      selectedAmenities.add(id);
    }
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      _listingId = args['listingId'] as String?;
      _editMode = args['editMode'] as bool? ?? false;
      _autoSubmit = args['autoSubmit'] as bool? ?? false;
      final step = args['initialStep'] as int? ?? 0;
      currentStep.value = step;
      final listing = args['listing'] as OwnerListingModel?;
      if (listing != null) _prefillFromListing(listing);
    }
    _fetchListingTypes();
  }

  Future<void> _fetchListingTypes() async {
    typesLoading.value = true;
    divisionsLoading.value = true;

    final results = await Future.wait([
      _repo.getListingTypes(),
      _repo.getAmenities(),
      _repo.getDivisions(),
    ]);

    typesLoading.value = false;
    divisionsLoading.value = false;

    final typesResult = results[0] as Resource<List<ListingTypeModel>>;
    final amenitiesResult = results[1] as Resource<List<AmenityModel>>;
    final divisionsResult = results[2] as Resource<List<GeoItemModel>>;

    switch (typesResult) {
      case Success(data: final data?):
        listingTypes.assignAll(data);
        if (data.isNotEmpty) {
          final match = _editMode
              ? data.where((t) => t.name == selectedType.value).firstOrNull
              : null;
          if (match != null) {
            selectedTypeId.value = match.id;
          } else if (!_editMode) {
            selectedType.value = data.first.name;
            selectedTypeId.value = data.first.id;
          }
        }
      case Error(message: final msg):
        showError('Could not load listing types: $msg');
      default:
        break;
    }
    if (amenitiesResult case Success(data: final data?)) {
      amenities.assignAll(data);
    }
    if (divisionsResult case Success(data: final data?)) {
      divisionItems.assignAll(data);
      if (_editMode && _divisionId != null) {
        final div = data.where((d) => d.id == _divisionId).firstOrNull;
        if (div != null) division.value = div.name;
        _loadGeoForEditMode();
      }
    }
  }

  void retryLoadTypes() => _fetchListingTypes();

  Future<void> _loadGeoForEditMode() async {
    if (_divisionId == null) return;

    districtsLoading.value = true;
    final distResult = await _repo.getDistricts(_divisionId!);
    districtsLoading.value = false;
    if (distResult case Success(data: final data?)) {
      districtItems.assignAll(data);
      if (_districtId != null) {
        final match = data.where((d) => d.id == _districtId).firstOrNull;
        if (match != null) district.value = match.name;
      }
    }

    if (_districtId == null) return;
    upazilasLoading.value = true;
    final upResult = await _repo.getUpazilas(_districtId!);
    upazilasLoading.value = false;
    if (upResult case Success(data: final data?)) {
      upazilaItems.assignAll(data);
      if (_upazilaId != null) {
        final match = data.where((d) => d.id == _upazilaId).firstOrNull;
        if (match != null) upazila.value = match.name;
      }
    }

    if (_upazilaId == null) return;
    unionsLoading.value = true;
    final unResult = await _repo.getUnions(_upazilaId!);
    unionsLoading.value = false;
    if (unResult case Success(data: final data?)) {
      unionItems.assignAll(data);
      if (_unionId != null) {
        final match = data.where((d) => d.id == _unionId).firstOrNull;
        if (match != null) union.value = match.name;
      }
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descController.dispose();
    priceController.dispose();
    depositController.dispose();
    bedsController.dispose();
    bathsController.dispose();
    sizeController.dispose();
    roadAndHouse.dispose();
    super.onClose();
  }
}
