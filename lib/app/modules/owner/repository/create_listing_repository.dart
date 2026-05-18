import 'dart:io';
import 'package:dio/dio.dart';
import 'package:falt_nest/app/core/network/api_endpoints.dart';
import '../../../core/base/base_repository.dart';
import '../../../core/network/resource.dart';
import '../../listing/model/geo_model.dart';
import '../../listing/model/listing_facing_model.dart';
import '../../listing/model/listing_model.dart';
import '../../listing/model/listing_type_model.dart';
import '../model/create_listing_request.dart';
import '../model/edit_listing_request.dart';
import '../model/save_location_request.dart';

class CreateListingRepository extends BaseRepository {
  CreateListingRepository({required super.apiClient});

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

  Future<Resource<Map<String, dynamic>>> createListing(
      CreateListingRequest request) async {
    try {
      final response = await apiClient.post(
        path: ApiEndpoints.listings,
        data: request.toJson(),
      );
      return parseResponse<Map<String, dynamic>>(response, (j) => j);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<void>> uploadPhotos({
    required String listingId,
    required List<File> photos,
  }) async {
    try {
      final formData = FormData();
      for (final photo in photos) {
        formData.files.add(
          MapEntry(
            'photos[]',
            await MultipartFile.fromFile(
              photo.path,
              filename: photo.path.split('/').last,
            ),
          ),
        );
      }
      final response = await apiClient.post(
          path: ApiEndpoints.listingPhotos(listingId), data: formData);
      return parseVoidResponse(response);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<ListingModel>> saveLocation(
      String listingId, SaveLocationRequest request) async {
    try {
      final response = await apiClient.patch(
        path: ApiEndpoints.listingLocation(listingId),
        data: request.toJson(),
      );
      return parseResponse(response, ListingModel.fromJson);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<ListingModel>> updateOwnerInfo(
      String listingId, Map<String, dynamic> data) async {
    try {
      final response = await apiClient.patch(
        path: ApiEndpoints.listingOwnerInfo(listingId),
        data: data,
      );
      return parseResponse(response, ListingModel.fromJson);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<void>> submitListing({required String listingId}) async {
    try {
      final response = await apiClient.post(
          path: ApiEndpoints.listingSubmit(listingId), data: {});
      return parseVoidResponse(response);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<Map<String, dynamic>>> patchListing(
      String id, EditListingRequest request) async {
    try {
      final response = await apiClient.patch(
        path: ApiEndpoints.listing(id),
        data: request.toJson(),
      );
      return parseResponse<Map<String, dynamic>>(response, (j) => j);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }
}
