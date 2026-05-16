import 'package:falt_nest_mobile_app/app/core/network/api_endpoints.dart';

import '../../../core/base/base_repository.dart';
import '../../../core/network/resource.dart';
import '../../listing/model/listing_model.dart';
import '../model/edit_listing_request.dart';

class OwnerRepository extends BaseRepository {
  OwnerRepository({required super.apiClient});

  Future<Resource<List<OwnerListingModel>>> getMyListings() async {
    try {
      final response = await apiClient.get(path: ApiEndpoints.ownerListings);
      return parseListResponse(response, OwnerListingModel.fromJson);
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
