import 'package:falt_nest_mobile_app/app/core/network/api_endpoints.dart';

import '../../../core/base/base_repository.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/resource.dart';
import '../../listing/model/geo_model.dart';
import '../../listing/model/listing_model.dart';
import '../../listing/model/listing_type_model.dart';

class ListingRepository extends BaseRepository {
  ListingRepository({required super.apiClient});

  Future<Resource<List<ListingModel>>> getListings({
    int? listingTypeId,
    int? maxPrice,
    List<int>? amenityIds,
    int? divisionId,
    int? districtId,
    int? upazilaId,
    int? unionId,
    String? search,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (listingTypeId != null) queryParams['listing_type_id'] = listingTypeId;
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice;
      if (amenityIds != null && amenityIds.isNotEmpty) {
        queryParams['amenities'] = amenityIds.join(',');
      }
      if (divisionId != null) queryParams['division_id'] = divisionId;
      if (districtId != null) queryParams['district_id'] = districtId;
      if (upazilaId != null) queryParams['upazila_id'] = upazilaId;
      if (unionId != null) queryParams['union_id'] = unionId;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

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

  Future<Resource<List<ListingTypeModel>>> getListingTypes() async {
    try {
      final response = await apiClient.get(path: ApiEndpoints.listingTypes);
      return parseListResponse(response, ListingTypeModel.fromJson);
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

  Future<Resource<List<GeoItemModel>>> getDivisions() async {
    try {
      final response = await apiClient.get(path: ApiEndpoints.geoDivisions);
      return parseListResponse(response, GeoItemModel.fromJson);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<List<GeoItemModel>>> getDistricts(int divisionId) async {
    try {
      final response =
          await apiClient.get(path: ApiEndpoints.geoDistricts(divisionId));
      return parseListResponse(response, GeoItemModel.fromJson);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<List<GeoItemModel>>> getUpazilas(int districtId) async {
    try {
      final response =
          await apiClient.get(path: ApiEndpoints.geoUpazilas(districtId));
      return parseListResponse(response, GeoItemModel.fromJson);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<List<GeoItemModel>>> getUnions(int upazilaId) async {
    try {
      final response =
          await apiClient.get(path: ApiEndpoints.geoUnions(upazilaId));
      return parseListResponse(response, GeoItemModel.fromJson);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }
}
