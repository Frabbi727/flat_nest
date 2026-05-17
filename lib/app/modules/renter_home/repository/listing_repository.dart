import 'package:falt_nest_mobile_app/app/core/network/api_endpoints.dart';

import '../../../core/base/base_repository.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/resource.dart';

import '../../listing/model/geo_model.dart';
import '../../listing/model/listing_facing_model.dart';
import '../../listing/model/listing_model.dart';
import '../../listing/model/listing_type_model.dart';

class ListingRepository extends BaseRepository {
  ListingRepository({required super.apiClient});

  Future<Resource<List<ListingModel>>> getListings({
    int? listingTypeId,
    int? priceMin,
    int? priceMax,
    int? baths,
    int? facingId,
    int? floorMin,
    int? floorMax,
    int? sizeMin,
    int? sizeMax,
    String? availableFromStart,
    String? availableFromEnd,
    String? sortBy,
    List<int>? amenityIds,
    int? divisionId,
    int? districtId,
    int? upazilaId,
    int? unionId,
    String? search,
    int? beds,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (listingTypeId != null) queryParams['listing_type_id'] = listingTypeId;
      if (priceMin != null) queryParams['price_min'] = priceMin;
      if (priceMax != null) queryParams['price_max'] = priceMax;
      if (baths != null) queryParams['baths'] = baths;
      if (facingId != null) queryParams['facing_id'] = facingId;
      if (floorMin != null) queryParams['floor_min'] = floorMin;
      if (floorMax != null) queryParams['floor_max'] = floorMax;
      if (sizeMin != null) queryParams['size_min'] = sizeMin;
      if (sizeMax != null) queryParams['size_max'] = sizeMax;
      if (availableFromStart != null) {
        queryParams['available_from_start'] = availableFromStart;
      }
      if (availableFromEnd != null) {
        queryParams['available_from_end'] = availableFromEnd;
      }
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      if (amenityIds != null && amenityIds.isNotEmpty) {
        queryParams['amenities'] = amenityIds.join(',');
      }
      if (beds != null) queryParams['beds'] = beds;
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

  Future<Resource<List<ListingModel>>> fetchNearbyListings({
    required double coordX, // user longitude → coord_x
    required double coordY, // user latitude  → coord_y
    double? radius,
    int? listingTypeId,
    int? priceMin,
    int? priceMax,
    int? beds,
    int? baths,
  }) async {
    try {
      final params = <String, dynamic>{
        'coord_x': coordX,
        'coord_y': coordY,
      };
      if (radius != null) params['radius'] = radius;
      if (listingTypeId != null) params['listing_type_id'] = listingTypeId;
      if (priceMin != null) params['price_min'] = priceMin;
      if (priceMax != null) params['price_max'] = priceMax;
      if (beds != null) params['beds'] = beds;
      if (baths != null) params['baths'] = baths;
      final response = await apiClient.get(
        path: ApiEndpoints.nearbyListings,
        queryParameters: params,
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

  Future<Resource<List<ListingModel>>> getWishlist() async {
    try {
      final response = await apiClient.get(path: ApiEndpoints.wishlist);
      return parseListResponse(response, ListingModel.fromJson);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<bool>> toggleWishlist(String listingId) async {
    try {
      final response =
          await apiClient.post(path: ApiEndpoints.wishlistToggle(listingId));
      final body = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (j) => (j as Map<String, dynamic>)['saved'] as bool,
      );
      if (body.success) {
        return Success(
            data: body.data ?? false, statusCode: response.statusCode ?? 200);
      }
      return Error(body.errorMessage, statusCode: response.statusCode ?? 500);
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

  Future<Resource<List<ListingFacingModel>>> fetchListingFacings() async {
    try {
      final response =
          await apiClient.get(path: ApiEndpoints.metaListingFacings);
      return parseListResponse(response, ListingFacingModel.fromJson);
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
