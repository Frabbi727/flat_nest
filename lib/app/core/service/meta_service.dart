import 'package:get/get.dart';
import '../model/role_model.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../network/api_response.dart';
import '../../modules/listing/model/listing_facing_model.dart';
import '../../modules/listing/model/listing_type_model.dart';

class MetaService extends GetxService {
  final RxList<RoleModel> roles = <RoleModel>[].obs;
  final RxList<ListingTypeModel> listingTypes = <ListingTypeModel>[].obs;
  final RxList<ListingFacingModel> listingFacings = <ListingFacingModel>[].obs;
  final RxBool isLoaded = false.obs;

  Future<MetaService> init() async {
    final apiClient = Get.find<ApiClient>();
    await _fetchRoles(apiClient);
    return this;
  }

  Future<void> loadRoles() async {
    if (roles.isNotEmpty) return;
    await _fetchRoles(Get.find<ApiClient>());
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

  Future<void> _fetchRoles(ApiClient apiClient) async {
    try {
      final response = await apiClient.get(path: ApiEndpoints.metaRoles);
      final body = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (j) => (j as List)
            .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      if (body.success && body.data != null) {
        roles.value = body.data!;
      }
    } catch (_) {}
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
