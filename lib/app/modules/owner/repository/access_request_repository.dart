import '../../../core/base/base_repository.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/resource.dart';
import '../model/access_request_model.dart';

int? _parseInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString());
}

class AccessRequestRepository extends BaseRepository {
  AccessRequestRepository({required super.apiClient});

  Future<Resource<AccessRequestsPage>> getAccessRequests({
    String? status,
    int page = 1,
  }) async {
    try {
      final params = <String, dynamic>{'page': page};
      if (status != null) params['status'] = status;

      final response = await apiClient.get(
        path: ApiEndpoints.ownerAccessRequests,
        queryParameters: params,
      );

      final raw = response.data as Map<String, dynamic>;
      final apiResp = ApiResponse.fromJson(raw, (j) {
        final dataList = (j as List)
            .map((e) => AccessRequestModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return dataList;
      });

      if (!apiResp.success) {
        return Error(apiResp.errorMessage,
            statusCode: response.statusCode ?? 500);
      }

      final meta = raw['meta'] as Map<String, dynamic>? ?? {};
      return Success(
        data: AccessRequestsPage(
          requests: apiResp.data ?? [],
          currentPage: _parseInt(meta['current_page']) ?? page,
          lastPage: _parseInt(meta['last_page']) ?? 1,
          perPage: _parseInt(meta['per_page']) ?? 15,
          total: _parseInt(meta['total']) ?? 0,
        ),
        statusCode: response.statusCode ?? 200,
      );
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<AccessRequestModel>> acceptRequest(String requestId) async {
    try {
      final response = await apiClient.post(
        path: ApiEndpoints.ownerAccessRequestAccept(requestId),
        data: {},
      );
      return parseResponse(
          response, (j) => AccessRequestModel.fromJson(j as Map<String, dynamic>));
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<AccessRequestModel>> rejectRequest(String requestId) async {
    try {
      final response = await apiClient.post(
        path: ApiEndpoints.ownerAccessRequestReject(requestId),
        data: {},
      );
      return parseResponse(
          response, (j) => AccessRequestModel.fromJson(j as Map<String, dynamic>));
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }
}
