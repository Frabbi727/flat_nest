import 'dart:io';
import 'package:dio/dio.dart';
import 'package:falt_nest_mobile_app/app/core/network/api_endpoints.dart';
import '../../../core/base/base_repository.dart';
import '../../../core/network/resource.dart';
import '../../listing/model/geo_model.dart';
import '../../listing/model/listing_model.dart';
import '../../listing/model/listing_type_model.dart';
import '../model/create_listing_request.dart';
import '../model/save_location_request.dart';

class CreateListingRepository extends BaseRepository {
  CreateListingRepository({required super.apiClient});

  Future<Resource<List<ListingTypeModel>>> getListingTypes() async {
    try {
      final response = await apiClient.get(path: ApiEndpoints.listingTypes);
      final list = (response.data as List<dynamic>)
          .map((e) => ListingTypeModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(data: list, statusCode: response.statusCode ?? 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<List<AmenityModel>>> getAmenities() async {
    try {
      final response = await apiClient.get(path: ApiEndpoints.amenities);
      final list = (response.data as List<dynamic>)
          .map((e) => AmenityModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(data: list, statusCode: response.statusCode ?? 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<List<GeoItemModel>>> getDivisions() async {
    try {
      final response = await apiClient.get(path: ApiEndpoints.geoDivisions);
      final list = (response.data as List<dynamic>)
          .map((e) => GeoItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(data: list, statusCode: response.statusCode ?? 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<List<GeoItemModel>>> getDistricts(int divisionId) async {
    try {
      final response =
          await apiClient.get(path: ApiEndpoints.geoDistricts(divisionId));
      final list = (response.data as List<dynamic>)
          .map((e) => GeoItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(data: list, statusCode: response.statusCode ?? 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<List<GeoItemModel>>> getUpazilas(int districtId) async {
    try {
      final response =
          await apiClient.get(path: ApiEndpoints.geoUpazilas(districtId));
      final list = (response.data as List<dynamic>)
          .map((e) => GeoItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(data: list, statusCode: response.statusCode ?? 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<List<GeoItemModel>>> getUnions(int upazilaId) async {
    try {
      final response =
          await apiClient.get(path: ApiEndpoints.geoUnions(upazilaId));
      final list = (response.data as List<dynamic>)
          .map((e) => GeoItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(data: list, statusCode: response.statusCode ?? 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<Map<String, dynamic>>> createListing(
      CreateListingRequest request) async {
    try {
      final response = await apiClient.post(
        path: ApiEndpoints.listings,
        data: request.toJson(),
      );
      return Success(
        data: response.data as Map<String, dynamic>,
        statusCode: response.statusCode ?? 201,
      );
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
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
      await apiClient.post(path: ApiEndpoints.listingPhotos(listingId), data: formData);
      return const Success(data: null, statusCode: 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<void>> saveLocation(
      String listingId, SaveLocationRequest request) async {
    try {
      await apiClient.patch(
        path: ApiEndpoints.listingLocation(listingId),
        data: request.toJson(),
      );
      return const Success(data: null, statusCode: 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<void>> submitListing({required String listingId}) async {
    try {
      await apiClient.post(path: ApiEndpoints.listingSubmit(listingId), data: {});
      return const Success(data: null, statusCode: 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }
}
