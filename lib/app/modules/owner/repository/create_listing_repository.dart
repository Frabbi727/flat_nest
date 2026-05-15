import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/base/base_repository.dart';
import '../../../core/network/resource.dart';

class CreateListingRepository extends BaseRepository {
  CreateListingRepository({required super.apiClient});

  Future<Resource<Map<String, dynamic>>> createListing({
    required String title,
    required String type,
    required int price,
    required int beds,
    required int baths,
    int? deposit,
    int? size,
    String? description,
    List<int>? amenities,
  }) async {
    try {
      final body = <String, dynamic>{
        'title': title,
        'type': type,
        'price': price,
        'beds': beds,
        'baths': baths,
      };
      if (deposit != null) body['deposit'] = deposit;
      if (size != null) body['size'] = size;
      if (description != null) body['description'] = description;
      if (amenities != null) body['amenities'] = amenities;

      final response = await apiClient.post('/listings', data: body);
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
      await apiClient.post('/listings/$listingId/photos', data: formData);
      return const Success(data: null, statusCode: 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<void>> saveLocation({
    required String listingId,
    required String area,
    String? roadAndHouse,
  }) async {
    try {
      final body = <String, dynamic>{'area': area};
      if (roadAndHouse != null) body['road_and_house'] = roadAndHouse;

      await apiClient.patch('/listings/$listingId/location', data: body);
      return const Success(data: null, statusCode: 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<void>> submitListing({required String listingId}) async {
    try {
      await apiClient.post('/listings/$listingId/submit', data: {});
      return const Success(data: null, statusCode: 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }
}
