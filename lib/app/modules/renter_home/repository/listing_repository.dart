import 'package:falt_nest_mobile_app/app/core/network/api_endpoints.dart';

import '../../../core/base/base_repository.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/resource.dart';
import '../../listing/model/listing_model.dart';

class ListingRepository extends BaseRepository {
  ListingRepository({required super.apiClient});

  Future<Resource<List<ListingModel>>> getListings({
    String? type,
    int? maxPrice,
    List<int>? amenities,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (type != null) queryParams['type'] = type;
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice;
      if (amenities != null && amenities.isNotEmpty) {
        queryParams['amenities'] = amenities.join(',');
      }

      final response = await apiClient.get(
        path: ApiEndpoints.listings,
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );
      return parseListResponse(response, ListingModel.fromJson);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<ListingModel>> getListingDetail(String id) async {
    try {
      final response = await apiClient.get(path: ApiEndpoints.listing(id));
      return parseResponse(response, ListingModel.fromJson);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<List<String>>> getWishlist() async {
    try {
      final response = await apiClient.get(path: ApiEndpoints.wishlist);
      final body = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (j) => (j as List).map((e) => e as String).toList(),
      );
      if (body.success) {
        return Success(
            data: body.data ?? [], statusCode: response.statusCode ?? 200);
      }
      return Error(body.errorMessage, statusCode: response.statusCode ?? 500);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<void>> saveToWishlist(String listingId) async {
    try {
      final response =
          await apiClient.post(path: ApiEndpoints.wishlistItem(listingId));
      return parseVoidResponse(response);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<void>> removeFromWishlist(String listingId) async {
    try {
      final response =
          await apiClient.delete(path: ApiEndpoints.listing(listingId));
      return parseVoidResponse(response);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<List<AmenityModel>>> getAmenities() async {
    try {
      final response = await apiClient.get(path: ApiEndpoints.amenities);
      return parseListResponse(response, AmenityModel.fromJson);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }
}
