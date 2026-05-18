import 'package:falt_nest/app/core/network/api_endpoints.dart';
import 'package:falt_nest/app/core/network/api_response.dart';

import '../../../core/base/base_repository.dart';
import '../../../core/network/resource.dart';
import '../../listing/model/listing_model.dart';
import '../model/edit_listing_request.dart';
import '../model/owner_listings_page.dart';

class OwnerRepository extends BaseRepository {
  OwnerRepository({required super.apiClient});

  Future<Resource<OwnerListingsPage>> getMyListings({
    String? status,
    int? typeId,
    int page = 1,
  }) async {
    try {
      final Map<String, dynamic> params = {'page': page};
      if (status != null) params['status'] = status;
      if (typeId != null) params['type_id'] = typeId;

      final response = await apiClient.get(
        path: ApiEndpoints.ownerListings,
        queryParameters: params,
      );

      final raw = response.data as Map<String, dynamic>;
      final apiResp = ApiResponse.fromJson(raw, (j) {
        final dataList = (j as List)
            .map((e) => OwnerListingModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return dataList;
      });

      if (!apiResp.success) {
        return Error(apiResp.errorMessage, statusCode: response.statusCode ?? 500);
      }

      final meta = raw['meta'] as Map<String, dynamic>? ?? {};
      return Success(
        data: OwnerListingsPage(
          listings: apiResp.data ?? [],
          currentPage: (meta['current_page'] as num?)?.toInt() ?? page,
          lastPage: (meta['last_page'] as num?)?.toInt() ?? 1,
          perPage: (meta['per_page'] as num?)?.toInt() ?? 15,
          total: (meta['total'] as num?)?.toInt() ?? 0,
        ),
        statusCode: response.statusCode ?? 200,
      );
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<ListingModel>> editListing(
      String id, EditListingRequest request) async {
    try {
      final response = await apiClient.patch(
        path: ApiEndpoints.listing(id),
        data: request.toJson(),
      );
      return parseResponse(response, ListingModel.fromJson);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<void>> markRented(String id) async {
    try {
      final response = await apiClient.post(
          path: ApiEndpoints.listingMarkRented(id), data: {});
      return parseVoidResponse(response);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<void>> resubmitListing(String id) async {
    try {
      final response =
          await apiClient.post(path: ApiEndpoints.listingSubmit(id), data: {});
      return parseVoidResponse(response);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<void>> deleteListing(String id) async {
    try {
      final response =
          await apiClient.delete(path: ApiEndpoints.listing(id));
      return parseVoidResponse(response);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }
}
