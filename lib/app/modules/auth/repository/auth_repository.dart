import 'package:dio/dio.dart';
import 'package:falt_nest/app/core/network/api_endpoints.dart';

import '../../../core/base/base_repository.dart';
import '../../../core/network/resource.dart';
import '../model/user_model.dart';

class AuthRepository extends BaseRepository {
  AuthRepository({required super.apiClient});

  Future<Resource<AuthResponse>> login(String email, String password) async {
    try {
      final response = await apiClient.post(
        path: ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      return parseResponse(response, AuthResponse.fromJson);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e), code: parseErrorCode(e));
    }
  }

  Future<Resource<AuthResponse>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await apiClient.post(
        path: ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
        },
      );
      return parseResponse(response, AuthResponse.fromJson);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<void>> saveDetails({required String role}) async {
    try {
      final response = await apiClient.patch(
        path: ApiEndpoints.registerDetails,
        data: {'role': role},
      );
      return parseVoidResponse(response);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  // Returns the avatar URL string from the response (or null if not provided).
  Future<Resource<String?>> uploadAvatar(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });
      final response = await apiClient.patch(
        path: ApiEndpoints.registerAvatar,
        data: formData,
      );
      final body = response.data as Map<String, dynamic>?;
      final success = body?['success'] as bool? ?? false;
      if (!success) {
        return Error(body?['message'] as String? ?? 'Upload failed',
            statusCode: response.statusCode ?? 500);
      }
      final data = body?['data'];
      final avatarUrl = data is Map<String, dynamic>
          ? data['avatar_url'] as String?
          : null;
      return Success(data: avatarUrl, statusCode: response.statusCode ?? 200);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<AuthResponse>> googleSignIn(String idToken) async {
    try {
      final response = await apiClient.post(
        path: ApiEndpoints.googleSignIn,
        data: {'id_token': idToken},
      );
      return parseResponse(response, AuthResponse.fromJson);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<void>> logout() async {
    try {
      final response = await apiClient.post(path: ApiEndpoints.logout);
      return parseVoidResponse(response);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<void>> deleteAccount() async {
    try {
      final response = await apiClient.delete(path: ApiEndpoints.deleteAccount);
      return parseVoidResponse(response);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }
}
