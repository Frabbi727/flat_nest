import '../../../core/base/base_repository.dart';
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
        '/listings',
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      final data = (response.data['data'] as List<dynamic>)
          .map((e) => ListingModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Success(data: data, statusCode: response.statusCode ?? 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<ListingModel>> getListingDetail(String id) async {
    try {
      final response = await apiClient.get('/listings/$id');
      final listing = ListingModel.fromJson(
          response.data['data'] as Map<String, dynamic>);
      return Success(data: listing, statusCode: response.statusCode ?? 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<List<String>>> getWishlist() async {
    try {
      final response = await apiClient.get('/wishlist');
      final ids = (response.data['saved_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList();
      return Success(data: ids, statusCode: response.statusCode ?? 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<void>> saveToWishlist(String listingId) async {
    try {
      await apiClient.post('/wishlist/$listingId');
      return const Success(data: null, statusCode: 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<void>> removeFromWishlist(String listingId) async {
    try {
      await apiClient.delete('/wishlist/$listingId');
      return const Success(data: null, statusCode: 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<List<AmenityModel>>> getAmenities() async {
    try {
      final response = await apiClient.get('/amenities');
      final data = (response.data as List<dynamic>)
          .map((e) => AmenityModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(data: data, statusCode: response.statusCode ?? 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }
}
