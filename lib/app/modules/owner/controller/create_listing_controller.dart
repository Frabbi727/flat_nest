import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/network/resource.dart';
import '../../../route/app_routes.dart';
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
  final selectedType = 'Family'.obs;
  final selectedAmenities = <int>[].obs;

  static const typeOptions = ['Family', 'Bachelor', 'Couple', 'Student', 'Sublet'];

  // Step 2 — Photos
  final photos = <File>[].obs;

  // Step 3 — Location
  final division = RxnString();
  final district = RxnString();
  final upazila = RxnString();
  final union = RxnString();
  final roadAndHouse = TextEditingController();
  final activeDropdown = RxnString();

  // Location hierarchy
  static const _locations = {
    'Dhaka': {
      'Dhaka': {
        'Gulshan': ['Gulshan 1', 'Gulshan 2', 'Niketan', 'Baridhara DOHS'],
        'Banani': ['Banani DOHS', 'Banani Block A', 'Banani Block C'],
        'Dhanmondi': ['Dhanmondi 27', 'Dhanmondi 32', 'Lalmatia'],
        'Mirpur': ['Mirpur 1', 'Mirpur 10', 'Mirpur 11', 'Pallabi'],
        'Mohammadpur': ['Mohammadpur', 'Adabor', 'Shyamoli'],
        'Uttara': ['Sector 3', 'Sector 7', 'Sector 11', 'Sector 13'],
      },
      'Gazipur': {
        'Gazipur Sadar': ['Joydebpur', 'Tongi', 'Konabari'],
      },
      'Narayanganj': {
        'Narayanganj Sadar': ['Fatullah', 'Siddhirganj'],
      },
    },
    'Chattogram': {
      'Chattogram': {
        'Panchlaish': ['Probortok', 'O.R. Nizam Road'],
        'Khulshi': ['East Khulshi', 'West Khulshi', 'GEC'],
      },
    },
    'Sylhet': {
      'Sylhet': {
        'Sylhet Sadar': ['Zindabazar', 'Amberkhana', 'Shahjalal Uposhohor'],
      },
    },
    'Khulna': {
      'Khulna': {
        'Khulna Sadar': ['Sonadanga', 'Khalishpur'],
      },
    },
    'Rajshahi': {
      'Rajshahi': {
        'Boalia': ['Shaheb Bazar', 'Uposhohor'],
      },
    },
  };

  List<String> get divisions => _locations.keys.toList();

  List<String> get districts {
    final div = division.value;
    if (div == null) return [];
    return (_locations[div] as Map<String, dynamic>?)?.keys.toList() ?? [];
  }

  List<String> get upazilas {
    final div = division.value;
    final dist = district.value;
    if (div == null || dist == null) return [];
    return ((_locations[div] as Map<String, dynamic>?)?[dist] as Map<String, dynamic>?)
            ?.keys
            .toList() ??
        [];
  }

  List<String> get unions {
    final div = division.value;
    final dist = district.value;
    final upa = upazila.value;
    if (div == null || dist == null || upa == null) return [];
    final list = ((_locations[div] as Map<String, dynamic>?)?[dist]
            as Map<String, dynamic>?)?[upa];
    return (list as List<dynamic>?)?.cast<String>() ?? [];
  }

  void pickDivision(String v) {
    division.value = v;
    district.value = null;
    upazila.value = null;
    union.value = null;
    activeDropdown.value = 'district';
  }

  void pickDistrict(String v) {
    district.value = v;
    upazila.value = null;
    union.value = null;
    activeDropdown.value = 'upazila';
  }

  void pickUpazila(String v) {
    upazila.value = v;
    union.value = null;
    activeDropdown.value = 'union';
  }

  void pickUnion(String v) {
    union.value = v;
    activeDropdown.value = null;
  }

  void toggleDropdown(String key) {
    activeDropdown.value = activeDropdown.value == key ? null : key;
  }

  bool get step1Valid {
    final title = titleController.text.trim();
    final price = int.tryParse(priceController.text.replaceAll(',', '')) ?? 0;
    final beds = int.tryParse(bedsController.text) ?? 0;
    final baths = int.tryParse(bathsController.text) ?? 0;
    return title.isNotEmpty && price > 0 && beds > 0 && baths > 0;
  }

  bool get step3Valid => union.value != null;

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
    final result = await _repo.createListing(
      title: titleController.text.trim(),
      type: selectedType.value,
      price: price,
      beds: beds,
      baths: baths,
      deposit: deposit,
      size: size,
      description: desc.isEmpty ? null : desc,
      amenities: selectedAmenities.isNotEmpty ? selectedAmenities.toList() : null,
    );
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

    showLoading();
    final result = await _repo.saveLocation(
      listingId: _listingId!,
      area: union.value!,
      roadAndHouse: roadAndHouse.text.trim().isEmpty ? null : roadAndHouse.text.trim(),
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
