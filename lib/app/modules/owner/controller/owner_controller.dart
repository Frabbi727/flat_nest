import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/network/resource.dart';
import '../../../core/service/auth_service.dart';
import '../../../route/app_routes.dart';
import '../../listing/model/listing_model.dart';
import '../repository/owner_repository.dart';

class OwnerController extends BaseController {
  final OwnerRepository _ownerRepository;
  final AuthService _authService = Get.find<AuthService>();

  OwnerController({required OwnerRepository ownerRepository})
      : _ownerRepository = ownerRepository;

  final activeTab = 0.obs;
  final myListings = <OwnerListingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyListings();
  }

  String get ownerName => (_authService.currentUser?.name ?? 'Owner').split(' ').first;
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

  void goToCreateListing() => Get.toNamed(Routes.createListing);

  void openListing(OwnerListingModel listing) {
    // Navigate to owner listing detail/edit
  }

  void logout() async {
    await _authService.logout();
    Get.offAllNamed(Routes.login);
  }
}
