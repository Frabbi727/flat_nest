import 'package:falt_nest_mobile_app/app/core/network/api_endpoints.dart';

import '../../../core/base/base_repository.dart';
import '../../../core/network/resource.dart';
import '../../listing/model/listing_model.dart';

class OwnerRepository extends BaseRepository {
  OwnerRepository({required super.apiClient});

  Future<Resource<List<OwnerListingModel>>> getMyListings() async {
    try {
      final response = await apiClient.get(path: ApiEndpoints.ownerListings);
      final data = (response.data['data'] as List<dynamic>)
          .map((e) => OwnerListingModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(data: data, statusCode: response.statusCode ?? 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

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

      final response = await apiClient.post(path: ApiEndpoints.listings, data: body);
      return Success(data: response.data as Map<String, dynamic>, statusCode: response.statusCode ?? 201);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<void>> deleteListing(String id) async {
    try {
      await apiClient.delete(path: ApiEndpoints.listing(id));
      return const Success(data: null, statusCode: 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }
}
