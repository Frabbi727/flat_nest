import 'package:get/get.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../../modules/listing/model/listing_facing_model.dart';
import '../../modules/listing/model/listing_type_model.dart';

class MetaService extends GetxService {
  final RxList<ListingTypeModel> listingTypes = <ListingTypeModel>[].obs;
  final RxList<ListingFacingModel> listingFacings = <ListingFacingModel>[].obs;
  final RxBool isLoaded = false.obs;

  Future<MetaService> init() async {
    return this;
  }

  Future<void> loadMeta() async {
    if (isLoaded.value) return;
    final apiClient = Get.find<ApiClient>();
    await Future.wait([
      _fetchListingTypes(apiClient),
      _fetchListingFacings(apiClient),
    ]);
    isLoaded.value = true;
  }

  Future<void> _fetchListingTypes(ApiClient apiClient) async {
    try {
      final response =
          await apiClient.get(path: ApiEndpoints.metaListingTypes);
      final raw = response.data as Map<String, dynamic>;
      if (raw['success'] == true && raw['data'] is List) {
        listingTypes.value = (raw['data'] as List)
            .map((e) =>
                ListingTypeModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
  }

  Future<void> _fetchListingFacings(ApiClient apiClient) async {
    try {
      final response =
          await apiClient.get(path: ApiEndpoints.metaListingFacings);
      final raw = response.data as Map<String, dynamic>;
      if (raw['success'] == true && raw['data'] is List) {
        listingFacings.value = (raw['data'] as List)
            .map((e) =>
                ListingFacingModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
  }
}
