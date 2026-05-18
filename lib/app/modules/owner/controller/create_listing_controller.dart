import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/network/resource.dart';
import '../../../core/service/auth_service.dart';
import '../../../core/service/meta_service.dart';
import '../../../route/app_routes.dart';
import '../../listing/model/geo_model.dart';
import '../../listing/model/listing_facing_model.dart';
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
  double? _initLat;
  double? _initLng;
  // New step 1 snapshots
  String? _initAvailableFrom;
  int? _initFloorNo;
  int? _initFacingId;
  // New step 3 snapshots
  String _initRoad = '';
  String _initHouseName = '';
  String _initBlock = '';
  String _initSection = '';

  bool get _step1Unchanged {
    if (!_editMode) return false;
    final price = int.tryParse(priceController.text.replaceAll(',', '')) ?? 0;
    final deposit = int.tryParse(depositController.text.replaceAll(',', ''));
    final size = int.tryParse(sizeController.text);
    final beds = int.tryParse(bedsController.text) ?? 0;
    final baths = int.tryParse(bathsController.text) ?? 0;
    final currentAmenities = (List<int>.from(selectedAmenities)..sort()).join(',');
    final initAmenities = (List<int>.from(_initAmenities)..sort()).join(',');
    final currentFloor = int.tryParse(floorNoController.text);
    final currentAvailFrom =
        availableFrom.value != null ? _formatDateForApi(availableFrom.value!) : null;
    return titleController.text.trim() == _initTitle &&
        price == _initPrice &&
        deposit == _initDeposit &&
        beds == _initBeds &&
        baths == _initBaths &&
        size == _initSize &&
        descController.text.trim() == _initDesc &&
        selectedType.value == _initTypeName &&
        currentAmenities == initAmenities &&
        currentAvailFrom == _initAvailableFrom &&
        currentFloor == _initFloorNo &&
        selectedFacingId.value == _initFacingId;
  }

  bool get _step3Unchanged {
    if (!_editMode) return false;
    return _divisionId == _initDivisionId &&
        _districtId == _initDistrictId &&
        _upazilaId == _initUpazilaId &&
        _unionId == _initUnionId &&
        roadController.text.trim() == _initRoad &&
        houseNameController.text.trim() == _initHouseName &&
        blockController.text.trim() == _initBlock &&
        sectionController.text.trim() == _initSection &&
        lat.value == _initLat &&
        lng.value == _initLng;
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
  // Step 1 new fields
  final availableFrom = Rxn<DateTime>();
  final floorNoController = TextEditingController();
  final selectedFacingId = RxnInt();
  final listingFacings = <ListingFacingModel>[].obs;
  final facingsLoading = false.obs;

  void pickListingType(ListingTypeModel type) {
    selectedType.value = type.slug;
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
  final lat = RxnDouble();
  final lng = RxnDouble();
  final pinnedAddress = RxnString();
  // Step 3 new address detail fields
  final roadController = TextEditingController();
  final houseNameController = TextEditingController();
  final blockController = TextEditingController();
  final sectionController = TextEditingController();

  void setCoordinates(double latVal, double lngVal, {String? address}) {
    lat.value = latVal;
    lng.value = lngVal;
    pinnedAddress.value = address;
    if (address != null && roadAndHouse.text.trim().isEmpty) {
      roadAndHouse.text = address;
    }
  }

  void clearCoordinates() {
    lat.value = null;
    lng.value = null;
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

  // Step 4 — Owner Info
  final ownerNameController = TextEditingController();
  final ownerPhoneController = TextEditingController();
  final ownerAltPhoneController = TextEditingController();
  final ownerEmailController = TextEditingController();
  final selectedPreferredContact = 'call'.obs;

  void fillWithAccountInfo() {
    final user = Get.find<AuthService>().currentUser;
    if (user == null) return;
    if (user.name.isNotEmpty) ownerNameController.text = user.name;
    if (user.phone != null && user.phone!.isNotEmpty) {
      ownerPhoneController.text = user.phone!;
    }
    if (user.email.isNotEmpty) {
      ownerEmailController.text = user.email;
    }
    Get.snackbar(
      'Done',
      'Fields filled with your account info',
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  bool get step1Valid {
    final title = titleController.text.trim();
    final price = int.tryParse(priceController.text.replaceAll(',', '')) ?? 0;
    final beds = int.tryParse(bedsController.text) ?? 0;
    final baths = int.tryParse(bathsController.text) ?? 0;
    return title.isNotEmpty && price > 0 && beds > 0 && baths > 0 && selectedTypeId.value != null;
  }

  // area is now optional — step 3 is always valid
  bool get step3Valid => true;

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
        _submitStep4OwnerInfo();
      case 4:
        _submitStep4();
    }
  }

  String _formatDateForApi(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

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
    final floorNo = int.tryParse(floorNoController.text);
    final availableFromStr =
        availableFrom.value != null ? _formatDateForApi(availableFrom.value!) : null;

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
          availableFrom: availableFromStr,
          floorNo: floorNo,
          facingId: selectedFacingId.value,
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
      availableFrom: availableFromStr,
      floorNo: floorNo,
      facingId: selectedFacingId.value,
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

    if (_listingId == null) return;

    final road = roadController.text.trim();
    final houseName = houseNameController.text.trim();
    final block = blockController.text.trim();
    final section = sectionController.text.trim();

    showLoading();
    final result = await _repo.saveLocation(
      _listingId!,
      SaveLocationRequest(
        area: union.value,
        divisionId: _divisionId,
        districtId: _districtId,
        upazilaId: _upazilaId,
        unionId: _unionId,
        road: road.isEmpty ? null : road,
        houseName: houseName.isEmpty ? null : houseName,
        block: block.isEmpty ? null : block,
        section: section.isEmpty ? null : section,
        lat: lat.value,
        lng: lng.value,
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

  Future<void> _submitStep4OwnerInfo() async {
    if (_listingId == null) return;

    final ownerName = ownerNameController.text.trim();
    final ownerPhone = ownerPhoneController.text.trim();
    final ownerAltPhone = ownerAltPhoneController.text.trim();
    final ownerEmail = ownerEmailController.text.trim();

    final data = <String, dynamic>{};
    if (ownerName.isNotEmpty) data['owner_name'] = ownerName;
    if (ownerPhone.isNotEmpty) data['owner_phone'] = ownerPhone;
    if (ownerAltPhone.isNotEmpty) data['owner_alt_phone'] = ownerAltPhone;
    if (ownerEmail.isNotEmpty) data['owner_email'] = ownerEmail;
    data['preferred_contact'] = selectedPreferredContact.value;

    showLoading();
    final result = await _repo.updateOwnerInfo(_listingId!, data);
    hideLoading();

    switch (result) {
      case Success():
        _anyStepChanged = true;
        currentStep.value = 4;
      case Error(message: final msg):
        showError(msg);
    }
  }

  void skipOwnerInfoStep() => _submitStep4OwnerInfo();

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
    // Set type ID directly if available from API — avoids slug matching entirely
    if (listing.listingTypeId != null) {
      selectedTypeId.value = listing.listingTypeId;
    }
    if (listing.area != null) union.value = listing.area;
    if (listing.roadAndHouse != null) roadAndHouse.text = listing.roadAndHouse!;
    selectedAmenities.assignAll(listing.amenities.map((a) => a.id));
    // Geo IDs for cascade-loading dropdowns
    _divisionId = listing.divisionId;
    _districtId = listing.districtId;
    _upazilaId = listing.upazilaId;
    _unionId = listing.unionId;
    // Coordinates from map pin
    if (listing.lat != null && listing.lng != null) {
      lat.value = listing.lat;
      lng.value = listing.lng;
    }
    // Existing photos for preview
    existingPhotos.assignAll(listing.photos);
    // New Step 1 fields
    if (listing.availableFrom != null) {
      final dt = DateTime.tryParse(listing.availableFrom!);
      if (dt != null) availableFrom.value = dt;
    }
    if (listing.floorNo != null) floorNoController.text = '${listing.floorNo}';
    if (listing.facingId != null) selectedFacingId.value = listing.facingId;
    // New Step 3 address fields
    if (listing.road != null) roadController.text = listing.road!;
    if (listing.houseName != null) houseNameController.text = listing.houseName!;
    if (listing.block != null) blockController.text = listing.block!;
    if (listing.section != null) sectionController.text = listing.section!;
    // New Step 4 owner info fields
    if (listing.ownerName != null) ownerNameController.text = listing.ownerName!;
    if (listing.ownerPhone != null) ownerPhoneController.text = listing.ownerPhone!;
    if (listing.ownerAltPhone != null) {
      ownerAltPhoneController.text = listing.ownerAltPhone!;
    }
    if (listing.ownerEmail != null) ownerEmailController.text = listing.ownerEmail!;
    if (listing.preferredContact != null) {
      selectedPreferredContact.value = listing.preferredContact!;
    }

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
    _initLat = listing.lat;
    _initLng = listing.lng;
    // New snapshots
    _initAvailableFrom = listing.availableFrom;
    _initFloorNo = listing.floorNo;
    _initFacingId = listing.facingId;
    _initRoad = listing.road ?? '';
    _initHouseName = listing.houseName ?? '';
    _initBlock = listing.block ?? '';
    _initSection = listing.section ?? '';
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
      // Pre-fill from passed listing immediately so fields aren't empty
      if (listing != null) _prefillFromListing(listing);
      // In edit mode, always fetch the full detail to get complete amenities
      if (_editMode && _listingId != null) _fetchFullListingForEdit();
    }
    _fetchListingTypes();
    _loadFacings();
    ever(Get.find<MetaService>().listingFacings, (List<ListingFacingModel> facings) {
      if (listingFacings.isEmpty && facings.isNotEmpty) {
        listingFacings.assignAll(facings);
      }
    });
  }

  Future<void> _fetchFullListingForEdit() async {
    final result = await _repo.fetchListingDetail(_listingId!);
    if (result case Success(data: final listing?)) {
      _prefillFromListing(listing);
    }
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
          if (_editMode) {
            // ID was set directly from API in _prefillFromListing — verify it
            // exists in the loaded types and fall back to slug/name matching
            final alreadyValid = selectedTypeId.value != null &&
                data.any((t) => t.id == selectedTypeId.value);
            if (!alreadyValid) {
              final lower = selectedType.value.toLowerCase();
              final match = data.where((t) =>
                  t.slug.toLowerCase() == lower ||
                  t.name.toLowerCase() == lower ||
                  t.label.toLowerCase() == lower).firstOrNull;
              if (match != null) {
                selectedTypeId.value = match.id;
                selectedType.value = match.slug;
              }
            }
          } else {
            selectedType.value = data.first.slug;
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

  Future<void> _loadFacings() async {
    // Prefer MetaService cache
    final metaService = Get.find<MetaService>();
    if (metaService.listingFacings.isNotEmpty) {
      listingFacings.assignAll(metaService.listingFacings);
      return;
    }
    facingsLoading.value = true;
    final result = await _repo.fetchListingFacings();
    facingsLoading.value = false;
    if (result case Success(data: final data?)) {
      listingFacings.assignAll(data);
      Get.find<MetaService>().listingFacings.assignAll(data);
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
    floorNoController.dispose();
    roadAndHouse.dispose();
    roadController.dispose();
    houseNameController.dispose();
    blockController.dispose();
    sectionController.dispose();
    ownerNameController.dispose();
    ownerPhoneController.dispose();
    ownerAltPhoneController.dispose();
    ownerEmailController.dispose();
    super.onClose();
  }
}
