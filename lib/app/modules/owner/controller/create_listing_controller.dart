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
import '../model/save_location_request.dart';
import '../repository/create_listing_repository.dart';

class CreateListingController extends BaseController {
  final CreateListingRepository _repo;

  CreateListingController({required CreateListingRepository repo})
      : _repo = repo;

  // Wizard state
  final currentStep = 0.obs;
  String? _listingId;

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

  // Step 3 — Location (display labels)
  final division = RxnString();
  final district = RxnString();
  final upazila = RxnString();
  final union = RxnString();
  final roadAndHouse = TextEditingController();
  final activeDropdown = RxnString();

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
      showError('Please fill title, rent, beds, and baths');
      return;
    }

    final price = int.tryParse(priceController.text.replaceAll(',', '')) ?? 0;
    final deposit = int.tryParse(depositController.text.replaceAll(',', ''));
    final size = int.tryParse(sizeController.text);
    final beds = int.tryParse(bedsController.text) ?? 0;
    final baths = int.tryParse(bathsController.text) ?? 0;
    final desc = descController.text.trim();

    showLoading();
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
        currentStep.value = 2;
      case Error(message: final msg):
        showError(msg);
    }
  }

  Future<void> _submitStep3() async {
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
      ),
    );
    hideLoading();

    switch (result) {
      case Success():
        currentStep.value = 3;
      case Error(message: final msg):
        showError(msg);
    }
  }

  Future<void> _submitStep4() async {
    if (_listingId == null) return;

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
  @override
  void onInit() {
    super.onInit();
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

    if (typesResult case Success(data: final data?)) {
      listingTypes.assignAll(data);
      if (data.isNotEmpty) {
        selectedType.value = data.first.name;
        selectedTypeId.value = data.first.id;
      }
    }
    if (amenitiesResult case Success(data: final data?)) {
      amenities.assignAll(data);
    }
    if (divisionsResult case Success(data: final data?)) {
      divisionItems.assignAll(data);
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
