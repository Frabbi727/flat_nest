import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/network/resource.dart';
import '../../listing/model/listing_model.dart';
import '../repository/listing_repository.dart';

class ListingDetailController extends BaseController {
  final ListingRepository _repo;

  ListingDetailController({required ListingRepository listingRepository})
      : _repo = listingRepository;

  final listing = Rxn<ListingModel>();
  final isRequestingAccess = false.obs;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is ListingModel) {
      listing.value = arg;
      _refreshSilently(arg.id);
    } else if (arg is String) {
      showLoading();
      _loadById(arg);
    }
  }

  // Background refresh — shows no loading spinner, keeps cached model on error
  Future<void> _refreshSilently(String id) async {
    final result = await _repo.getListingDetail(id);
    if (result case Success(data: final fresh?)) {
      listing.value = fresh;
    }
  }

  // Full load — used for deep-link navigation where only an ID is available
  Future<void> _loadById(String id) async {
    final result = await _repo.getListingDetail(id);
    hideLoading();
    switch (result) {
      case Success(data: final fresh?):
        listing.value = fresh;
      case Error(message: final msg):
        showError(msg);
      default:
        break;
    }
  }

  Future<void> requestAccess() async {
    final id = listing.value?.id;
    if (id == null) return;
    isRequestingAccess.value = true;
    final result = await _repo.requestAccess(id);
    isRequestingAccess.value = false;
    switch (result) {
      case Success(data: final req?):
        listing.value = listing.value!.copyWith(accessRequestStatus: req.status);
        Get.snackbar(
          'Request Sent',
          'The owner will be notified of your request.',
          snackPosition: SnackPosition.BOTTOM,
        );
      case Error(message: final msg):
        showError(msg);
      default:
        break;
    }
  }
}
