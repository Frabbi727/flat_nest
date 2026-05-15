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
      final data = (response.data['data'] as List<dynamic>)
          .map((e) => OwnerListingModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(data: data, statusCode: response.statusCode ?? 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<ListingModel>> editListing(
      String id, EditListingRequest request) async {
    try {
      final response = await apiClient.patch(
        path: ApiEndpoints.listing(id),
        data: request.toJson(),
      );
      return Success(
        data: ListingModel.fromJson(response.data as Map<String, dynamic>),
        statusCode: response.statusCode ?? 200,
      );
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
